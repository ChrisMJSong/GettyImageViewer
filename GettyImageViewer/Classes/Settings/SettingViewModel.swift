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
    var delegate: SettingViewController?
    
    /// Initial Setup
    func setup(){
        let item = SettingItem()
        item.subject = NSLocalizedString("Delete all downlad image files", comment: "")
        item.action = { self.deleteAction() }
        addItem(item)
    }
    
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
    
    /// action for delete
    func deleteAction() {
        let message = NSLocalizedString("Delete the temporary image files.", comment: "delete alert subject")
        let actionTitle = NSLocalizedString("Delete all", comment: "delete all button title")
        let alert = UIAlertController.init(title: nil, message: message, preferredStyle: .actionSheet)
        let actionSetting = UIAlertAction.init(title: actionTitle, style: .destructive, handler: { (action) in
            // to delete
            do{
                let imagePath = GTFileManager.cacheImagePath()!
                try FileManager.default.removeItem(at: imagePath)
            }catch{
                // delete fail
            }
            
            self.delegate?.tableView.reloadData()
        })
        alert.addAction(actionSetting)
        let actionOK = UIAlertAction.init(title: NSLocalizedString("Cancel", comment: "Cancel"), style: .cancel, handler: nil)
        alert.addAction(actionOK)
        delegate?.present(alert, animated: true, completion: nil)
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
