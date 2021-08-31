//
//  Global.swift
//  FolkApp
//
//  Created by Hamza Almass on 8/31/21.
//

import Foundation

/// Method to create comment url by passing user id
/// - Parameter id: Int
/// - Returns: String
public func getPostCommentURL(id: Int) -> String {
    return "https://jsonplaceholder.typicode.com/comments?postId=\(id)"
}
