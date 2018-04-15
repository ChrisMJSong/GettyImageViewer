//
//  GTFileManager.swift
//  GettyImageViewer
//
//  Created by Chris Song on 15/04/2018.
//  Copyright © 2018 ChrisMJSong. All rights reserved.
//

import UIKit

class GTFileManager: NSObject {
    /// return a url that cache directory path
    ///
    /// - Returns: cache directory path
    class func cacheDirectoryPath() -> URL? {
        let paths = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)
        let cacheDirPath = paths.last
        return cacheDirPath
    }
    
    /// reutrn a url that stored cache image directory path
    ///
    /// - Returns: stored cache image directory path
    class func cacheImagePath() -> URL? {
        return self.cacheDirectoryPath()?.appendingPathComponent("images")
    }
}
