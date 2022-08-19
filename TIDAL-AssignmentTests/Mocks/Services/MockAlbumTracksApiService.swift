//
//  MockAlbumTracksApiService.swift
//  TIDAL-AssignmentTests
//
//  Created by Alberto Sendra Estrella on 19/8/22.
//

import Foundation
@testable import TIDAL_Assignment

final class MockAlbumTracksApiService: AlbumTracksService  {
    
    let apiClient: Client

    // MARK: - Init
    init(client: Client) {
        apiClient = client
    }
    
    func getTracks(forAlbum album: Album, completion: @escaping (Result<[Track], Error>) -> Void) {
        
        let trackArtist = TrackArtist(id: 23, name: "Track Artist")
        
        switch(album.id) {
        case 1:
            let tracksArray = [Track(id: 7,
                                     title: "Test Track",
                                     duration: 100,
                                     trackPosition: 1,
                                     diskNumber: 1,
                                     artist: trackArtist)]
            completion(.success(tracksArray))
        case 2:
            let tracksArray = [Track(id: 7,
                                     title: "Test Track 1",
                                     duration: 100,
                                     trackPosition: 1,
                                     diskNumber: 1,
                                     artist: trackArtist),
                               Track(id: 8,
                                     title: "Test Track 2",
                                     duration: 200,
                                     trackPosition: 1,
                                     diskNumber: 2,
                                     artist: trackArtist)]
            completion(.success(tracksArray))
        case 3:
            let tracksArray = [Track(id: 7,
                                     title: "Test Track 1",
                                     duration: 100,
                                     trackPosition: 1,
                                     diskNumber: 1,
                                     artist: trackArtist),
                               Track(id: 8,
                                     title: "Test Track 2",
                                     duration: 200,
                                     trackPosition: 2,
                                     diskNumber: 1,
                                     artist: trackArtist)]
            completion(.success(tracksArray))
        default:
            fatalError("Test case not handled!")
        }
    }
}
