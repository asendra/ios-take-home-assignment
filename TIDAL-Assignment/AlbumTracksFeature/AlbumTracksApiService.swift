//
//  AlbumTracksApiService.swift
//  TIDAL-Assignment
//
//  Created by Alberto Sendra Estrella on 17/8/22.
//

import Foundation

protocol AlbumTracksService {
    func getTracks(forAlbum album: Album, completion: @escaping (Result<[Track], Error>) -> Void)
}

final class AlbumTracksApiService {
    
    let apiClient: Client

    // MARK: - Init
    init(client: Client) {
        apiClient = client
    }
}

// MARK: - API

extension AlbumTracksApiService: AlbumTracksService {
    func getTracks(forAlbum album: Album, completion: @escaping (Result<[Track], Error>) -> Void) {
        let resource = Resource<TrackListResponse>(get: "album/\(album.id)/tracks")
        apiClient.load(resource: resource) { result in
            if let result = result {
                completion(.success(result.data))
            }
            else {
                completion(.failure(APIError.invalidJSONResponse))
            }
        }
    }
}
