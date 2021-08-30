//
//  PostDataService.swift
//  FolkApp
//
//  Created by Hamza Almass on 8/30/21.
//

import Foundation
import RxSwift
import RxCocoa

class DataService<Element: Codable> {
    
    func fetchPosts(url: String) -> Observable<Element> {
        return Observable.create { observer -> Disposable in
            Observable.just(url).map({ (str) -> URL in
                URL(string: str)!
            }).map({ (url) -> URLRequest in
                URLRequest(url: url)
            }).flatMap{ request -> Observable<(response: HTTPURLResponse, data: Data)> in
                let response =  URLSession.shared.rx.response(request: request).share(replay: 1, scope: .whileConnected)
                response.filter({ res , _ in
                    return 200..<300 ~= res.statusCode
                }).map { _ , data in
                    guard let element = try? JSONDecoder().decode(Element.self, from: data) else {
                        return
                    }
                    observer.onNext(element)
                    observer.onCompleted()
                }
               return response
            }
            return Disposables.create()
        }
    }
    
}

class MockDataService: DataService<Post> {
    
    override func fetchPosts(url: String) -> Observable<Post> {
        return .just(.init(userId: 1, id: 1, title: "This is a mock title", body: "This is a mock body", username: "Folk app"))
    }
}
