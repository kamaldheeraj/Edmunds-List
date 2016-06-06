//
//  Utils.swift
//  Edmunds List
//
//  Created by Kamal Dandamudi on 6/4/16.
//  Copyright © 2016 Kamal Dandamudi. All rights reserved.
//

import Foundation
import UIKit

class Utils{

    static let imageCache = NSCache()
    
    class func fetchImageWithURL(stringURL:String) -> UIImage?{
        let cache = imageCache
        var cachedImage:UIImage?
        if let image = cache.objectForKey(stringURL) as? UIImage{
            cachedImage = image
        }else{
            guard let url = NSURL(string:stringURL) else{
                return cachedImage
            }
            guard let data = NSData(contentsOfURL:url) else{
                return cachedImage
            }
            guard let image = UIImage(data:data) else {
                return cachedImage
            }
            cachedImage = image
            cache.setObject(image, forKey: stringURL)
        }
        return cachedImage
    }
    
}