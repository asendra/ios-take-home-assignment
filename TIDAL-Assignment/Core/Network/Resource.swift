//
//  Resource.swift
//  TIDAL-Assignment
//
//  Created by Alberto Sendra Estrella on 17/8/22.
//

import Foundation

struct Resource<A> {
    let path: String
    let parse: (Data) -> A?
}

extension Resource where A: Decodable {
    init(get path: String) {
        self.path = path
        self.parse = { data in
            try? JSONDecoder().decode(A.self, from: data)
        }
    }
}
