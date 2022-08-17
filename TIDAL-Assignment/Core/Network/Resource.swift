//
//  Resource.swift
//  TIDAL-Assignment
//
//  Created by Alberto Sendra Estrella on 17/8/22.
//

import Foundation
import UIKit

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

extension Resource where A: UIImage {
    init(get path: String) {
        self.path = path
        self.parse = { data in
            UIImage(data: data) as? A
        }
    }
}
