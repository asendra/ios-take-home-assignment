//
//  Album.swift
//  TIDAL-Assignment
//
//  Created by Alberto Sendra Estrella on 17/8/22.
//

import Foundation

struct AlbumListResponse: Decodable {
    let total: Int
    let data: [Album]
}

struct Album: Decodable {
    
    enum CodingKeys: String, CodingKey {
        case id, title
        case cover = "cover_medium"
    }
    
    let id: Int
    let title: String
    let cover: URL
}

struct AlbumInfoResponse: Decodable {
    let id: Int
    let title: String
    let cover: URL
    let artist: Artist
    let contributors: [Artist]
    //let tracks: TrackListResponse
}
