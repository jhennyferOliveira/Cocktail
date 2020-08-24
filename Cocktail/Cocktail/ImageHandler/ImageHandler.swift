//
//  ImageHandler.swift
//  Cocktail
//
//  Created by Jhennyfer Rodrigues de Oliveira on 21/08/20.
//  Copyright © 2020 Jhennyfer Rodrigues de Oliveira. All rights reserved.
//

import Foundation
import UIKit

class ImageLoader {
    var task: URLSessionDownloadTask!
    var session: URLSession!
    var cache: NSCache<NSString, UIImage>!
    init() {
        session = URLSession.shared
        task = URLSessionDownloadTask()
        self.cache = NSCache()
    }    
    func obtainImageWithPath(imagePath: String, completionHandler: @escaping (UIImage) -> Void) {
        // if image is in cache return the image
        if let image = self.cache.object(forKey: imagePath as NSString) {
            DispatchQueue.main.async {
                completionHandler(image)
            }
            //if image is not in cache put a placeholder while download the image
        } else {
            let placeholder = #imageLiteral(resourceName: "white")
            DispatchQueue.main.async {
                completionHandler(placeholder)
            }
            // download the image
            let url: URL! = URL(string: imagePath)
            task = session.downloadTask(with: url, completionHandler: { (_, _, _) in
                if let data = try? Data(contentsOf: url) {
                    let img: UIImage! = UIImage(data: data)
                    // put in cache and return the image
                    self.cache.setObject(img, forKey: imagePath as NSString)
                    DispatchQueue.main.async {
                        completionHandler(img)
                    }
                }
            })
            task.resume()
        }
    }
}
