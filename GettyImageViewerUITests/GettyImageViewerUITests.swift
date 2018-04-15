//
//  GettyImageViewerUITests.swift
//  GettyImageViewerUITests
//
//  Created by Chris Song on 12/04/2018.
//  Copyright © 2018 ChrisMJSong. All rights reserved.
//

import XCTest

class GettyImageViewerUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        let app = XCUIApplication()
        let collectionViewsQuery = app.collectionViews
        collectionViewsQuery.children(matching: .cell).element(boundBy: 18).children(matching: .other).element/*@START_MENU_TOKEN@*/.swipeRight()/*[[".swipeUp()",".swipeRight()"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        collectionViewsQuery.children(matching: .cell).element(boundBy: 14).children(matching: .other).element.tap()
        collectionViewsQuery.children(matching: .cell).element(boundBy: 6).children(matching: .other).element.tap()
        collectionViewsQuery.children(matching: .cell).element(boundBy: 0).children(matching: .other).element.tap()
        
        let toolbarsQuery = app.toolbars
        toolbarsQuery.buttons["정보"].tap()
        app.alerts["A Roman Prince"].buttons["확인"].tap()
        toolbarsQuery.buttons["저장"].tap()
        
        let scrollView = app.otherElements.containing(.navigationBar, identifier:"A Roman Prince").children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .scrollView).element
        scrollView/*@START_MENU_TOKEN@*/.swipeRight()/*[[".swipeUp()",".swipeRight()"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        scrollView.tap()
        scrollView.tap()
        scrollView.tap()
        scrollView.tap()
        scrollView.tap()
        scrollView.swipeLeft()
        
        let scrollView2 = app.children(matching: .window).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .scrollView).element
        scrollView2.tap()
        scrollView2.tap()
        scrollView2.tap()
        scrollView2.tap()
        scrollView.swipeLeft()
        app.otherElements.containing(.navigationBar, identifier:"Acapulco Lunch").children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .scrollView).element.tap()
        app.navigationBars["Adolfo De Velasco"].buttons["뒤로"].tap()
        
        let gettyimageviewerHomeviewNavigationBar = app.navigationBars["GettyImageViewer.HomeView"]
        gettyimageviewerHomeviewNavigationBar.buttons["항목"].tap()
        app.tables/*@START_MENU_TOKEN@*/.staticTexts["다운로드한 이미지 파일 모두 삭제"]/*[[".cells.staticTexts[\"다운로드한 이미지 파일 모두 삭제\"]",".staticTexts[\"다운로드한 이미지 파일 모두 삭제\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app.sheets.buttons["모든 파일 삭제"].tap()
        app.navigationBars["설정"].buttons["뒤로"].tap()
        gettyimageviewerHomeviewNavigationBar.buttons["새로 고침"].tap()
        

        
    }
    
}
