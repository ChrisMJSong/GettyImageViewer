//
//  SettingItem.swift
//  GettyImageViewer
//
//  Created by Chris Song on 15/04/2018.
//  Copyright © 2018 ChrisMJSong. All rights reserved.
//

import UIKit

typealias ItemAction = () -> Void

class SettingItem: NSObject {
    var subject: String?
    var detail: String?
    var action: ItemAction?
    
    /// check stored image size
    ///
    /// - Returns: image file size
    func storedImagesStorage() -> String {
        let imagePath = GTFileManager.cacheImagePath()
        let path = (imagePath?.path)!
        let fileSize = GTFileManager.fileSize(at: path)
        var unit = ByteCountFormatter.Units.useBytes
        if fileSize > 10^3 {
            unit = .useKB
        }else if fileSize > 10^6 {
            unit = .useMB
        }else if fileSize > 10^9 {
            unit = .useGB
        }
        return GTFileManager.fileSizeString(at: (imagePath?.path)!, byteUnit: unit)
    }
}
