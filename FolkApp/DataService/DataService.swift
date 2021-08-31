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
    
    private let disposeBag = DisposeBag()
    
    func fetch(url: String) -> Observable<Element> {
        return Observable.create { observer -> Disposable in
            Observable.just(url).map({ (str) -> URL in
                return URL(string: str)!
            }).map({ (url) -> URLRequest in
                return URLRequest(url: url)
            }).flatMap{ request -> Observable<(response: HTTPURLResponse, data: Data)> in
                let response = URLSession.shared.rx.response(request: request)
                response.asObservable().subscribe { result in
                    
                } onError: { error in
                    observer.onError(error)
                }.disposed(by: self.disposeBag)
                return response
            }
            .share(replay: 1, scope: .whileConnected).subscribe(onNext: { (response) in
                guard let elements = try? JSONDecoder().decode(Element.self, from: response.data) else { return }
                observer.onNext(elements)
                observer.onCompleted()
            })
            .disposed(by: self.disposeBag)
            return Disposables.create()
        }
    }
    
}

class MockPostDataService: DataService<[Post]> {
    
    override func fetch(url: String) -> Observable<[Post]> {
        guard let _ = URL(string: url) else { return .just([])}
        return .just([.init(userId: 1, id: 1, title: "This is a mock title", body: "This is a mock body", username: "Folk app")])
    }
    
}

//class MockPostCommentDataService: DataService<PostComment> {
//
//    override func fetch(url: String) -> Observable<PostComment> {
//        return .just(.ini)
//    }
//}
