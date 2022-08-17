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
    
    let apiClient: ApiClient
    
    let artist: Artist
    
    init(rootController: UINavigationController, client: ApiClient = ApiClient(), artist: Artist) {
        navigationController = rootController
        apiClient = client
        self.artist = artist
    }

    func start() {
        let controller = ArtistController(artist: artist)
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
