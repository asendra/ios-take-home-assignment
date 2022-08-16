//
//  ArtistCoordinator.swift
//  TIDAL-Assignment
//
//  Created by Alberto Sendra Estrella on 16/8/22.
//

import Foundation
import UIKit

class ArtistCoordinator: BaseCoordinator {
    
    weak var parentCoordinator: SearchArtistCoordinator?
    var childCoordinators = [BaseCoordinator]()
    var navigationController: UINavigationController
    
    init(rootController: UINavigationController) {
        self.navigationController = rootController
    }

    func start() {
        let controller = ArtistController()
        controller.coordinator = self
        navigationController.pushViewController(controller, animated: true)
    }
}
