//
//  PostCommentViewModel.swift
//  FolkApp
//
//  Created by Hamza Almass on 8/30/21.
//

import Foundation
import RxSwift
import RxCocoa

struct PostCommentListViewModel {
    
    private let disposeBag = DisposeBag()
    
    private let dataService: DataService<[Post]>
    private var posts: BehaviorRelay<[Post]> = .init(value: [])
    
    init(dataService: DataService<[Post]>){
        self.dataService = dataService
    }
    
    func fetchAllPosts(url: String) {
        dataService.fetchPosts(url: url).subscribe(onNext: { (posts) in
            self.posts.accept(posts)
        }).disposed(by: disposeBag)
    }
    
    
}

struct PostCommentViewModel {
    
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
