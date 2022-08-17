//
//  Artist.swift
//  TIDAL-Assignment
//
//  Created by Alberto Sendra Estrella on 17/8/22.
//

import Foundation

struct SearchArtistResponse: Decodable {
    let total: Int
    let data: [Artist]
}

struct Artist: Decodable {
    let id: Int
    let name: String
    let picture: URL
}
