//
//  AsyncImage.swift
//  TIDAL-Assignment
//
//  Created by Alberto Sendra Estrella on 18/8/22.
//

import Foundation
import UIKit

extension UIImageView {
    func loadImage(from url: URL, placeHolder: UIImage?) {
        CachedImageService.shared.loadImage(url: url) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let image):
                    self?.image = image
                case .failure(_):
                    self?.image = placeHolder
                }
            }
        }
    }
}
