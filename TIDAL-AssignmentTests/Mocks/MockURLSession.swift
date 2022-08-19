//
//  MockURLSession.swift
//  TIDAL-AssignmentTests
//
//  Created by Alberto Sendra Estrella on 19/8/22.
//

import Foundation
@testable import TIDAL_Assignment

class MockURLSession: URLSessionProtocol {
    
    private(set) var lastRequest: URLRequest?

    var nextData: Data?
    var nextError: Error?

    func dataTask(with request: URLRequest, completionHandler: @escaping DataTaskResult) -> URLSessionDataTask {
        lastRequest = request
        completionHandler(nextData, nil, nextError)
        return URLSession.shared.dataTask(with: request)
    }
}
