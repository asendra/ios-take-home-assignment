//
//  ImageClient.swift
//  TIDAL-Assignment
//
//  Created by Alberto Sendra Estrella on 17/8/22.
//

import Foundation

final class ImageClient {
    
    let session: URLSession
    
    init(session: URLSession = URLSession.shared) {
        self.session = session
    }
    
    func load<A>(resource: Resource<A>, completion: @escaping  (A?) -> ()) {
        let url = URL(string: resource.path)!
        let urlRequest = URLRequest(url: url)
        session.dataTask(with: urlRequest) { data, _, _ in
            completion(data.flatMap(resource.parse))
        }.resume()
    }
}
