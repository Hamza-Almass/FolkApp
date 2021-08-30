//
//  ViewController.swift
//  FolkApp
//
//  Created by Hamza Almass on 8/30/21.
//

import UIKit
import EasyPeasy
import RxSwift
import RxCocoa

class PostViewController: UIViewController {

    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.register(PostTableViewCell.self, forCellReuseIdentifier: kPOSTTABLEVIEWCELLID)
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableView.automaticDimension
        tableView.backgroundColor = UIColor(named: kBGCOLOR)
        return tableView
    }()
    
    private let dataService: DataService<[Post]> = .init()
    private var postListVM: PostListViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(named: kBGCOLOR)
        
        setupUI()
        fetchPosts()
        bindUI()
        
    }
    
    private func fetchPosts(){
        postListVM = PostListViewModel(dataService: dataService)
        postListVM.fetchAllPosts(url: "https://jsonplaceholder.typicode.com/posts")
    }
    
    private func setupUI(){
        view.addSubview(tableView)
        tableView.easy.layout(Edges.init(16))
    }
    
    private func bindUI(){
        if postListVM != nil {
            postListVM.posts.bind(to: tableView.rx.items(cellIdentifier: kPOSTTABLEVIEWCELLID, cellType: PostTableViewCell.self)) { (index , post , cell) in
                cell.configureCell(postVM: .init(post: post))
            }.disposed(by: postListVM.disposeBag)
        }
    }

}

