//
//  SearchArtistCoordinator.swift
//  TIDAL-Assignment
//
//  Created by Alberto Sendra Estrella on 16/8/22.
//

import Foundation
import UIKit

class SearchArtistCoordinator: NSObject, BaseCoordinator, UINavigationControllerDelegate {
    
    var parentCoordinator: BaseCoordinator?
    var childCoordinators = [BaseCoordinator]()
    var navigationController: UINavigationController
    
    let apiClient: ApiClient
    
    init(rootController: UINavigationController, client: ApiClient = ApiClient()) {
        navigationController = rootController
        apiClient = client
    }

    func start() {
        let viewModel = SearchArtistViewModel(service: SearchArtistApiService(client: apiClient))
        let controller = SearchArtistController(viewModel: viewModel)
        controller.coordinator = self
        navigationController.pushViewController(controller, animated: true)
    }
    
    func showArtist(_ artist: Artist) {
        let child = AlbumListCoordinator(rootController: navigationController, client: apiClient, artist: artist)
        childCoordinators.append(child)
        child.parentCoordinator = self
        child.start()
    }
}
