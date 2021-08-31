//
//  PostCommentViewModel.swift
//  FolkAppTests
//
//  Created by Hamza Almass on 8/31/21.
//

import XCTest
import RxSwift
import RxCocoa

@testable import FolkApp
class PostCommentViewModelTest: XCTestCase {

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
    
    func testPostCommentViewModelPostUserName_BelongsToComment_ShouldReturnPostUserName(){
        let expectation = self.expectation(description: "Test post user name belongs to the comments")
        postCommentListViewModel.fetchComments(url: getPostCommentURL(id: 1)) { (error) in
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0)
        XCTAssertEqual(postCommentListViewModel.comments.value[0].post?.username ?? "", "Folk app")
    }
    
    func testPostCommentViewModelCommentBody_ShouldGetCommentBody(){
        let expectation = self.expectation(description: "Test post comment body")
        postCommentListViewModel.fetchComments(url: getPostCommentURL(id: 1)) { (error) in
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0)
        XCTAssertEqual(postCommentListViewModel.comments.value[0].body ?? "", "This is a body")
    }
    
    func testPostCommentViewModelEmail_ShouldGetCommentEmail(){
        let expectation = self.expectation(description: "Test post comment email")
        postCommentListViewModel.fetchComments(url: getPostCommentURL(id: 1)) { (error) in
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0)
        XCTAssertEqual(postCommentListViewModel.comments.value[0].email ?? "", "name@gmail.com")
    }
    
    func testPostCommentViewModelTitle_ShouldGetCommentTitle(){
        let expectation = self.expectation(description: "Test post comment id")
        postCommentListViewModel.fetchComments(url: getPostCommentURL(id: 1)) { (error) in
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0)
        XCTAssertTrue((postCommentListViewModel.comments.value[0].id ?? 0) == 1 , "Must return id 1")
    }
    
    func testPostCommentViewModelPostId_ShouldGetCommentPostId(){
        let expectation = self.expectation(description: "Test post comment post id")
        postCommentListViewModel.fetchComments(url: getPostCommentURL(id: 1)) { (error) in
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0)
        XCTAssertTrue((postCommentListViewModel.comments.value[0].postId ?? 0) == 1 , "Must return id 1")
    }
    
    func testPostCommentViewModel_PostBelongsComment_ShouldGetPostTitle(){
        let expectation = self.expectation(description: "Test post title belongs to post comments")
        postCommentListViewModel.fetchComments(url: getPostCommentURL(id: 1)) { (error) in
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0)
        XCTAssertEqual(postCommentListViewModel.comments.value[0].post?.title ?? "", "This is a title")
    }
    
    func testPostCommentViewModel_PostBelongsComment_ShouldGetPostBody(){
        let expectation = self.expectation(description: "Test post body belongs to post comments")
        postCommentListViewModel.fetchComments(url: getPostCommentURL(id: 1)) { (error) in
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0)
        XCTAssertEqual(postCommentListViewModel.comments.value[0].post?.body ?? "", "This is a body")
    }


}
