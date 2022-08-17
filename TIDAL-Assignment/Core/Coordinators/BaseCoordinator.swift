//
//  BaseCoordinator.swift
//  TIDAL-Assignment
//
//  Created by Alberto Sendra Estrella on 16/8/22.
//

import Foundation
import UIKit

protocol BaseCoordinator: AnyObject {
    var parentCoordinator: BaseCoordinator? { get set }
    var childCoordinators: [BaseCoordinator] { get set }
    var navigationController: UINavigationController { get set }
    
    func start()
}

extension BaseCoordinator {
    /// Removing a coordinator inside a children. This call is important to prevent memory leak.
    /// - Parameter coordinator: Coordinator that finished.
    func childDidFinish(_ coordinator : BaseCoordinator?){
        // Call this if a coordinator is done.
        for (index, child) in childCoordinators.enumerated() {
            if child === coordinator {
                childCoordinators.remove(at: index)
                break
            }
        }
    }
}
