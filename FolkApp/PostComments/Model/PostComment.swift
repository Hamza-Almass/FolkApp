//
//  Comment.swift
//  FolkApp
//
//  Created by Hamza Almass on 8/30/21.
//

import Foundation

class PostComment: Codable {
    
    var post: Post?
    var postId: Int?
    var id: Int?
    var name: String?
    var email: String?
    var body: String?
    
    init(post: Post? = nil , postId: Int? , id: Int?,name: String? , email: String?,body: String?){
        self.post = post
        self.postId = postId
        self.id = id
        self.name = name
        self.email = email
        self.body = body
    }
    
}
