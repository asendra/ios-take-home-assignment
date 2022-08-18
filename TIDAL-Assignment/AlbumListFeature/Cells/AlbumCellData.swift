//
//  AlbumCellData.swift
//  TIDAL-Assignment
//
//  Created by Alberto Sendra Estrella on 18/8/22.
//

import Foundation
import UIKit

protocol AlbumCellDataType {
    var id: Int { get }
    var title: String { get }
    var artists: String { get }
    var cover: URL { get }
    
    var reuseIdentifier: String { get }
    func setup(_ cell: AlbumCell, in collectionView: UICollectionView, at indexPath: IndexPath)
}

struct AlbumCellData: AlbumCellDataType {
    
    var reuseIdentifier: String  {
        return AlbumCell.reuseIdentifier
    }
    
    var id: Int {
        return album.id
    }
    
    var title: String {
        return album.title.capitalized
    }
    
    var artists: String {
        return contributors.map({$0.name}).joined(separator: ", ")
    }
    
    var cover: URL {
        return album.cover
    }

    private let album: Album
    private let contributors: [Artist]
    
    init(album: Album, contributors: [Artist]) {
        self.album = album
        self.contributors = contributors
    }
    
    func setup(_ cell: AlbumCell, in collectionView: UICollectionView, at indexPath: IndexPath) {
        cell.titleLabel.text = self.title
        cell.artistLabel.text = self.artists
        cell.coverView.loadImage(from: self.cover, placeHolder: UIImage(systemName: "photo"))
    }
}
