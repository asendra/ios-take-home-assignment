//
//  AppCoordinator.swift
//  TIDAL-Assignment
//
//  Created by Alberto Sendra Estrella on 16/8/22.
//

import Foundation
import UIKit

class AppCoordinator: BaseCoordinator {
    
    var window: UIWindow?
    var childCoordinators = [BaseCoordinator]()
    var navigationController: UINavigationController
    
    init(window: UIWindow?) {
        self.window = window
        navigationController = UINavigationController(rootViewController: SearchArtistController())
    }

    func start() {
        guard let window = window else {
            return
        }
    
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
}
