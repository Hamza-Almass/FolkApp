//
//  Post.swift
//  FolkApp
//
//  Created by Hamza Almass on 8/30/21.
//

import UIKit

/// User Model which belongs to specific post
class User: Codable {
    
    let id: Int?
    let name: String?
    let username: String?
    
}

/// Post model codable to fetch posts from json
class Post: Codable {
    
    var userId: Int?
    var id: Int?
    var title: String?
    var body: String?
    var username: String?
    
    /// init
    /// - Parameters:
    ///   - userId: Int
    ///   - id: Int
    ///   - title: String
    ///   - body: String
    ///   - username: String
    init(userId: Int? , id: Int? , title: String? , body: String? , username: String? = nil){
        self.username = username
        self.id = id
        self.title = title
        self.body = body
        self.userId = userId
    }
    
    /// Fetch post user name
    /// - Parameters:
    ///   - url: URL for the specific fetch user
    ///   - completion: get back error if exists
    func fetchPostUserName(url: String,completion: @escaping(_ error: String?) -> Void){
        guard let url = URL(string: url) else { return }
        URLSession.shared.dataTask(with: url) { (data , res , error) in
            if let error = error {
                completion(error.localizedDescription)
                return
            }
            guard let data = data else { return }
            
            guard let user = try? JSONDecoder().decode([User].self, from: data) else {
                completion("Can't decode the user object")
                return
            }
            self.username = user.first?.username
            completion(nil)
        }.resume()
    }
    
}
