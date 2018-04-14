//
//  HomeImageCellItem.swift
//  GettyImageViewer
//
//  Created by Chris Song on 13/04/2018.
//  Copyright © 2018 ChrisMJSong. All rights reserved.
//

import UIKit

class HomeImageCellItem: NSObject {

    var preItem: HomeImageCellItem?
    var nextItem: HomeImageCellItem?
    
    var subject: String?
    var textContent: String?
    var contentUrlString: String?
    var imageObject = HomeImageObject()
    
    deinit {
        // will link with two item when item was deallocated
        if let preItem = preItem, let nextItem = nextItem {
            preItem.nextItem = nextItem
            nextItem.preItem = preItem
        }
        preItem     = nil
        nextItem    = nil
    }
    
    func hasDetailContent() -> Bool {
        return imageObject.originImageUrlString != nil
    }
}
