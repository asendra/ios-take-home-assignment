//
//  AlbumListViewModel.swift
//  TIDAL-Assignment
//
//  Created by Alberto Sendra Estrella on 18/8/22.
//

import Foundation

protocol AlbumListViewModelViewDelegate: AnyObject {
    func updateAlbums(for indexPaths: [IndexPath]?)
    func updateState(_ state: ViewControllerState)
}

protocol AlbumListViewModelType {
    // Delegates
    var viewDelegate: AlbumListViewModelViewDelegate? { get set }
    // Data Source
    func artistName() -> String
    func numberOfAlbums() -> Int
    func albumFor(row: Int) -> Album
    func albumDataFor(row: Int) -> AlbumCellDataType
    func isLoading(for indexPath: IndexPath) -> Bool
    // Events
    func start()
    //func searchFor(text: String)
    func fetchMoreAlbums()
}

class AlbumListViewModel {

    // MARK: - Delegates
    weak var viewDelegate: AlbumListViewModelViewDelegate?

    // MARK: - Properties
    fileprivate let service: AlbumListService
    fileprivate let artist: Artist
    fileprivate var albums = [Album]()
    fileprivate var totalCount = 0
    fileprivate var offset = 0
    fileprivate var isPreFetching = false

    // MARK: - Init
    
    init(service: AlbumListService, artist: Artist) {
        self.service = service
        self.artist = artist
    }
    
    // MARK: - Private
    
    private func calculateIndexPathsToReload(from newAlbums: [Album]) -> [IndexPath] {
      let startIndex = albums.count - newAlbums.count
      let endIndex = startIndex + newAlbums.count
      return (startIndex..<endIndex).map { IndexPath(row: $0, section: 0) }
    }
    
    // MARK: - Network
    
    @objc func fetchAlbums() {
        viewDelegate?.updateState(.loading)
        service.getAlbums(forArtist: artist, offset: nil) { [weak self] result in
            switch result {
            case .success(let response):
                self?.totalCount = response.total
                self?.offset = response.data.count
                self?.albums = response.data
                self?.viewDelegate?.updateState(.content)
                self?.viewDelegate?.updateAlbums(for: nil)
            case .failure(let error):
                self?.viewDelegate?.updateState(.error(message: error.localizedDescription))
            }
        }
    }
}

extension AlbumListViewModel: AlbumListViewModelType {
    
    // MARK: - Data Source

    func artistName() -> String {
        return artist.name
    }
    
    func numberOfAlbums() -> Int {
        return totalCount
    }
    
    func albumFor(row: Int) -> Album {
        return albums[row]
    }
    
    func albumDataFor(row: Int) -> AlbumCellDataType {
        return AlbumCellData(album: albumFor(row: row))
    }
    
    func isLoading(for indexPath: IndexPath) -> Bool {
        return indexPath.row >= albums.count
    }
    
    // MARK: - Events
    
    func start() {
        self.fetchAlbums()
    }
    
    func fetchMoreAlbums() {
        
        guard !isPreFetching else {
            return
        }
        
        isPreFetching = true
        service.getAlbums(forArtist: artist, offset: offset) { [weak self] result in
            self?.isPreFetching = false
            switch result {
            case .success(let response):
                let updatedPaths = self?.calculateIndexPathsToReload(from: response.data)
                self?.offset += response.data.count
                self?.albums += response.data
                self?.viewDelegate?.updateAlbums(for: updatedPaths)
            case .failure(let error):
                self?.viewDelegate?.updateState(.error(message: error.localizedDescription))
            }
        }
    }
}
