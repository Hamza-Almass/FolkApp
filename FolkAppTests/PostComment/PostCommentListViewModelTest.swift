//
//  PostCommentListViewModelTest.swift
//  FolkAppTests
//
//  Created by Hamza Almass on 8/31/21.
//

import XCTest
import RxSwift
import RxCocoa

@testable import FolkApp
class PostCommentListViewModelTest: XCTestCase {

    private let disposeBag = DisposeBag()
    private var dataService: MockPostCommentDataService!
    private var postCommentListViewModel: PostCommentListViewModel!
    
    override func setUp() {
        super.setUp()
        dataService = .init()
        postCommentListViewModel = .init(dataService: dataService, post: .init(userId: 1, id: 1, title: "This is a title", body: "This is a body", username: "Folk app"))
    }
    
    override func tearDown() {
        super.tearDown()
        dataService = nil
        postCommentListViewModel = nil
    }
    
    func testPostCommentListViewModel_ProvideURL_ShouldGetPostComments(){
        let expectation = self.expectation(description: "Provide post comment url")
        postCommentListViewModel.fetchComments(url: getPostCommentURL(id: 1)) { (error) in
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0)
        XCTAssertTrue(postCommentListViewModel.comments.value.count > 0 , "Must get array of comments")
    }
    
    func testPostCommentListViewModel_WithoutProvideURL_ShouldGetEmptyArrayOfComments(){
        let expectation = self.expectation(description: "Without Provide post comment url")
        postCommentListViewModel.fetchComments(url: "") { (error) in
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0)
        XCTAssertTrue(postCommentListViewModel.comments.value.count == 0 , "Must get empty array of comments")
    }
   

}
