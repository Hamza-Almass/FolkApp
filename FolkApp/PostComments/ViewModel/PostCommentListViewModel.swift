//
//  PostCommentListViewModel.swift
//  FolkApp
//
//  Created by Hamza Almass on 8/30/21.
//

import UIKit
import RxCocoa
import RxSwift

struct PostCommentListViewModel {
    
    let disposeBag = DisposeBag()
    
    private var coreDataManager: CoreDataManager<PostCommentCoreData>!
    
    private let post: Post
    private let dataService: DataService<[PostComment]>
    
    var comments: BehaviorRelay<[PostComment]> = .init(value: [])
    
    init(dataService: DataService<[PostComment]> , post: Post){
        self.dataService = dataService
        self.post = post
        self.coreDataManager = .init(entity: .postCommentCoreData)
    }
    
    var myPost: Post {
        return self.post
    }
    
    func fetchComments(url: String,completion: @escaping(_ error: Error?) -> Void){
        
        dataService.fetch(url: url).subscribe(onNext: { (comments) in
            self.coreDataManager.deleteAllObjectsInCoreData()
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
    
   
    private func saveCommentsInCoreData(comments: [PostComment]){
        // Get the post to set the comments to it
        let coreDataManagerForPost = CoreDataManager<PostCoreData>.init(entity: .postCoreData)
        guard let postCoreData = coreDataManagerForPost.fetchElement(fieldName: "id", fieldValue: "\(self.post.id ?? 0)") else { return }
        print(comments.count)
        comments.forEach({ (comment) in
            let postCommentCoreData = PostCommentCoreData(context: coreDataManager.context)
            postCommentCoreData.body = comment.body
            postCommentCoreData.email = comment.email
            postCommentCoreData.post = postCoreData
            postCoreData.postComments?.adding(postCommentCoreData)
            self.coreDataManager.saveElements()
        })
    }
    
    private func fetchAllCommentsOffline(){
        var arrayOfComments = [PostComment]()
        let postCommentsCoreData = coreDataManager.fetchElements().value
        postCommentsCoreData.forEach({ (comment) in
            let postComments = PostComment(post: self.post, postId: self.post.id ?? 0, id: Int(comment.id), name: comment.name, email: comment.email, body: comment.body)
            arrayOfComments.append(postComments)
            if arrayOfComments.count == postCommentsCoreData.count {
                self.comments.accept(arrayOfComments)
            }
        })
    }
    
}

struct PostCommentViewModel {
    
    private let postComment: PostComment
    
    init(postComment: PostComment){
        self.postComment = postComment
    }
    
    var postId: Observable<Int> {
        return .just(self.postComment.postId ?? 0)
    }
    
    var id: Observable<Int> {
        return .just(self.postComment.id ?? 0)
    }
    
    var commentName: Observable<String> {
        return .just(self.postComment.name ?? "")
    }
    
    var commentEmail: Observable<String> {
        return .just(self.postComment.email ?? "")
    }
    
    var commentBody: Observable<String> {
        return .just(self.postComment.body ?? "")
    }
    
}
