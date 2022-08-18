//
//  Track.swift
//  TIDAL-Assignment
//
//  Created by Alberto Sendra Estrella on 17/8/22.
//

import Foundation

struct TrackListResponse: Decodable {
    let data: [Track]
}

struct Track: Decodable {
    
    enum CodingKeys: String, CodingKey {
        case id, title, duration, artist
        case trackPosition = "track_position"
        case diskNumber = "disk_number"
    }
    
    let id: Int
    let title: String
    let duration: Int
    let trackPosition: Int
    let diskNumber: Int
    let artist: TrackArtist
}

struct TrackArtist: Decodable {
    let id: Int
    let name: String
}

