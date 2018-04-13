//
//  HomeImageObject.swift
//  GettyImageViewer
//
//  Created by Chris Song on 13/04/2018.
//  Copyright © 2018 ChrisMJSong. All rights reserved.
//

import UIKit

class HomeImageObject: NSObject {

    var urlString: String?
    var cache: NSCache = NSCache<NSString, UIImage>()
    
    func loadThumbnailImage() -> UIImage {
        // 1. check cache
        // 2. check local
        // 3. web download
        
        return #imageLiteral(resourceName: "ImageSample.jpg")
    }
    
    func loadImage() -> UIImage {
        // 1. check cache
        // 2. check local
        // 3. web download
        
        return #imageLiteral(resourceName: "ImageSample.jpg")
    }
}
