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
    let artist: Artist
    
    init(rootController: UINavigationController, client: ApiClient = ApiClient(), artist: Artist, album: Album) {
        self.navigationController = rootController
        self.apiClient = client
        self.artist = artist
        self.album = album
    }

    func start() {
        let viewModel = AlbumTracksViewModel(service: AlbumTracksApiService(client: apiClient), artist: artist, album: album)
        let controller = AlbumTracksController(viewModel: viewModel)
        controller.coordinator = self
        navigationController.pushViewController(controller, animated: true)
    }
}
