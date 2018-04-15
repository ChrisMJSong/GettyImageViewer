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
    
    /// returna file size
    ///
    /// - Parameters:
    ///   - path: filePath
    /// - Returns: file size
    class func fileSize(at path: String) -> Int {
        // lets get the folder files
        var fileSize = 0
        (FileManager.default.enumerator(at: URL.init(fileURLWithPath: path), includingPropertiesForKeys: nil)?.allObjects as? [URL])?.lazy.forEach {
            fileSize += (try? $0.resourceValues(forKeys: [.totalFileAllocatedSizeKey]))?.totalFileAllocatedSize ?? 0
        }
        
        return fileSize
    }
    
    /// return a string byte size with format
    ///
    /// - Parameters:
    ///   - path: filePath
    ///   - byteUnit: byte unit
    /// - Returns: file size
    class func fileSizeString(at path: String, byteUnit: ByteCountFormatter.Units) -> String {
        let fileSize = self.fileSize(at: path)
        let  byteCountFormatter =  ByteCountFormatter()
        byteCountFormatter.allowedUnits = byteUnit
        byteCountFormatter.countStyle = .file
        let filesizeStrong = byteCountFormatter.string(for: fileSize) ?? ""
        
        return filesizeStrong
    }
}
