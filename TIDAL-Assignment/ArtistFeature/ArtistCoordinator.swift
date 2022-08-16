//
//  ArtistCoordinator.swift
//  TIDAL-Assignment
//
//  Created by Alberto Sendra Estrella on 16/8/22.
//

import Foundation
import UIKit

class ArtistCoordinator: BaseCoordinator {
    
    var parentCoordinator: BaseCoordinator?
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
    
    func showAlbum() {
        let child = AlbumCoordinator(rootController: navigationController)
        childCoordinators.append(child)
        child.parentCoordinator = self
        child.start()
    }
}
