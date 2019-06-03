//
//  Extensions.swift
//  SmartCampus
//
//  Created by Tommy Chavez on 4/21/19.
//  Copyright © 2019 Tommy Chavez. All rights reserved.
//

import UIKit

let imageCache = NSCache<NSString, AnyObject>()

extension UIImageView {
    
    //caching
    func loadImageUsingCacheWithUrlString(urlString: String) {
        self.image = nil
        //check cache for image first
        if let cachedImage = imageCache.object(forKey: urlString as NSString) as? UIImage {
            self.image = cachedImage
            return
        }
        
        
        guard let url2 = URL(string: urlString) else {return
        }
        URLSession.shared.dataTask(with: url2 ) { (data, repsonse,error) in
            guard let data = data else {return}
            if error != nil {
                return
            }
            DispatchQueue.main.async {
                if let downloadedImage = UIImage(data: data) {
                    imageCache.setObject(downloadedImage, forKey: urlString as NSString)
                
                //  cell.imageView?.image = UIImage(data: data)
               self.image = downloadedImage
                }
                
            }
            
        }.resume()
    }
}



