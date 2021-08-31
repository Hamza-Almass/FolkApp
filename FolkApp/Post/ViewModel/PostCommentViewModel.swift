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
    
    //MARK:- Property
    let disposeBag = DisposeBag()
    let coreDataManager = CoreDataManager<PostCoreData>(entity: .postCoreData)
    private let dataService: DataService<[Post]>
    var posts: BehaviorRelay<[Post]> = .init(value: [])
    
    //MARK:- init
    /// init
    /// - Parameter dataService: DataService to provide data to this view model
    init(dataService: DataService<[Post]>){
        self.dataService = dataService
    }
    
    ///MARK:- Fetch all posts
    /// - Parameter url: URL As String
    func fetchAllPosts(url: String,completion: @escaping ((_ error: Error?) -> Void)) {
        
        var counterUserNameFetched = 0
        dataService.fetch(url: url).asObservable().subscribe(onNext: { (posts) in
           
            // If we get elements must delete the old one
            if posts.count > 0 {
                coreDataManager.deleteAllObjectsInCoreData()
            }
            
            posts.forEach({ (post) in
                post.fetchPostUserName(url: "https://jsonplaceholder.typicode.com/users?id=\(post.userId ?? 0)") { (error) in
                    
                    if let error = error {
                        print(error)
                        return
                    }
                    // Insert object to core data
                    let postCoreData = PostCoreData(context: self.coreDataManager.context)
                    postCoreData.body = post.body
                    postCoreData.id = Int32(post.id ?? 0)
                    postCoreData.userId = Int32(post.userId ?? 0)
                    postCoreData.title = post.title
                    postCoreData.username = post.username
                    /////
                    
                    // Fetch the user name and assign it to the post
                    counterUserNameFetched += 1
                    if counterUserNameFetched == posts.count {
                        self.posts.accept(posts)
                        coreDataManager.saveElements()
                        completion(nil)
                    }
                    ///////
                    
                }
            })
            
        },onError: { (error) in
            completion(error)
            self.fetchObjectsFromCoreData()
        }).disposed(by: disposeBag)
    }
    
    //MARK:- Fetch object from core data if offline
    /// Fetch object from core data if offline
    func fetchObjectsFromCoreData(){
        var arrayOfPost = [Post]()
        let allPostCoreData = coreDataManager.fetchElements().value
        allPostCoreData.forEach({ (postCoreData) in
            arrayOfPost.append(.init(userId: Int(postCoreData.userId), id: Int(postCoreData.id), title: postCoreData.title, body: postCoreData.body, username: postCoreData.username))
            if arrayOfPost.count == allPostCoreData.count {
                self.posts.accept(arrayOfPost)
            }
        })
    }
    
}
//MARK:- Post view model
/// Post View Model
struct PostViewModel {
    
    let disposeBag = DisposeBag()
    
    private let post: Post
    
    /// init
    /// - Parameter post: Post
    init(post: Post){
        self.post = post
    }
    /// PostId as Observable
    var postId: Observable<Int> {
        return .just(self.post.id ?? 0)
    }
    
    /// Post user id as observable
    var postUserId: Observable<Int> {
        return .just(self.post.userId ?? 0)
    }
    
    /// Post title as obseravble
    var postTitle: Observable<String> {
        return .just(self.post.title ?? "")
    }
    
    /// Post body as obseravble
    var postBody: Observable<String> {
        return .just(self.post.body ?? "")
    }
    
    /// Post iser name as observable
    var postUserName: Observable<String> {
        return .just(self.post.username ?? "")
    }
    
}
