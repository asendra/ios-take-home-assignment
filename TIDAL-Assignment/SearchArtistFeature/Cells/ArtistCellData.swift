//
//  ArtistCellData.swift
//  TIDAL-Assignment
//
//  Created by Alberto Sendra Estrella on 17/8/22.
//

import Foundation
import UIKit

protocol ArtistCellDataType {
    var id: Int { get }
    var name: String { get }
    var picture: URL { get }
    
    var reuseIdentifier: String { get }
    func setup(_ cell: ArtistCell, in tableView: UITableView, at indexPath: IndexPath)
}

struct ArtistCellData: ArtistCellDataType {
    
    var reuseIdentifier: String  {
        return ArtistCell.reuseIdentifier
    }
    
    var id: Int {
        return artist.id
    }
    
    var name: String {
        return artist.name.capitalized
    }
    
    var picture: URL {
        return artist.picture
    }

    private let artist: Artist
    
    init(artist: Artist) {
        self.artist = artist
    }
    
    func setup(_ cell: ArtistCell, in tableView: UITableView, at indexPath: IndexPath) {
        cell.nameLabel.text = self.name
        cell.iconView.loadImage(from: self.picture, placeHolder: UIImage(systemName: "photo"))
    }
}
