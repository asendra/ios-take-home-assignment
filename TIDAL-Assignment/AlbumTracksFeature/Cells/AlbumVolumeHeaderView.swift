//
//  AlbumVolumeHeaderView.swift
//  TIDAL-Assignment
//
//  Created by Alberto Sendra Estrella on 18/8/22.
//

import UIKit

class AlbumVolumeHeaderView: UITableViewHeaderFooterView {
    
    static let reuseIdentifier = "AlbumVolumeHeaderView"
    
    let titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        label.textColor = .lightText
        label.text = "Volume 1"
        return label
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        self.setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func setup() {
        addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor),
        ])
    }
}
