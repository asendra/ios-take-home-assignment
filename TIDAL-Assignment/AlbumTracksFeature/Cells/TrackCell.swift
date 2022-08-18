//
//  TrackCell.swift
//  TIDAL-Assignment
//
//  Created by Alberto Sendra Estrella on 18/8/22.
//

import UIKit

class TrackCell: UITableViewCell {

    static let reuseIdentifier = "TrackCell"
    
    let positionLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .title3)
        label.adjustsFontForContentSizeCategory = true
        label.textColor = .white
        label.textAlignment = .right
        return label
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        label.adjustsFontForContentSizeCategory = true
        label.textColor = .white
        label.numberOfLines = 0
        label.textAlignment = .left
        return label
    }()
    
    let artistLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .subheadline)
        label.adjustsFontForContentSizeCategory = true
        label.textColor = .lightText
        label.textAlignment = .left
        return label
    }()
    
    let durationLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .callout)
        label.adjustsFontForContentSizeCategory = true
        label.textColor = .lightText
        label.textAlignment = .right
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
        
        contentView.addSubview(positionLabel)
        contentView.addSubview(titleLabel)
        contentView.addSubview(artistLabel)
        contentView.addSubview(durationLabel)
    
        // Layout
        NSLayoutConstraint.activate([
            positionLabel.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor),
            positionLabel.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
            positionLabel.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor),
            positionLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 24.0),
            
            durationLabel.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor),
            durationLabel.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor),
            durationLabel.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor),
            
            titleLabel.leadingAnchor.constraint(equalTo: positionLabel.trailingAnchor, constant: 24.0),
            titleLabel.trailingAnchor.constraint(equalTo: durationLabel.leadingAnchor, constant: -12.0),
            titleLabel.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor),
            
            artistLabel.leadingAnchor.constraint(equalTo: positionLabel.trailingAnchor, constant: 24.0),
            artistLabel.trailingAnchor.constraint(equalTo: durationLabel.leadingAnchor, constant: -12.0),
            artistLabel.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor),
            artistLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
        ])

        positionLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        durationLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
    }

}
