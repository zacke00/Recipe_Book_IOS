//
//  ImageLoader.swift
//  Exam-PG5062
//
//  Created by zakaria berglund on 15/11/2023.
//

import Foundation
import UIKit

class ImageLoader: ObservableObject {
    var imageCache = NSCache<NSString, UIImage>()

    func loadImage(from urlString: String, completion: @escaping (UIImage?) -> Void) {
        if let cachedImage = imageCache.object(forKey: urlString as NSString) {
            completion(cachedImage)
            return
        }

        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                if let data = data, let image = UIImage(data: data) {
                    self.imageCache.setObject(image, forKey: urlString as NSString)
                    completion(image)
                } else {
                    completion(nil)
                }
            }
        }.resume()
    }
}
