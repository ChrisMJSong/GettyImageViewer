//
//  HomeImageObject.swift
//  GettyImageViewer
//
//  Created by Chris Song on 13/04/2018.
//  Copyright © 2018 ChrisMJSong. All rights reserved.
//

import UIKit

class HomeImageObject: NSObject {
    
    /// image content type
    ///
    /// - thumbnail: thumbnail image
    /// - origin: original image
    enum ImageContentType: Int {
        case thumbnail = 0, origin
        
        /// return enum string value
        ///
        /// - Returns: a string that enum value
        func string() -> String {
            switch self {
            case .thumbnail:    return "cachedImageThumb"
            case .origin:       return "cachedImageOrigin"
            }
        }
    }

    var thumbImageUrlString: String?
    var originImageUrlString: String?
    var cache: NSCache = NSCache<NSString, UIImage>()
    
    static let thumbnailDirectoryName = "thumbnails"
    static let originalDirectoryName  = "originals"
    
    /// Return a image
    ///
    /// - Parameters:
    ///   - type: content type
    ///   - imageView: set image to this imageview after download, if you need.
    /// - Returns: image instance
    func loadImage(_ type: ImageContentType, imageView: UIImageView?) -> UIImage? {
        
        // 1. want origin type
        // 1-1. check cache
        // 1-2. check local
        // 1-2-1. temporary return thumbnail (go 2)
        // 1-3. webdownload
        // 1-4. show image after download
        // 2. want thumbnail
        // 2-1. check cache
        // 2-2. check local
        // 2-3. webdownload
        // 2-4. show image after download
        
        var image = self.imageFromCache(type)
        guard image == nil else {
            // found from cache
            return image
        }
        image = self.imageFromLocal(type)
        guard image == nil else {
            // found from local
            return image
        }
        
        // before get image from web
        if type == .origin {
            // load thumb image
            imageView?.image = self.loadImage(.thumbnail, imageView: imageView)
        }
        // try get image from web
        var targetUrlString: String?
        switch type {
        case .thumbnail:
            targetUrlString = self.thumbImageUrlString
        case .origin:
            targetUrlString = self.originImageUrlString
        }
        
        guard let target = targetUrlString else {
            // cant find target url
            return nil
        }
        
        NetworkManager.shared.downloadImage(target) { (data, error) in
            guard let data = data else {
                return
            }
            let image = UIImage.init(data: data)
            let key = NSString.init(string: type.string())
            self.cache.setObject(image!, forKey: key)
            
                if let superView = imageView?.superview?.superview as? HomeImageCell {
                    if (superView.item?.imageObject == self) {
                        imageView?.image = image
                    }
                }else {
                    imageView?.image = image
                }
            
            
            // save image
            let result = self.setImageToLocal(type: type, imageData: data)
            if result == false {
                // need more space
            }
        }
        
        return image
    }
    
    /// get image from cache
    ///
    /// - Parameter type: image type
    /// - Returns: image instance
    func imageFromCache(_ type: ImageContentType) -> UIImage? {
        let key = NSString.init(string: type.string())
        return self.cache.object(forKey: key)
    }
    
    /// set image to cache
    ///
    /// - Parameters:
    ///   - image: image instance
    ///   - type: image type
    func setImageToCache(image: UIImage, imageType type: ImageContentType) {
        let key = NSString.init(string: type.string())
        self.cache.setObject(image, forKey: key)
    }
    
    /// return a url that cache directory path
    ///
    /// - Returns: cache directory path
    func cacheDirectoryPath() -> URL? {
        let paths = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)
        let cacheDirPath = paths.last
        return cacheDirPath
    }
    
    /// return a url that image sub path by content type
    ///
    /// - Parameter type: content type
    /// - Returns: sub url path
    func imagePath(_ type: ImageContentType) -> URL? {
        guard let cacheDirectory = cacheDirectoryPath() else {
            return nil
        }
        
        var targetDriName = ""
        switch type {
        case .thumbnail:
            targetDriName = HomeImageObject.thumbnailDirectoryName
        case .origin:
            targetDriName = HomeImageObject.originalDirectoryName
        }
        
        let imagePath = cacheDirectory.appendingPathComponent("images").appendingPathComponent(targetDriName)
        
        if !FileManager.default.fileExists(atPath: imagePath.absoluteString) {
            // if cant find create image directory
            do {
                try FileManager.default.createDirectory(at: imagePath, withIntermediateDirectories: true, attributes: nil)
            }
            catch {
                // create fail
                return nil
            }
        }
        
        return imagePath
    }
    
    /// return a file name by content type
    ///
    /// - Parameter type: content type
    /// - Returns: file name with extension
    func fileName(_ type: ImageContentType) -> String? {
        var urlSubPath: String?
        switch type {
        case .thumbnail:
            urlSubPath = self.thumbImageUrlString
        case .origin:
            urlSubPath = self.originImageUrlString
        }
        
        guard let urlPath = urlSubPath else {
            return nil
        }
        
        guard let subPath = URL.init(string: urlPath) else {
            return nil
        }
        let fileName = subPath.lastPathComponent
        
        return fileName
    }
    
    /// return stored image full path string
    ///
    /// - Parameter type: content type
    /// - Returns: image path string
    func imageFilePath(_ type: ImageContentType) -> String? {
        let imagePath = self.imagePath(type)
        let fileName  = self.fileName(type)
        
        guard let fileName2 = fileName else {
            return nil
        }
        
        let fullPath = imagePath?.appendingPathComponent(fileName2)
        
        return fullPath?.path
    }
    
    /// return a stored image from local
    ///
    /// - Parameter type: image content type
    /// - Returns: image instance
    func imageFromLocal(_ type: ImageContentType) -> UIImage? {
        guard let path = imageFilePath(type) else {
            return nil
        }
        
        guard let data = FileManager.default.contents(atPath: path) else {
            return nil
        }
        let image = UIImage.init(data: data)
        
        return image
    }
    
    /// save image data to local
    ///
    /// - Parameters:
    ///   - type: image content type
    ///   - imageData: image data
    /// - Returns: save success state
    func setImageToLocal(type: ImageContentType, imageData: Data) -> Bool {
        guard let path = imageFilePath(type) else {
            return false
        }
        
        do {
         try imageData.write(to: path.asURL())
        }catch{
            // write fail
            return false
        }
        
        return true
    }
}
