//
//  SearchArtistViewModel.swift
//  TIDAL-Assignment
//
//  Created by Alberto Sendra Estrella on 17/8/22.
//

import Foundation

protocol SearchArtistViewModelViewDelegate: AnyObject {
    func updateArtists(for indexPaths: [IndexPath]?)
    func updateState(_ state: ViewControllerState)
}

protocol SearchArtistViewModelType {
    // Delegates
    var viewDelegate: SearchArtistViewModelViewDelegate? { get set }
    // Data Source
    func numberOfArtists() -> Int
    func artistFor(row: Int) -> Artist
    func artistDataFor(row: Int) -> ArtistCellDataType
    func isLoading(for indexPath: IndexPath) -> Bool
    // Events
    func start()
    func searchFor(text: String)
    func fetchMoreArtists()
}

class SearchArtistViewModel {

    // MARK: - Delegates
    weak var viewDelegate: SearchArtistViewModelViewDelegate?

    // MARK: - Properties
    fileprivate let service: SearchArtistService
    fileprivate var artists = [Artist]()
    fileprivate var totalCount = 0
    fileprivate var offset = 0
    fileprivate var currentSearchTerm = ""
    fileprivate var searchTask: DispatchWorkItem?
    fileprivate var isSearching = false
    fileprivate var isPreFetching = false

    // MARK: - Init
    
    init(service: SearchArtistService) {
        self.service = service
    }
    
    // MARK: - Private
    
    func resetSearch() {
        isSearching = false
        isPreFetching = false
        totalCount = 0
        offset = 0
        artists = []
        viewDelegate?.updateState(.empty)
        viewDelegate?.updateArtists(for: nil)
    }
    
    private func calculateIndexPathsToReload(from newArtists: [Artist]) -> [IndexPath] {
      let startIndex = artists.count
      let endIndex = startIndex + newArtists.count
      return (startIndex..<endIndex).map { IndexPath(row: $0, section: 0) }
    }
    
    // MARK: - Network
    
    @objc func fetchArtists(text: String) {
        currentSearchTerm = text
        offset = 0
        artists = []
        isSearching = true
        viewDelegate?.updateState(.loading)
        service.getArtists(withText: text, offset: nil) { [weak self] result in
            self?.isSearching = false
            switch result {
            case .success(let response):
                self?.processSearchResponse(response: response, reload: false)
                self?.viewDelegate?.updateState(.content)
            case .failure(let error):
                self?.viewDelegate?.updateState(.error(message: error.localizedDescription))
            }
        }
    }
    
    func processSearchResponse(response: SearchArtistResponse, reload: Bool) {
        let updatedPaths = (reload) ? calculateIndexPathsToReload(from: response.data) : nil
        totalCount = response.total
        offset += response.data.count
        artists += response.data
        viewDelegate?.updateArtists(for: updatedPaths)
    }
}

extension SearchArtistViewModel: SearchArtistViewModelType {
    
    // MARK: - Data Source

    func numberOfArtists() -> Int {
        return totalCount
    }
    
    func artistFor(row: Int) -> Artist {
        return artists[row]
    }
    
    func artistDataFor(row: Int) -> ArtistCellDataType {
        return ArtistCellData(artist: artistFor(row: row))
    }
    
    func isLoading(for indexPath: IndexPath) -> Bool {
        return indexPath.row >= artists.count
    }
    
    // MARK: - Events
    
    func start() {
        viewDelegate?.updateState(.empty)
    }
    
    func searchFor(text: String) {
        
        guard text != currentSearchTerm else { return }
        
        guard !text.isEmpty else {
            resetSearch()
            return
        }

        searchTask?.cancel()
        
        let task = DispatchWorkItem { [weak self] in
            self?.fetchArtists(text: text)
        }
        
        self.searchTask = task

        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5, execute: task)
    }
    
    func fetchMoreArtists() {
        
        guard !isPreFetching else {
            return
        }
        
        isPreFetching = true
        service.getArtists(withText: currentSearchTerm, offset: offset) { [weak self] result in
            self?.isPreFetching = false
            switch result {
            case .success(let response):
                self?.processSearchResponse(response: response, reload: true)
            case .failure(let error):
                self?.viewDelegate?.updateState(.error(message: error.localizedDescription))
            }
        }
    }
}
