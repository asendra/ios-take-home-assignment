//
//  SearchArtistCoordinator.swift
//  TIDAL-Assignment
//
//  Created by Alberto Sendra Estrella on 16/8/22.
//

import Foundation
import UIKit

class SearchArtistCoordinator: NSObject, BaseCoordinator, UINavigationControllerDelegate {
    
    weak var parentCoordinator: AppCoordinator?
    var childCoordinators = [BaseCoordinator]()
    var navigationController: UINavigationController
    
    init(rootController: UINavigationController) {
        self.navigationController = rootController
    }

    func start() {
        let controller = SearchArtistController()
        controller.coordinator = self
        navigationController.pushViewController(controller, animated: true)
        navigationController.delegate = self
    }
    
    func showArtist() {
        let child = ArtistCoordinator(rootController: navigationController)
        childCoordinators.append(child)
        child.start()
    }
    
    func childDidFinish(_ child: BaseCoordinator?) {
        for (index, coordinator) in childCoordinators.enumerated() {
            if coordinator === child {
                childCoordinators.remove(at: index)
                break
            }
        }
    }
    
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        // Read the view controller we’re moving from.
        guard let fromViewController = navigationController.transitionCoordinator?.viewController(forKey: .from) else {
            return
        }

        // Check whether our view controller array already contains that view controller.
        // If it does it means we’re pushing a different view controller on top rather than popping it, so exit.
        if navigationController.viewControllers.contains(fromViewController) {
            return
        }

        // We’re still here – it means we’re popping the view controller,
        // so we can check whether it’s an artist view controller
        if let buyViewController = fromViewController as? ArtistController {
            childDidFinish(buyViewController.coordinator)
        }
    }
}
