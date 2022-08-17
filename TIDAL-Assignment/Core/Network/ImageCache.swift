//
//  ImageCache.swift
//  TIDAL-Assignment
//
//  Created by Alberto Sendra Estrella on 17/8/22.
//

import Foundation
import UIKit

protocol ImageCacheType {
    func image(for url: URL) -> UIImage?
    func insertImage(_ image: UIImage?, for url: URL)
    func removeImage(for url: URL)
    subscript(_ url: URL) -> UIImage? { get set }
}

final class ImageCache {
    
    var countLimit = 100
    var memoryLimit = 1024 * 1024 * 100
    
    private lazy var imageCache: NSCache<AnyObject, UIImage> = {
        let cache = NSCache<AnyObject, UIImage>()
        cache.countLimit = countLimit
        cache.totalCostLimit = memoryLimit
        return cache
    }()
    
    private let lock = NSLock()
    
    convenience init(countLimit: Int, memoryLimit: Int) {
        self.init()
        self.countLimit = countLimit
        self.memoryLimit = memoryLimit
    }
}

extension ImageCache: ImageCacheType {
    func insertImage(_ image: UIImage?, for url: URL) {
        guard let image = image else { return removeImage(for: url) }

        lock.lock(); defer { lock.unlock() }
        imageCache.setObject(image, forKey: url as AnyObject)
    }

    func removeImage(for url: URL) {
        lock.lock(); defer { lock.unlock() }
        imageCache.removeObject(forKey: url as AnyObject)
    }
    
    func image(for url: URL) -> UIImage? {
        lock.lock(); defer { lock.unlock() }
        
        return imageCache.object(forKey: url as AnyObject)
    }
    
    subscript(_ key: URL) -> UIImage? {
        get {
            return image(for: key)
        }
        set {
            return insertImage(newValue, for: key)
        }
    }
}
