//
//  Comment.swift
//  FolkApp
//
//  Created by Hamza Almass on 8/30/21.
//

import Foundation

class PostComment: Codable {
    let postId: Int?
    let id: Int?
    let name: String?
    let email: String?
    let body: String?
}
