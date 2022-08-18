//
//  ViewControllerState.swift
//  TIDAL-Assignment
//
//  Created by Alberto Sendra Estrella on 19/8/22.
//

import Foundation

enum ViewControllerState {
    case content
    case loading
    case error(message: String)
    case empty
}
