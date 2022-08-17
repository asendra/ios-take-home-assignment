//
//  ArtistController.swift
//  TIDAL-Assignment
//
//  Created by Alberto Sendra Estrella on 16/8/22.
//

import Foundation
import UIKit

class ArtistController: UITableViewController {
    
    weak var coordinator: ArtistCoordinator?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpUI()
    }

    // MARK: - Private
    
    private func setUpUI() {
        title = "Artist"
        view.backgroundColor = .tidalDarkBackground
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Album", style: .plain, target: self, action: #selector(showAlbum(_:)))
    }
    
    // MARK: - Actions
    
    @objc private func showAlbum(_ sender: UIBarButtonItem) {
        coordinator?.showAlbum()
    }
}

extension ArtistController: Coordinated {
    var coordinating: BaseCoordinator? {
        return coordinator
    }
}
