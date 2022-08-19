//
//  ApiClient.swift
//  TIDAL-Assignment
//
//  Created by Alberto Sendra Estrella on 17/8/22.
//

import Foundation

protocol Client {
    var session: URLSessionProtocol { get }
    var baseURL: String { get }
    
    func load<A>(resource: Resource<A>, completion: @escaping  (A?) -> ())
}

final class ApiClient: Client {
    
    var session: URLSessionProtocol
    var baseURL = "https://api.deezer.com/"
    
    init(session: URLSessionProtocol = URLSession.shared) {
        self.session = session
    }
    
    func load<A>(resource: Resource<A>, completion: @escaping  (A?) -> ()) {
        let url = URL(string: baseURL + resource.path)!
        let urlRequest = URLRequest(url: url)
        session.dataTask(with: urlRequest) { data, _, _ in
            completion(data.flatMap(resource.parse))
        }.resume()
    }
}
