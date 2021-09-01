//
//  PostCommentListViewModel.swift
//  FolkApp
//
//  Created by Hamza Almass on 8/30/21.
//

import UIKit
import RxCocoa
import RxSwift

//MARK:- PostCommentListViewModel
/// PostCommnetListViewModel
struct PostCommentListViewModel {
    
    //MARK:- Property
    let disposeBag = DisposeBag()
    private var coreDataManager: CoreDataManager<PostCommentCoreData>!
    private let post: Post
    private let dataService: DataService<[PostComment]>
    var comments: BehaviorRelay<[PostComment]> = .init(value: [])
    
    //MARK:- init
    
    /// init
    /// - Parameters:
    ///   - dataService: DataService to fetch the post comments
    ///   - post: Post
    init(dataService: DataService<[PostComment]> , post: Post){
        self.dataService = dataService
        self.post = post
        self.coreDataManager = .init(entity: .postCommentCoreData)
    }
    
    /// actual post
    var myPost: Post {
        return self.post
    }
    
    /// Fetch comments from json placeholder
    /// - Parameters:
    ///   - url: string
    ///   - completion: error if exists
    func fetchComments(url: String,completion: @escaping(_ error: Error?) -> Void){
        
        dataService.fetch(url: url).subscribe(onNext: { (comments) in
           // self.coreDataManager.deleteAllObjectsInCoreData()
            self.coreDataManager.deleteAllCommentsObjectsInCoreDataDepenedOn(PostId: self.post.id ?? 0)
            comments.forEach({
                $0.post = self.post
            })
            self.comments.accept(comments)
            if comments.count > 0 {
                DispatchQueue.main.async {
                    self.saveCommentsInCoreData(comments: comments)
                }
            }
            completion(nil)
        },onError: { (error) in
            self.fetchAllCommentsOffline()
            completion(error)
        }).disposed(by: disposeBag)
    }
    
    //MARK:- Save comments in core data
    /// Save comments in core data
    /// - Parameter comments: [PostComment]]
    private func saveCommentsInCoreData(comments: [PostComment]){
        // Get the post to set the comments to it
        let coreDataManagerForPost = CoreDataManager<PostCoreData>.init(entity: .postCoreData)
        guard let postCoreData = coreDataManagerForPost.fetchElement(fieldName: "id", fieldValue: "\(self.post.id ?? 0)") else { return }
       
        comments.forEach({ (comment) in
           // if let _ = coreDataManager.fetchElement(fieldName: "id", fieldValue: "\(comment.id ?? 0)") {
                
           // }else{
              
                let postCommentCoreData = PostCommentCoreData(context: coreDataManager.context)
                postCommentCoreData.id = Int32(comment.id ?? 0)
                postCommentCoreData.postId = Int32(comment.postId ?? 0)
                postCommentCoreData.body = comment.body
                postCommentCoreData.email = comment.email
                postCommentCoreData.post = postCoreData
                postCoreData.postComments?.adding(postCommentCoreData)
                self.coreDataManager.saveElements()
          //  }
            
        })
    }
    //MARK:- Fetch all comments offline
    /// Fetch all comments from core data if connected offline
    private func fetchAllCommentsOffline(){
        var arrayOfComments = [PostComment]()
        //print(self.post.id , "IDID")
        let postCommentsCoreData = coreDataManager.fetchElements().value.filter({Int($0.postId) == (self.post.id ?? 0)})
        print(postCommentsCoreData.count , "All elements")
        postCommentsCoreData.forEach({ (comment) in
            let postComments = PostComment(post: self.post, postId: self.post.id ?? 0, id: Int(comment.id), name: comment.name, email: comment.email, body: comment.body)
            arrayOfComments.append(postComments)
            if arrayOfComments.count == postCommentsCoreData.count {
                self.comments.accept(arrayOfComments)
            }
        })
    }
    
}

//MARK:- PostCommentViewModel
/// PostCommentViewModel
struct PostCommentViewModel {
    
    private let postComment: PostComment
    
    /// init
    /// - Parameter postComment: PostComment
    init(postComment: PostComment){
        self.postComment = postComment
    }
    
    /// Post comment id as observable
    var postId: Observable<Int> {
        return .just(self.postComment.postId ?? 0)
    }
    
    /// post comment id as observable
    var id: Observable<Int> {
        return .just(self.postComment.id ?? 0)
    }
    
    /// Post comment name as observable
    var commentName: Observable<String> {
        return .just(self.postComment.name ?? "")
    }
    
    /// Post comment email as observable
    var commentEmail: Observable<String> {
        return .just(self.postComment.email ?? "")
    }
    
    /// Post comment body as observable
    var commentBody: Observable<String> {
        return .just(self.postComment.body ?? "")
    }
    
}
