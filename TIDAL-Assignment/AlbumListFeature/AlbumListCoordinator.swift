//
//  AlbumListCoordinator.swift
//  TIDAL-Assignment
//
//  Created by Alberto Sendra Estrella on 16/8/22.
//

import Foundation
import UIKit

class AlbumListCoordinator: BaseCoordinator {
    
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
        let controller = AlbumListController(artist: artist, service: AlbumListApiService(client: apiClient))
        controller.coordinator = self
        navigationController.pushViewController(controller, animated: true)
    }
    
    func showAlbum(_ album: Album) {
        let child = AlbumInfoCoordinator(rootController: navigationController, client: apiClient, album: album)
        childCoordinators.append(child)
        child.parentCoordinator = self
        child.start()
    }
}
