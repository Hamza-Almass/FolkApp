//
//  PostCommentViewController.swift
//  FolkApp
//
//  Created by Hamza Almass on 8/30/21.
//

import UIKit
import SPAlert
import EasyPeasy
import Lottie

class PostCommentViewController: UIViewController {
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor(named: kBGCOLOR)
        tableView.register(PostCommentTableViewCell.self, forCellReuseIdentifier: kPOSTCOMMENTTABLEVIEWCELLID)
        tableView.showsVerticalScrollIndicator = false
        return tableView
    }()
    
    private let post: Post
    private var postCommentListVM: PostCommentListViewModel!
    private let dataService = DataService<[PostComment]>.init()
    private var animationView: AnimationView!
    
    init(post: Post){
        self.post = post
        super.init(nibName: nil, bundle: nil)
        postCommentListVM = .init(dataService: self.dataService, post: post)
        animationView = showLottieAnimation()
        animationView.isHidden = false
        postCommentListVM.fetchComments(url: "https://jsonplaceholder.typicode.com/comments?postId=\(post.id ?? 0)") { [weak self] (error) in
            guard let s = self else { return }
            DispatchQueue.main.async {
                s.animationView.isHidden = true
            }
            if let _ = error {
                DispatchQueue.main.async {
                   // s.showSPAlert(title: "Error", message: error.localizedDescription, iconPreset: .error, haptic: .error)
                }
                return
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor(named: kBGCOLOR)
        setupUI()
        bindUI()
    }
    
    private func setupUI(){
        view.addSubview(tableView)
        tableView.easy.layout(Edges(16))
    }
    
    private func bindUI(){
        if postCommentListVM != nil {
            postCommentListVM.comments.bind(to: tableView.rx.items(cellIdentifier: kPOSTCOMMENTTABLEVIEWCELLID, cellType: PostCommentTableViewCell.self)) { (index,comment,cell) in
                let v = UIView()
                v.backgroundColor = .clear
                cell.configureCell(postCommentVM: .init(postComment: comment))
            }.disposed(by: postCommentListVM.disposeBag)
        }
    }

}
