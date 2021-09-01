//
//  DataServiceTest.swift
//  FolkAppTests
//
//  Created by Hamza Almass on 8/31/21.
//

import XCTest
import RxSwift

@testable import FolkApp
class PostDataServiceTest: XCTestCase {

    private let disposeBag = DisposeBag()
    var dataService: MockPostDataService!
    
    override func setUp() {
        super.setUp()
        dataService = .init()
    }
    
    override func tearDown() {
        super.setUp()
        dataService = nil
    }
    
    func testPostDataService_ProvideURL_ShouldReturnPost(){
        var allPosts = [Post]()
        let expectation = self.expectation(description: "Provide URL to get posts")
        dataService.fetch(url: kPOSTSURL).subscribe(onNext: { (posts) in
            allPosts = posts
            expectation.fulfill()
        }).disposed(by: disposeBag)
        wait(for: [expectation], timeout: 0)
        XCTAssertTrue(allPosts.count > 0, "Must get posts")
    }
    
    func testPostDataService_WithoutProvideURL_ShouldReturnEmptyPosts(){
        var allPosts = [Post]()
        let expectation = self.expectation(description: "Without provide URL to get posts")
        dataService.fetch(url: "").subscribe(onNext: { (posts) in
            allPosts = posts
            expectation.fulfill()
        }).disposed(by: disposeBag)
        wait(for: [expectation], timeout: 0)
        XCTAssertTrue(allPosts.count == 0, "Must get empty posts")
    }
    
    func testPostDataService_WithIncorrectPostsURL_ShouldReturnEmptyPosts(){
        var allPosts = [Post]()
        let expectation = self.expectation(description: "With Incorrect PostsURL")
        dataService.fetch(url: kPOSTSURL + "a").subscribe(onNext: { (posts) in
            allPosts = posts
            expectation.fulfill()
        }).disposed(by: disposeBag)
        wait(for: [expectation], timeout: 0)
        XCTAssertTrue(allPosts.count == 0, "Must get empty posts")
        
    }

}
