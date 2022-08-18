//
//  AlbumListApiService.swift
//  TIDAL-Assignment
//
//  Created by Alberto Sendra Estrella on 17/8/22.
//

import Foundation

protocol AlbumListService {
    func getAlbums(forArtist artist: Artist, offset: Int?, completion: @escaping (Result<AlbumListResponse, Error>) -> Void)
}

final class AlbumListApiService {
    
    let apiClient: ApiClient

    // MARK: - Init
    init(client: ApiClient) {
        apiClient = client
    }
}

// MARK: - API

extension AlbumListApiService: AlbumListService {
    func getAlbums(forArtist artist: Artist, offset: Int?, completion: @escaping (Result<AlbumListResponse, Error>) -> Void){
        
        var path = "artist/\(artist.id)/albums"
        if let index = offset {
            path += "&index=\(index)"
        }
        
        let resource = Resource<AlbumListResponse>(get: path)
        apiClient.load(resource: resource) { result in
            if let result = result {
                completion(.success(result))
            }
            else {
                completion(.failure(APIError.invalidJSONResponse))
            }
        }
    }
}
