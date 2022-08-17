//
//  ApiError.swift
//  TIDAL-Assignment
//
//  Created by Alberto Sendra Estrella on 17/8/22.
//

import Foundation

enum APIError: LocalizedError, Equatable {
    
    case invalidJSONResponse
    
    public var errorDescription: String? {
        switch self {
        case .invalidJSONResponse:
            return "Invalid JSON response"
        }
    }
}
