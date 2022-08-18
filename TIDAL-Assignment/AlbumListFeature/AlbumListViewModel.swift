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
    func fetchMoreAlbums()
}

class AlbumListViewModel {

    // MARK: - Delegates
    weak var viewDelegate: AlbumListViewModelViewDelegate?

    // MARK: - Properties
    fileprivate let service: AlbumListService
    fileprivate let artist: Artist
    fileprivate var albums = [Album]()
    fileprivate var albumInfo = [Int: AlbumInfoResponse]()
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
        let startIndex = albums.count
        let endIndex = startIndex + newAlbums.count
        return (startIndex..<endIndex).map { IndexPath(row: $0, section: 0) }
    }
    
    private func processAlbumListResponse(_ response: AlbumListResponse, reload: Bool) {
        let updatedPaths = calculateIndexPathsToReload(from: response.data)
        totalCount = response.total
        offset += response.data.count
        albums += response.data
        viewDelegate?.updateAlbums(for: (reload) ? updatedPaths : nil)
        
        // Async fetch album metadata
        fetchAlbumInfo(for: updatedPaths)
    }
    
    // MARK: - Network
    
    func fetchAlbums() {
        viewDelegate?.updateState(.loading)
        service.getAlbums(forArtist: artist, offset: nil) { [weak self] result in
            switch result {
            case .success(let response):
                self?.processAlbumListResponse(response, reload: false)
                self?.viewDelegate?.updateState(.content)
            case .failure(let error):
                self?.viewDelegate?.updateState(.error(message: error.localizedDescription))
            }
        }
    }
    
    func fetchAlbumInfo(for indexPaths: [IndexPath]) {
        
        let concurrentCalls = 4
        let semaphore = DispatchSemaphore(value: concurrentCalls)
        let backgroundQueue = DispatchQueue(label: "Background queue")
        
        for path in indexPaths {
            let album = albumFor(row: path.row)
            if albumInfo[album.id] == nil {
                backgroundQueue.async { [weak self] in
                    semaphore.wait()
                    self?.service.getAlbumInfo(album) { [weak self] result in
                        switch result {
                        case .success(let response):
                            self?.albumInfo[album.id] = response
                            self?.viewDelegate?.updateAlbums(for: [path])
                        case .failure(_):
                            self?.albumInfo[album.id] = nil
                        }
                        semaphore.signal()
                    }
                }
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
        let album = albumFor(row: row)
        if let info = albumInfo[album.id] {
            return AlbumCellData(album: album, contributors: info.contributors)
        }
        else {
            return AlbumCellData(album: album, contributors: [artist])
        }
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
                self?.processAlbumListResponse(response, reload: true)
            case .failure(let error):
                self?.viewDelegate?.updateState(.error(message: error.localizedDescription))
            }
        }
    }
}
