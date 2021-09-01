//
//  PostCommentDataServiceTest.swift
//  FolkAppTests
//
//  Created by Hamza Almass on 8/31/21.
//

import XCTest
import RxSwift
import RxCocoa

@testable import FolkApp
class PostCommentDataServiceTest: XCTestCase {
    
    private let disposeBag = DisposeBag()
    private var dataService: MockPostCommentDataService!

    override func setUp() {
        super.setUp()
        dataService = .init()
    }
    
    override func tearDown() {
        super.tearDown()
        dataService = nil
    }
    
    func testPostComment_WithPostCommentURL_ShouldReturnComments(){
        var allComments = [PostComment]()
        let expectation = self.expectation(description: "Provide post comment url")
        dataService.fetch(url: getPostCommentURL(id: 1)).subscribe(onNext: { (comments) in
            allComments = comments
            expectation.fulfill()
        }).disposed(by: disposeBag)
        wait(for: [expectation], timeout: 0)
        XCTAssertTrue(allComments.count > 0 , "Must get array of comments")
    }
    
    func testPostComment_WithoutPostCommentURL_ShouldReturnArrayOfEmptyComments(){
        var allComments = [PostComment]()
        let expectation = self.expectation(description: "Without post comment url")
        dataService.fetch(url: "").subscribe(onNext: { (comments) in
            allComments = comments
            expectation.fulfill()
        }).disposed(by: disposeBag)
        wait(for: [expectation], timeout: 0)
        XCTAssertTrue(allComments.count == 0 , "Must get empty array of comments")
    }
    
    func testPostComment_WithIncorrectPostCommentURL_ShouldReturnEmptyComments(){
        var allComments = [PostComment]()
        let expectation = self.expectation(description: "Without post comment url")
        dataService.fetch(url: getPostCommentURL(id: 0)).subscribe(onNext: { (comments) in
            allComments = comments
            expectation.fulfill()
        }).disposed(by: disposeBag)
        wait(for: [expectation], timeout: 0)
        XCTAssertTrue(allComments.count == 0 , "Must get empty array of comments")
    }

}
