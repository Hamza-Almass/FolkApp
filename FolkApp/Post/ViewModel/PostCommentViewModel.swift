//
//  PostCommentViewModel.swift
//  FolkApp
//
//  Created by Hamza Almass on 8/30/21.
//

import Foundation
import RxSwift
import RxCocoa

struct PostListViewModel {
    
    let disposeBag = DisposeBag()
    private let dataService: DataService<[Post]>
    
    var posts: BehaviorRelay<[Post]> = .init(value: [])
    
    init(dataService: DataService<[Post]>){
        self.dataService = dataService
    }
    
    func fetchAllPosts(url: String) {
        var counterUserNameFetched = 0
        dataService.fetch(url: url).asObservable().subscribe(onNext: { (posts) in
            posts.forEach({ (post) in
                post.fetchPostUserName(url: "https://jsonplaceholder.typicode.com/users?id=\(post.userId ?? 0)") { (error) in
                    if let error = error {
                        print(error)
                        return
                    }
                    counterUserNameFetched += 1
                    if counterUserNameFetched == posts.count {
                        self.posts.accept(posts)
                    }
                    print("Fetch the user name")
                }
            })
           
        }).disposed(by: disposeBag)
    }
    
    
}

struct PostViewModel {
    
    let disposeBag = DisposeBag()
    
    private let post: Post
    
    init(post: Post){
        self.post = post
    }
    
    var postId: Observable<Int> {
        return .just(self.post.id ?? 0)
    }
    
    var postUserId: Observable<Int> {
        return .just(self.post.userId ?? 0)
    }
    
    var postTitle: Observable<String> {
        return .just(self.post.title ?? "")
    }
    
    var postBody: Observable<String> {
        return .just(self.post.body ?? "")
    }
    
    var postUserName: Observable<String> {
        return .just(self.post.username ?? "")
    }
    
}
