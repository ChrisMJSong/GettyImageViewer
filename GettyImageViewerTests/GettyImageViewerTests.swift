//
//  GettyImageViewerTests.swift
//  GettyImageViewerTests
//
//  Created by Chris Song on 12/04/2018.
//  Copyright © 2018 ChrisMJSong. All rights reserved.
//

import XCTest
@testable import GettyImageViewer

class GettyImageViewerTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        let viewModel = HomeViewModel()
        
        for i in 0..<10 {
            let item = HomeImageCellItem()
            item.subject = "Item \(i)"
            viewModel.addItem(item)
        }
        
        // insert item to specific index
        let specificIndex = [0, 3, 8]
        for index in specificIndex {
            let item = HomeImageCellItem()
            item.subject = "Inserted item \(index)^"
            viewModel.insertItemAtIndex(item, at: index)
        }
        
        // delete item at index
        viewModel.removeItem(at: 2)
        let deletingItem = viewModel.item(at: 4)
        print("deletingItem: ", deletingItem.subject!)
        viewModel.removeItem(deletingItem)
        
        // show rest itmes
        var nextItem: HomeImageCellItem? = viewModel.item(at: 0)
        while nextItem != nil {
            print("poped item: ", deletingItem.subject!)
            nextItem = nextItem?.nextItem
        }
        print("complete")
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
