//
//  CachedImageService.swift
//  TIDAL-Assignment
//
//  Created by Alberto Sendra Estrella on 17/8/22.
//

import Foundation
import UIKit

final class CachedImageService {
    
    static let shared = CachedImageService()
    
    private let imageClient: ImageClient
    private let imageCache: ImageCache
    
    // MARK: - Init
    
    init(client: ImageClient = ImageClient(), cache: ImageCache = ImageCache()) {
        imageClient = client
        imageCache = cache
    }
    
    // MARK: - Public
    
    func loadImage(url: URL, completion: @escaping (Result<UIImage, Error>) -> Void) {
        
        if let image = imageCache[url] {
            completion(.success(image))
            return
        }
        
        let resource = Resource<UIImage>(get: url.absoluteString)
        imageClient.load(resource: resource) { image in
            if let image = image {
                self.imageCache[url] = image
                completion(.success(image))
            }
            else {
                completion(.failure(APIError.invalidImage))
            }
        }
    }
}
