//
//  AlbumInfoApiService.swift
//  TIDAL-Assignment
//
//  Created by Alberto Sendra Estrella on 17/8/22.
//

import Foundation

protocol AlbumInfoService {
    func getTracks(forAlbum album: Album, completion: @escaping (Result<[Track], Error>) -> Void)
}

final class AlbumInfoApiService {
    
    let apiClient: ApiClient

    // MARK: - Init
    init(client: ApiClient) {
        apiClient = client
    }
}

// MARK: - API

extension AlbumInfoApiService: AlbumInfoService {
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
