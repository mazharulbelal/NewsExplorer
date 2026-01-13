//
//  ImageLoader.swift
//  NewsExplorer
//
//  Created by Md Mazharul Islam on 12/1/26.
//

import Foundation
import UIKit

public final class ImageLoader {

    public static let shared = ImageLoader()
    private let cache = NSCache<NSURL, UIImage>()

    public func loadImage(from url: URL, completion: @escaping (UIImage?) -> Void) {

        if let image = cache.object(forKey: url as NSURL) {
            DispatchQueue.main.async {
                completion(image)
            }
            return
        }

        URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let data, let image = UIImage(data: data) else {
                DispatchQueue.main.async {
                    completion(nil)
                }
                return
            }
            self.cache.setObject(image, forKey: url as NSURL)
            DispatchQueue.main.async {
                completion(image)
            }
        }.resume()
    }
}
