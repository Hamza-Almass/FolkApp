//
//  PostViewModelTest.swift
//  FolkAppTests
//
//  Created by Hamza Almass on 8/31/21.
//

import XCTest
import RxSwift

@testable import FolkApp
class PostViewModelTest: XCTestCase {

    private let disposeBag = DisposeBag()
    private var dataService: MockPostDataService!
    private var postListViewModel: PostListViewModel!
    
    override func setUp() {
        super.setUp()
        
        dataService = .init()
        postListViewModel = .init(dataService: dataService)
    }
    
    override func tearDown() {
        super.tearDown()
        postListViewModel = nil
        dataService = nil
    }
    
    func testPostViewModelPostUserName_ShouldGetPostUserName(){
        var allPosts = [Post]()
        let expectation = expectation(description: "Must we received Post username")
        dataService.fetch(url: kPOSTSURL).subscribe(onNext: { (posts) in
            allPosts = posts
            expectation.fulfill()
        }).disposed(by: disposeBag)
        wait(for: [expectation], timeout: 0)
        let postViewModel = PostViewModel(post: allPosts[0])
        postViewModel.postUserName.subscribe(onNext: { (userName) in
            XCTAssertEqual(userName, "Folk app")
        }).disposed(by: disposeBag)
    }
    
    func testPostViewModelPostTitle_ShouldGetPostTitle(){
        var allPosts = [Post]()
        let expectation = expectation(description: "Must we received Post title")
        dataService.fetch(url: kPOSTSURL).subscribe(onNext: { (posts) in
            allPosts = posts
            expectation.fulfill()
        }).disposed(by: disposeBag)
        wait(for: [expectation], timeout: 0)
        let postViewModel = PostViewModel(post: allPosts[0])
        postViewModel.postTitle.subscribe(onNext: { (title) in
            XCTAssertEqual(title, "This is a mock title")
        }).disposed(by: disposeBag)
    }
    
    func testPostViewModelPostBody_ShouldGetPostBody(){
        var allPosts = [Post]()
        let expectation = expectation(description: "Must we received Post body")
        dataService.fetch(url: kPOSTSURL).subscribe(onNext: { (posts) in
            allPosts = posts
            expectation.fulfill()
        }).disposed(by: disposeBag)
        wait(for: [expectation], timeout: 0)
        let postViewModel = PostViewModel(post: allPosts[0])
        postViewModel.postBody.subscribe(onNext: { (title) in
            XCTAssertEqual(title, "This is a mock body")
        }).disposed(by: disposeBag)
    }
    
    func testPostViewModelPostId_ShouldGetPostId(){
        var allPosts = [Post]()
        let expectation = expectation(description: "Must we received Post Id")
        dataService.fetch(url: kPOSTSURL).subscribe(onNext: { (posts) in
            allPosts = posts
            expectation.fulfill()
        }).disposed(by: disposeBag)
        wait(for: [expectation], timeout: 0)
        let postViewModel = PostViewModel(post: allPosts[0])
        postViewModel.postId.subscribe(onNext: { (id) in
            XCTAssertEqual("\(id)", "1")
        }).disposed(by: disposeBag)
    }
    
    func testPostViewModelPostUserId_ShouldGetPostUserId(){
        var allPosts = [Post]()
        let expectation = expectation(description: "Must we received Post userId")
        dataService.fetch(url: kPOSTSURL).subscribe(onNext: { (posts) in
            allPosts = posts
            expectation.fulfill()
        }).disposed(by: disposeBag)
        wait(for: [expectation], timeout: 0)
        let postViewModel = PostViewModel(post: allPosts[0])
        postViewModel.postUserId.subscribe(onNext: { (id) in
            XCTAssertEqual("\(id)", "1")
        }).disposed(by: disposeBag)
    }

}
