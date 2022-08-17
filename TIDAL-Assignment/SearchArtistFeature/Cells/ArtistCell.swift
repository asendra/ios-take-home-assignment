//
//  ArtistCell.swift
//  TIDAL-Assignment
//
//  Created by Alberto Sendra Estrella on 17/8/22.
//

import UIKit

class ArtistCell: UITableViewCell {

    static let reuseIdentifier = "ArtistCell"
    static let iconSize = 44.0
    
    let iconView: UIImageView = {
        let view = UIImageView()
        //view.backgroundColor = .lightGray
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFill
        view.layer.cornerCurve = .continuous
        view.layer.cornerRadius = 8.0
        view.clipsToBounds = true
        view.tintColor = .tidalTeal
        return view
    }()

    let nameLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        label.adjustsFontForContentSizeCategory = true
        label.textColor = .white
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }

    // MARK: - Private
    
    private func setup() {
        
        backgroundColor = .clear
        
        contentView.addSubview(iconView)
        contentView.addSubview(nameLabel)
        
        // Needed to fix auto layout warnings
        let iconBottomConstraint = iconView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4.0)
        iconBottomConstraint.priority = .defaultHigh
        
        // Layout
        NSLayoutConstraint.activate([
            iconView.widthAnchor.constraint(equalToConstant: ArtistCell.iconSize),
            iconView.heightAnchor.constraint(equalToConstant: ArtistCell.iconSize),
            iconView.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
            iconView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4.0),
            iconBottomConstraint,
            nameLabel.leadingAnchor.constraint(equalTo: iconView.trailingAnchor, constant: 12),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor),
            nameLabel.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor),
            nameLabel.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor)
        ])
    }
}
