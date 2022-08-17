//
//  SearchArtistViewModel.swift
//  TIDAL-Assignment
//
//  Created by Alberto Sendra Estrella on 17/8/22.
//

import Foundation

protocol SearchArtistViewModelViewDelegate: AnyObject {
    func updateScreen()
    func updateState(_ state: ViewControllerState)
}

protocol SearchArtistViewModelType {
    // Delegates
    var viewDelegate: SearchArtistViewModelViewDelegate? { get set }
    // Data Source
    func numberOfItems() -> Int
    func itemFor(row: Int) -> Artist
    // Events
    func start()
    func searchFor(text: String)
}

class SearchArtistViewModel {

    // MARK: - Delegates
    weak var viewDelegate: SearchArtistViewModelViewDelegate?

    // MARK: - Properties
    fileprivate let service: SearchArtistService
    fileprivate var artists = [Artist]()
    fileprivate var offset = 0
    fileprivate var currentSearchTerm = ""
    fileprivate var searchTask: DispatchWorkItem?
    fileprivate var isSearching = false

    // MARK: - Init
    
    init(service: SearchArtistService) {
        self.service = service
    }
    
    // MARK: - Network
    
    @objc func getArtists(text: String) {
        print("Searching term: " + text)
        currentSearchTerm = text
        service.getArtists(withText: text, offset: nil) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let artists):
                    self?.artists = artists
                    self?.viewDelegate?.updateState(.content)
                    self?.viewDelegate?.updateScreen()
                case .failure(_):
                    self?.viewDelegate?.updateState(.error)
                }
            }
        }
    }
}

extension SearchArtistViewModel: SearchArtistViewModelType {
    
    // MARK: - Data Source

    func numberOfItems() -> Int {
        return artists.count
    }
    
    func itemFor(row: Int) -> Artist {
        return artists[row]
    }
    
    // MARK: - Events
    
    func start() {
        viewDelegate?.updateState(.empty)
    }
    
    func searchFor(text: String) {
        
        guard !text.isEmpty else {
            isSearching = false
            viewDelegate?.updateState(.empty)
            return
        }

        viewDelegate?.updateState(.loading)
        isSearching = true
        
        searchTask?.cancel()
        
        let task = DispatchWorkItem { [weak self] in
            self?.getArtists(text: text)
        }
        
        self.searchTask = task

        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5, execute: task)
    }
}
