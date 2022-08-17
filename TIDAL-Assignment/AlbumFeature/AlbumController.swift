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
        
        setUpUI()
    }
    
    // MARK: - Private
    
    private func setUpUI() {
        title = "Album"
        view.backgroundColor = .tidalDarkBackground
    }
}

extension AlbumController: Coordinated {
    var coordinating: BaseCoordinator? {
        return coordinator
    }
}
