//
//  CoverHeaderView.swift
//  TIDAL-Assignment
//
//  Created by Alberto Sendra Estrella on 18/8/22.
//

import UIKit

class CoverHeaderView: UIView {
    
    let imageView: UIImageView = {
        let view = UIImageView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFit
        view.tintColor = .lightText
        view.layer.cornerCurve = .continuous
        view.layer.cornerRadius = 12.0
        view.backgroundColor = .clear
        view.clipsToBounds = true
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func setup() {
        addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor),
        ])
    }
}
