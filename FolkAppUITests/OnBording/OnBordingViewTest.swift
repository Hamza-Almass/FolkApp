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

}
