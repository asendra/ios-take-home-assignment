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
        self.title = "Artist"
    }

}
