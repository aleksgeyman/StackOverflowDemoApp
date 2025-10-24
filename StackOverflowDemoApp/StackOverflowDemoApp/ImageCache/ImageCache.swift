//
//  ImageCache.swift
//  StackOverflowDemoApp
//
//  Created by Aleksandar Geyman on 24.10.25.
//

import UIKit

final class ImageCache {
    static let shared = ImageCache()
    private let cache = NSCache<NSString, UIImage>()
    
    private init() {}
    
    func getImage(forKey key: String) -> UIImage? {
        return cache.object(forKey: key as NSString)
    }
    
    func setImage(_ image: UIImage, forKey key: String) {
        cache.setObject(image, forKey: key as NSString)
    }
}

extension UIImageView {
    
    func loadImage(from url: URL, placeholder: UIImage? = nil) {
        self.image = placeholder
        let key = url.absoluteString
        if let cachedImage = ImageCache.shared.getImage(forKey: key) {
            self.image = cachedImage
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let self, let data, let image = UIImage(data: data) else {
                return
            }
            
            ImageCache.shared.setImage(image, forKey: key)
            DispatchQueue.main.async {
                self.image = image
            }
        }
        
        task.resume()
    }
}
