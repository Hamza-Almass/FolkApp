//
//  LaunchScreenViewTest.swift
//  FolkAppUITests
//
//  Created by Hamza Almass on 8/31/21.
//

import XCTest

@testable import FolkApp
class LaunchScreenViewTest: XCTestCase {
    
    var app: XCUIApplication!
    
    override func setUp() {
        super.setUp()
        
        app = XCUIApplication()
        app.launch()
    }
    
    override func tearDown() {
        super.tearDown()
        app = nil
    }

    func testLaunchScreen_ShouldGetDisplayLaunchScreen(){
        let launchScreenView = app.otherElements["launchScreen"]
        XCTAssertTrue(launchScreenView.exists , "Must launch screen exists")
    }

}
