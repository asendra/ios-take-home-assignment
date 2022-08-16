//
//  AlbumController.swift
//  TIDAL-Assignment
//
//  Created by Alberto Sendra Estrella on 16/8/22.
//

import Foundation
import UIKit

class AlbumController: UITableViewController {
    
    weak var coordinator: AlbumCoordinator?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Album"
    }
}

extension AlbumController: Coordinated {
    var coordinating: BaseCoordinator? {
        return coordinator
    }
}
