//
//  SearchArtistController.swift
//  TIDAL-Assignment
//
//  Created by Alberto Sendra Estrella on 16/8/22.
//

import UIKit

class SearchArtistController: UITableViewController, Coordinated {
    
    var coordinating: BaseCoordinator? {
        return coordinator
    }
    
    weak var coordinator: SearchArtistCoordinator?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Search"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Artist", style: .plain, target: self, action: #selector(showArtist(_:)))
    }

    @objc private func showArtist(_ sender: UIBarButtonItem) {
        coordinator?.showArtist()
    }
}

