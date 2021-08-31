//
//  MockDataService.swift
//  FolkAppTests
//
//  Created by Hamza Almass on 8/31/21.
//

import RxCocoa
import RxSwift

@testable import FolkApp
class MockPostDataService: DataService<[Post]> {
    
    override func fetch(url: String) -> Observable<[Post]> {
        guard let _ = URL(string: url) else { return .just([])}
        return .just([.init(userId: 1, id: 1, title: "This is a mock title", body: "This is a mock body", username: "Folk app")])
    }
    
}

class MockPostCommentDataService: DataService<[PostComment]> {
    
    override func fetch(url: String) -> Observable<[PostComment]> {
        guard let _ = URL(string: url) else { return .just([])}
        return .just([.init(post: nil, postId: 1, id: 1, name: "This is a name", email: "name@gmail.com", body: "This is a body")])
    }
    
}

