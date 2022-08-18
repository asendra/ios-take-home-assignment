//
//  TracksCellData.swift
//  TIDAL-Assignment
//
//  Created by Alberto Sendra Estrella on 18/8/22.
//

import Foundation
import UIKit

protocol TrackCellDataType {
    var position: String { get }
    var title: String { get }
    var artists: String { get }
    var duration: String { get }
    
    var reuseIdentifier: String { get }
    func setup(_ cell: TrackCell, in tableView: UITableView, at indexPath: IndexPath)
}

struct TrackCellData: TrackCellDataType {
    
    var reuseIdentifier: String  {
        return TrackCell.reuseIdentifier
    }
    
    var position: String {
        return "\(track.trackPosition)."
    }
    
    var title: String {
        return track.title.capitalized
    }
    
    var artists: String {
        return track.artist.name
    }

    var duration: String {
        let minutes = (track.duration / 60)
        let seconds = (track.duration % 60)
        return "\(String(format: "%02d", minutes)):\(String(format: "%02d", seconds))"
    }
    
    private let track: Track
    
    init(track: Track) {
        self.track = track
    }
    
    func setup(_ cell: TrackCell, in tableView: UITableView, at indexPath: IndexPath) {
        cell.positionLabel.text = self.position
        cell.titleLabel.text = self.title
        cell.artistLabel.text = self.artists
        cell.durationLabel.text = self.duration
    }
}
