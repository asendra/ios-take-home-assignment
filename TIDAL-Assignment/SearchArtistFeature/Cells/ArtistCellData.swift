//
//  ArtistCellData.swift
//  TIDAL-Assignment
//
//  Created by Alberto Sendra Estrella on 17/8/22.
//

import Foundation
import UIKit

protocol ArtistCellDataType {
    var reuseIdentifier: String { get }
    
    var id: Int { get }
    var name: String { get }
    var picture: URL { get }
    
    func setup(_ cell: UITableViewCell, in tableView: UITableView, at indexPath: IndexPath)
}

struct ArtistCellData: ArtistCellDataType {
    
    var reuseIdentifier: String  {
        return ArtistCell.reuseIdentifier
    }
    
    var id: Int {
        return artist.id
    }
    
    var name: String {
        return artist.name
    }
    
    var picture: URL {
        return artist.picture
    }

    private let artist: Artist
    
    init(artist: Artist) {
        self.artist = artist
    }
    
    func setup(_ cell: UITableViewCell, in tableView: UITableView, at indexPath: IndexPath) {
        
        guard let cell = cell as? ArtistCell else {
            return
        }
        
        cell.nameLabel.text = self.name.capitalized
        cell.iconView.image = UIImage(systemName: "photo")
        /*
        Nuke.loadImage(with: imageURL,
                       options: ImageLoadingOptions(placeholder: UIImage(named: "PlaceholderImage")),
                       into: cell.iconView)
        */
    }
}
