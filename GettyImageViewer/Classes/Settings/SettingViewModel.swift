//
//  SettingViewModel.swift
//  GettyImageViewer
//
//  Created by Chris Song on 15/04/2018.
//  Copyright © 2018 ChrisMJSong. All rights reserved.
//

import UIKit
import KRProgressHUD

class SettingViewModel: NSObject {

    private var items = Array<SettingItem>()
    private var usedLibraries = Array<SettingItem>()
    var delegate: SettingViewController?
    
    /// Initial Setup
    func setup(){
        let item = SettingItem()
        item.subject = NSLocalizedString("Delete all downlad image files", comment: "")
        item.action = { self.deleteAction() }
        addItem(item)
        
        // library - I have no time. so create other array. it will be refactoring
        let names = ["CocoaPods", "RxSwift", "RxAlamofire", "fastlane", "HTMLReader", "HTMLString", "KRProgressHUD", "ReachabilitySwift"]
        let licenses = ["MIT", "MIT", "MIT", "MIT", "Unknown", "MIT", "MIT", "MIT"]
        let urls = ["https://cocoapods.org/", "https://github.com/ReactiveX/RxSwift", "https://github.com/RxSwiftCommunity/RxAlamofire", "https://fastlane.tools/", "https://github.com/nolanw/HTMLReader", "https://github.com/alexaubry/HTMLString", "https://github.com/krimpedance/KRProgressHUD", "https://github.com/ashleymills/Reachability.swift"]
        for i in 0..<names.count {
            let item = SettingItem()
            item.subject = names[i]
            item.detail  = licenses[i]
            let urlString = urls[i]
            item.action = {
                let url = URL.init(string: urlString)!
                if UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.openURL(url)}
            }
            
            usedLibraries.append(item)
        }
        
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
    
    func item(at indexPath: IndexPath) -> SettingItem {
        var array = items
        if indexPath.section == 1 {
            array = usedLibraries
        }
        return array[indexPath.row]
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
                return
            }
            
            KRProgressHUD.showSuccess()
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
    func numberOfRowsInSection(_ section: Int) -> Int {
        var array = items
        if section == 1 {
            array = usedLibraries
        }
        return array.count
    }
    
    /// return number of section to tableview
    ///
    /// - Returns: section count
    func numberOfSection() -> Int {
        return 2
    }
    
    /// return title of the header of the specific section
    ///
    /// - Parameter section: section index
    /// - Returns: section title
    func titleForHeaderInSection(_ section: Int) -> String {
        var title = ""
        switch section {
        case 0:
            title = NSLocalizedString("Storage management", comment: "section title - storage")
        case 1:
            title = NSLocalizedString("Libraries", comment: "section title - libraries")
        default:
            break
        }
        return title
    }
}
