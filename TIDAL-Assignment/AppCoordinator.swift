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
        navigationController = UINavigationController()
    }

    func start() {
        guard let window = window else {
            return
        }
        
        let child = SearchArtistCoordinator(rootController: navigationController)
        childCoordinators.append(child)
        child.parentCoordinator = self
        child.start()
        
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
}
