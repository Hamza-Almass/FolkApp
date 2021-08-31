//
//  PostViewModelTest.swift
//  FolkAppTests
//
//  Created by Hamza Almass on 8/31/21.
//

import XCTest
import RxSwift

@testable import FolkApp
class PostListViewModelTest: XCTestCase {

    private let disposeBag = DisposeBag()
    var postListVM: PostListViewModel!
    var dataService: MockPostDataService!
    
    override func setUp() {
        super.setUp()
        
        dataService = .init()
        postListVM = PostListViewModel(dataService: dataService)
       
    }
    
    override func tearDown() {
        super.tearDown()
        postListVM = nil
        dataService = nil
    }
    
    func testPostListViewModel_ProvidePostURL_ShouldReturnPostsObject(){
       
        let expectation = self.expectation(description: "Provide posts url")
        dataService.fetch(url: kPOSTSURL).subscribe(onNext: { (posts) in
            self.postListVM.posts.accept(posts)
            expectation.fulfill()
        }).disposed(by: disposeBag)
        
        wait(for: [expectation], timeout: 0)
        XCTAssertTrue(self.postListVM.posts.value.count > 0  , "Must get array of posts")
       
    }
    
    func testPostViewModel_ShouldReturnPost(){
       
        let expectation = self.expectation(description: "Without provide posts url")
        dataService.fetch(url: "").subscribe(onNext: { (posts) in
            self.postListVM.posts.accept(posts)
            expectation.fulfill()
        }).disposed(by: disposeBag)
        
        wait(for: [expectation], timeout: 0)
        XCTAssertTrue(self.postListVM.posts.value.count == 0  , "Must get empty array of posts")
    }

}
