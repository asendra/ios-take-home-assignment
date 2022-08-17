//
//  ApiError.swift
//  TIDAL-Assignment
//
//  Created by Alberto Sendra Estrella on 17/8/22.
//

import Foundation

enum APIError: LocalizedError, Equatable {
    
    case invalidJSONResponse
    case invalidImage
    
    public var errorDescription: String? {
        switch self {
        case .invalidJSONResponse:
            return "Invalid JSON response"
        case .invalidImage:
            return "Error loading image"
        }
    }
}
