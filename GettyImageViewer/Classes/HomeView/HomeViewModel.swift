//
//  HomeViewModel.swift
//  GettyImageViewer
//
//  Created by Chris Song on 13/04/2018.
//  Copyright © 2018 ChrisMJSong. All rights reserved.
//

import UIKit
import HTMLReader


class HomeViewModel: NSObject {
    
    private var items = Array<HomeImageCellItem>()
    
    /// get item from items
    ///
    /// - Parameter index: item index
    /// - Returns: HomeImageCellItem instance
    func item(at index: Int) -> HomeImageCellItem {
        return items[index]
    }
    
    func replaceItemsByHTMLElements(_ elements: Array<HTMLElement>) {
        // remove all items
        self.items.removeAll()
        
        for element in elements {
            let detailAddress = element.childElementNodes[0].attributes["href"]
            let thumbnameImageAddress = element.childElementNodes[0].childElementNodes[0].attributes["src"]
            let subject = element.childElementNodes[1].child(at: 1).textContent
            
            let item = HomeImageCellItem.init()
            item.subject = subject
            item.imageObject.thumbImageUrlString = thumbnameImageAddress
            item.contentUrlString = detailAddress
            
            addItem(item)
        }
    }
    
    /// insert item in middle
    ///
    /// - Parameters:
    ///   - item: item instance
    ///   - index: item index
    func insertItemAtIndex(_ item: HomeImageCellItem, at index: Int) {
        
        var index = index   // rewrite to adjust
        let lastIndex = items.count > 0 ? items.count - 1 : 0
        
        // adjust index if big than last index
        if index > lastIndex {
            index = lastIndex
        }
        
        switch index {
        case 0:
            // insert to first
            guard let firstItem = items.first else {
                break
            }
            firstItem.preItem = item
            item.nextItem = firstItem
            break
            
        case lastIndex :
            // insert to last
            guard let lastItem = items.last else {
                break
            }
            lastItem.nextItem = item
            item.preItem = lastItem
            break
            
        default:
            let selectedItem = items[index]
            let preSelectedItem = items[index - 1]
            selectedItem.preItem = item
            item.nextItem = selectedItem
            item.preItem = preSelectedItem
            break
        }
        
        items.insert(item, at: index)
    }
    
    /// insert item to end
    ///
    /// - Parameter item: item instance
    func addItem(_ item: HomeImageCellItem) {
        if items.count > 0 {
            let lastItem = items.last
            lastItem?.nextItem = item
            item.preItem = lastItem
        }
        items.append(item)
    }
    
    /// remove item of instance
    ///
    /// - Parameter item: item Object
    func removeItem(_ item: HomeImageCellItem) {
        guard let index = items.index(of: item) else {
            fatalError()
        }
        items.remove(at: index)
    }
    
    /// remove item at index
    ///
    /// - Parameter index: index
    func removeItem(at index: Int) {
        if index >= items.count {
            fatalError()
        }
        items.remove(at: index)
    }
    
    /// number of section in collection view
    ///
    /// - Returns: number of section
    func numberOfSections() -> Int {
        return 1
    }
    
    /// the number of items in specific section
    ///
    /// - Returns: number of item
    func numberOfItemsInSection() -> Int {
        return items.count
    }
    
    /// the string of number of items
    ///
    /// - Returns: a string that number of items
    func footerMessage() -> String {
        var result = NSLocalizedString("No items", comment: "footer message - no items")
        if items.count > 0 {
            result = String.init(format: NSLocalizedString("Total %d items.", comment: "footer message - item count"), items.count)
        }
        return result
    }
}
