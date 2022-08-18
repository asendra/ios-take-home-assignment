//
//  AlbumTracksViewModel.swift
//  TIDAL-Assignment
//
//  Created by Alberto Sendra Estrella on 18/8/22.
//

import Foundation

protocol AlbumTracksViewModelViewDelegate: AnyObject {
    func updateTracks()
    func updateState(_ state: ViewControllerState)
}

protocol AlbumTracksViewModelType {
    // Delegates
    var viewDelegate: AlbumTracksViewModelViewDelegate? { get set }
    // Data Source
    func artistName() -> String
    func albumName() -> String
    func albumCover() -> URL
    func volumeNameFor(section: Int) -> String
    func numberOfVolumes() -> Int
    func numberOfTracksFor(section: Int) -> Int
    func trackDataFor(path: IndexPath) -> TrackCellDataType
    // Events
    func start()
}

class AlbumTracksViewModel {

    // MARK: - Delegates
    weak var viewDelegate: AlbumTracksViewModelViewDelegate?

    // MARK: - Properties
    fileprivate let service: AlbumTracksService
    fileprivate let artist: Artist
    fileprivate var album: Album
    fileprivate var sections = [Int: [Track]]()
    
    // MARK: - Init
    
    init(service: AlbumTracksService, artist: Artist, album: Album) {
        self.service = service
        self.artist = artist
        self.album = album
    }
    
    // MARK: - Private
    
    // MARK: - Network
    
    func fetchTracks() {
        viewDelegate?.updateState(.loading)
        service.getTracks(forAlbum: album) { [weak self] result in
            switch result {
            case .success(let tracks):
                for track in tracks {
                    let fixedDiskNumber = track.diskNumber-1
                    if var tracks = self?.sections[fixedDiskNumber] {
                        tracks.append(track)
                        self?.sections[fixedDiskNumber] = tracks
                    }
                    else {
                        self?.sections[fixedDiskNumber] = [track]
                    }
                }
                self?.viewDelegate?.updateTracks()
                self?.viewDelegate?.updateState(.content)
            case .failure(let error):
                self?.viewDelegate?.updateState(.error(message: error.localizedDescription))
            }
        }
    }
}

extension AlbumTracksViewModel: AlbumTracksViewModelType {
    // MARK: - Data Source

    func artistName() -> String {
        return artist.name
    }
    
    func albumName() -> String {
        return album.title
    }
    
    func albumCover() -> URL {
        return album.coverXL
    }
    
    func volumeNameFor(section: Int) -> String {
        return "Volume \(section+1)"
    }
    
    func numberOfVolumes() -> Int {
        return sections.count
    }
    
    func numberOfTracksFor(section: Int) -> Int {
        return sections[section]?.count ?? 0
    }

    func trackDataFor(path: IndexPath) -> TrackCellDataType {
        let track = sections[path.section]![path.row]
        return TrackCellData(track: track)
    }
    
    // MARK: - Events
    
    func start() {
        self.fetchTracks()
    }
}
