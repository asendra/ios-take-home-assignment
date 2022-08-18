//
//  AlbumCell.swift
//  TIDAL-Assignment
//
//  Created by Alberto Sendra Estrella on 18/8/22.
//

import UIKit

class AlbumCell: UICollectionViewCell {
    
    static let reuseIdentifier = "AlbumCell"
    
    let coverView: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = .lightGray
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFill
        view.layer.cornerCurve = .continuous
        view.layer.cornerRadius = 8.0
        view.clipsToBounds = true
        view.tintColor = .tidalTeal
        return view
    }()

    let titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        label.adjustsFontForContentSizeCategory = true
        label.textColor = .white
        return label
    }()
    
    let artistLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .subheadline)
        label.adjustsFontForContentSizeCategory = true
        label.textColor = .lightText
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    // MARK: - Private
    
    private func setup() {
        
        backgroundColor = .clear
        
        contentView.addSubview(coverView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(artistLabel)
    
        // Layout
        NSLayoutConstraint.activate([
            coverView.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor),
            coverView.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
            coverView.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor),
            coverView.heightAnchor.constraint(equalTo: coverView.widthAnchor, multiplier: 1.0),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor),
            titleLabel.topAnchor.constraint(equalTo: coverView.bottomAnchor, constant: 8),
            artistLabel.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
            artistLabel.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor),
            artistLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            artistLabel.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor),
            artistLabel.heightAnchor.constraint(equalTo: titleLabel.heightAnchor)
        ])

        titleLabel.setContentHuggingPriority(.defaultHigh, for: .vertical)
    }
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        let targetSize = CGSize(width: layoutAttributes.frame.width, height: 0)
        layoutAttributes.frame.size = contentView.systemLayoutSizeFitting(targetSize, withHorizontalFittingPriority: .required, verticalFittingPriority: .fittingSizeLevel)
        return layoutAttributes
    }
}
