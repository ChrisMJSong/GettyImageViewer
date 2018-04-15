//
//  SettingViewModel.swift
//  GettyImageViewer
//
//  Created by Chris Song on 15/04/2018.
//  Copyright © 2018 ChrisMJSong. All rights reserved.
//

import UIKit

class SettingViewModel: NSObject {

    private var items = Array<SettingItem>()
    
    /// Add item for table row
    ///
    /// - Parameter item: SettingItem instance
    func addItem(_ item: SettingItem) {
        items.append(item)
    }
    
    /// get item from items
    ///
    /// - Parameter index: item index
    /// - Returns: SettingItem instance
    func item(at index: Int) -> SettingItem {
        return items[index]
    }
    
    /// return number of rows to tableview
    ///
    /// - Returns: item count
    func numberOfRowsInSection() -> Int {
        return items.count
    }
    
    /// return number of section to tableview
    ///
    /// - Returns: section count
    func numberOfSection() -> Int {
        return 1
    }
    
    /// return title of the header of the specific section
    ///
    /// - Parameter section: section index
    /// - Returns: section title
    func titleForHeaderInSection(_ section: Int) -> String {
        return NSLocalizedString("Storage management", comment: "section title - storage")
    }
}
