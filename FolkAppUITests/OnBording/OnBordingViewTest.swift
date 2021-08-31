//
//  OnBordingViewTest.swift
//  FolkAppUITests
//
//  Created by Hamza Almass on 8/31/21.
//

import XCTest

@testable import FolkApp
class OnBordingViewTest: XCTestCase {

    var app: XCUIApplication!
    
    override func setUp() {
        super.setUp()
        app = XCUIApplication()
        app.launchEnvironment = ["id":"1","userId": "1"]
        app.launch()
    }
    
    override func tearDown() {
        super.tearDown()
        app = nil
    }
    
    func testOnBordingView_ShouldGetDisplay(){
        let onBordingView = app.otherElements["onBordingView"]
        _ = XCTWaiter.wait(for: [expectation(description: "Wait to show the page view on bording")], timeout: 4)
        XCTAssertTrue(onBordingView.exists, "Must on bording view exists")
    }
    
    func testSwipeOnBording_ShouldMoveRightLeft(){
        
        let nextButton = app.buttons["next"]
        let onBordingView = app.otherElements["onBordingView"]
        onBordingView.swipeLeft()
        onBordingView.swipeRight()
        nextButton.tap()
        
    }
    
    func testOpenPostView_ShouldDisplayPostsAndScrolling(){
        
        let nextButton = app.buttons["next"]
        nextButton.tap()
        nextButton.tap()
        _ = XCTWaiter.wait(for: [expectation(description: "Wait to show the page view on bording")], timeout: 4)
        let tableView = app.tables["postTableView"]
        tableView.swipeUp()
        tableView.swipeDown()
        tableView.cells.allElementsBoundByIndex[0].tap()
      
        
    }

}
