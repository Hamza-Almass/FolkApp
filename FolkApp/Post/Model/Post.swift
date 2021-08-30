//
//  Post.swift
//  FolkApp
//
//  Created by Hamza Almass on 8/30/21.
//

import UIKit

class User: Codable {
    
    let id: Int?
    let name: String?
    let username: String?
    
}

class Post: Codable {
    
    var userId: Int?
    var id: Int?
    var title: String?
    var body: String?
    var username: String?
    
    init(userId: Int? , id: Int? , title: String? , body: String? , username: String? = nil){
        self.username = username
        self.id = id
        self.title = title
        self.body = body
        self.userId = userId
    }
    
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
