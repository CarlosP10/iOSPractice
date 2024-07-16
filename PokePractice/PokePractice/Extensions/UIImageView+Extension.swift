//
//  UIImageView+Extension.swift
//  PokePractice
//
//  Created by Carlos Paredes on 15/7/24.
//

import UIKit

extension UIImageView {
    
    private static var imageCache = NSCache<NSString, UIImage>()
    
    /// Method to cache img from url
    /// - Parameters:
    ///   - urlString: url image
    ///   - completion: completion function in case success or handle error
    func loadImage(from urlString: String, completion: @escaping (UIImage?) -> Void) {
        if let cachedImage = UIImageView.imageCache.object(forKey: urlString as NSString) {
            completion(cachedImage)
            return
        }
        
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, let image = UIImage(data: data) else {
                completion(nil)
                return
            }
            
            UIImageView.imageCache.setObject(image, forKey: urlString as NSString)
            DispatchQueue.main.async {
                self.image = image
                completion(image)
            }
        }.resume()
    }
}
