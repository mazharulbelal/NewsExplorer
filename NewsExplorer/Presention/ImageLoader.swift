//
//  ImageLoader.swift
//  NewsExplorer
//
//  Created by Md Mazharul Islam on 12/1/26.
//

import Foundation
import UIKit

final class ImageLoader {

    static let shared = ImageLoader()
    private let cache = NSCache<NSURL, UIImage>()

    func loadImage(from url: URL, completion: @escaping (UIImage?) -> Void) {

        if let image = cache.object(forKey: url as NSURL) {
            completion(image)
            return
        }

        URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let data, let image = UIImage(data: data) else {
                completion(nil)
                return
            }
            self.cache.setObject(image, forKey: url as NSURL)
            DispatchQueue.main.async {
                completion(image)
            }
        }.resume()
    }
}
