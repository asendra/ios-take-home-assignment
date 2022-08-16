//
//  BaseCoordinator.swift
//  TIDAL-Assignment
//
//  Created by Alberto Sendra Estrella on 16/8/22.
//

import Foundation
import UIKit

protocol BaseCoordinator {
    var childCoordinators: [BaseCoordinator] { get set }
    var navigationController: UINavigationController { get set }
    func start()
}
