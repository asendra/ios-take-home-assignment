//
//  URLSessionProtocol.swift
//  TIDAL-Assignment
//
//  Created by Alberto Sendra Estrella on 19/8/22.
//

import Foundation

typealias DataTaskResult = (Data?, URLResponse?, Error?) -> Void

protocol URLSessionProtocol {
    func dataTask(with request: URLRequest, completionHandler: @escaping DataTaskResult) -> URLSessionDataTask
}

extension URLSession: URLSessionProtocol {}
