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
        case coverXL = "cover_xl"
    }
    
    let id: Int
    let title: String
    let cover: URL
    let coverXL: URL
}

struct AlbumInfoResponse: Decodable {
    
    enum CodingKeys: String, CodingKey {
        case id, title, artist, contributors
        case cover = "cover_medium"
        case coverXL = "cover_xl"
    }
    
    let id: Int
    let title: String
    let cover: URL
    let coverXL: URL
    let artist: Artist
    let contributors: [Artist]
    //let tracks: TrackListResponse
}
