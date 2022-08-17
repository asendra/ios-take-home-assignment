//
//  SearchArtistApiService.swift
//  TIDAL-Assignment
//
//  Created by Alberto Sendra Estrella on 17/8/22.
//

import Foundation

protocol SearchArtistService {
    func getArtists(withText text: String, offset: Int?, completion: @escaping (Result<[Artist], Error>) -> Void)
}

final class SearchArtistApiService {
    
    let apiClient: ApiClient

    // MARK: - Init
    init(client: ApiClient) {
        apiClient = client
    }
}

// MARK: - API

extension SearchArtistApiService: SearchArtistService {
    func getArtists(withText text: String, offset: Int?, completion: @escaping (Result<[Artist], Error>) -> Void) {
        
        var path = "search/artist?q=\(text)"
        if let index = offset {
            path += "&index=\(index)"
        }
        
        let artistsResource = Resource<ArtistResponse>(get: path)
        apiClient.load(resource: artistsResource) { result in
            if let result = result {
                completion(.success(result.data))
            }
            else {
                completion(.failure(APIError.invalidJSONResponse))
            }
        }
    }
}
