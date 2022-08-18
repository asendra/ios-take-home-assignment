//
//  AlbumInfoCoordinator.swift
//  TIDAL-Assignment
//
//  Created by Alberto Sendra Estrella on 16/8/22.
//

import Foundation
import UIKit

class AlbumTracksCoordinator: BaseCoordinator {
    
    var parentCoordinator: BaseCoordinator?
    var childCoordinators = [BaseCoordinator]()
    var navigationController: UINavigationController
    
    let apiClient: ApiClient
    
    let album: Album
    
    init(rootController: UINavigationController, client: ApiClient = ApiClient(), album: Album) {
        self.navigationController = rootController
        apiClient = client
        self.album = album
    }

    func start() {
        let controller = AlbumTracksController(album: album, service: AlbumTracksApiService(client: apiClient))
        controller.coordinator = self
        navigationController.pushViewController(controller, animated: true)
    }
}
