//
//  AppCoordinator.swift
//  TIDAL-Assignment
//
//  Created by Alberto Sendra Estrella on 16/8/22.
//

import Foundation
import UIKit

class AppCoordinator: NSObject, BaseCoordinator, UINavigationControllerDelegate  {
    
    var parentCoordinator: BaseCoordinator?
    var childCoordinators = [BaseCoordinator]()
    var navigationController: UINavigationController
    
    var window: UIWindow?
    
    init(window: UIWindow?) {
        self.window = window
        navigationController = UINavigationController()
        super.init()
    }

    func start() {
        guard let window = window else { return }
        
        self.setupNavigationBar()
        
        // For popping child coordinators when using back button navigation
        navigationController.delegate = self
        
        let child = SearchArtistCoordinator(rootController: navigationController)
        childCoordinators.append(child)
        child.parentCoordinator = self
        child.start()
        
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
    
    // MARK: - private
    
    private func setupNavigationBar() {
        
        navigationController.navigationBar.prefersLargeTitles = true
        navigationController.navigationBar.tintColor = UIColor.tidalTeal
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .tidalDarkBackground
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        
        let buttonAppearance = UIBarButtonItemAppearance()
        buttonAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.tidalTeal]
        appearance.buttonAppearance = buttonAppearance
        
        navigationController.navigationBar.standardAppearance = appearance
        navigationController.navigationBar.scrollEdgeAppearance = appearance
        navigationController.navigationBar.compactAppearance = appearance
    }
    
    // MARK: - UINavigationControllerDelegate
    
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
        // so we can check whether it’s a coordinated controller
        if let coordinatedController = fromViewController as? Coordinated {
            coordinatedController.coordinating?.parentCoordinator?.childDidFinish(coordinatedController.coordinating)
        }
    }
}
