//
//  Post_PostCommentViewTest.swift
//  FolkAppUITests
//
//  Created by Hamza Almass on 8/31/21.
//

import XCTest

@testable import FolkApp

class Post_PostCommentViewTest: XCTestCase {

    var app: XCUIApplication!
    
    override func setUp() {
        super.setUp()
        
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchArguments = ["-fakeData"]
        app.launch()
        sleep(1)
        
    }
    
    override func tearDown() {
        super.tearDown()
        app = nil
    }
    
    func testOpenPostView_PostCommentView_ShouldDisplayPostsAndCommentsWithScrolling(){
        
        let onBordingView = app.otherElements["onBordingView"]
        let nextButton = app.buttons["next"]
        onBordingView.swipeLeft()
        nextButton.tap()
       
        let tableView = app.tables["postTableView"]
        tableView.swipeUp()
        tableView.swipeDown()
        tableView.cells.allElementsBoundByIndex[0].tap()
        
        let commentTableView = app.tables["commentTableView"]
        commentTableView.swipeUp()
        commentTableView.swipeDown()
        app.navigationBars["FolkApp.PostCommentView"].buttons["Back"].tap()
      
    }
    

}
