//
//  MockApiClient.swift
//  TIDAL-AssignmentTests
//
//  Created by Alberto Sendra Estrella on 19/8/22.
//

import Foundation
@testable import TIDAL_Assignment

final class MockApiClient: Client {
    
    var session: URLSessionProtocol
    var baseURL = "https://api.deezer.com/"
    
    init(session: URLSession = URLSession.shared) {
        self.session = session
    }
    
    func load<A>(resource: Resource<A>, completion: @escaping  (A?) -> ()) {
        switch resource.path {
        case "album/1/tracks":
            let data = getData(name: "tracks-sample")
            if let tracks = resource.parse(data) {
                completion(tracks)
            }
        default:
            fatalError("Test case not handled")
        }
    }
    
    func getData(name: String, withExtension: String = "json") -> Data {
        let bundle = Bundle(for: Self.self)
        let fileUrl = bundle.url(forResource: name, withExtension: withExtension)
        let data = try! Data(contentsOf: fileUrl!)
        return data
    }
}
