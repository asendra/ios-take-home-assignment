//
//  SearchArtistController.swift
//  TIDAL-Assignment
//
//  Created by Alberto Sendra Estrella on 16/8/22.
//

import UIKit

class SearchArtistController: UITableViewController {

    weak var coordinator: SearchArtistCoordinator?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Search"
    }

}

