//
//  SettingItem.swift
//  GettyImageViewer
//
//  Created by Chris Song on 15/04/2018.
//  Copyright © 2018 ChrisMJSong. All rights reserved.
//

import UIKit

class SettingItem: NSObject {
    var subject: String?
    
    /// check stored image size
    ///
    /// - Returns: image file size
    func storedImagesStorage() -> String {
        let imagePath = GTFileManager.cacheImagePath()
        return GTFileManager.fileSizeString(at: (imagePath?.path)!, byteUnit: .useMB)
    }
}
