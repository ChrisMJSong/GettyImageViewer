//
//  HomeViewModel.swift
//  GettyImageViewer
//
//  Created by Chris Song on 13/04/2018.
//  Copyright © 2018 ChrisMJSong. All rights reserved.
//

import UIKit

class HomeViewModel: NSObject {

    var items = Array<HomeImageCellItem>()
    
    override init() {
        // set initialize
    }
    
    func numberOfSections() -> Int {
        return 1
    }
    
    func numberOfItemsInSection() -> Int {
        return items.count
    }
}
