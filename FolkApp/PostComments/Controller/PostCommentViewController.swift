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

class PostCommentViewController: UIViewController , UITableViewDelegate {
    
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .init(), style: .grouped)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor(named: kBGCOLOR)
        tableView.register(PostCommentTableViewCell.self, forCellReuseIdentifier: kPOSTCOMMENTTABLEVIEWCELLID)
        tableView.showsVerticalScrollIndicator = false
        tableView.estimatedSectionHeaderHeight = 100
        tableView.sectionHeaderHeight = UITableView.automaticDimension
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
            tableView.rx.setDelegate(self).disposed(by: postCommentListVM.disposeBag)
            postCommentListVM.comments.bind(to: tableView.rx.items(cellIdentifier: kPOSTCOMMENTTABLEVIEWCELLID, cellType: PostCommentTableViewCell.self)) { (index,comment,cell) in
                let v = UIView()
                v.backgroundColor = .clear
                cell.configureCell(postCommentVM: .init(postComment: comment))
            }.disposed(by: postCommentListVM.disposeBag)
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if postCommentListVM != nil {
            return createHeaderView(userName: postCommentListVM.myPost.username ?? "", title: postCommentListVM.myPost.title ?? "", body: postCommentListVM.myPost.body ?? "")
        }
       return nil
    }

}

extension PostCommentViewController {
    
    fileprivate func createHeaderView(userName: String , title: String , body: String) -> UIView {
       
        let v = UIView()
        v.backgroundColor = .white
        
        let imageView = UIImageView()
        imageView.backgroundColor = .yellow
        imageView.layer.cornerRadius = 20
        imageView.clipsToBounds = true
        
        let userNameLabel = UILabel()
        userNameLabel.textColor = UIColor(named: kTEXTCOLOR)
        userNameLabel.text = userName
        
        let titleLabel = UILabel()
        titleLabel.textColor = UIColor(named: kTITLECOLOR)
        titleLabel.text = title
        titleLabel.numberOfLines = 0
        
        let bodyLabel = UILabel()
        bodyLabel.textColor = UIColor(named: kTEXTCOLOR)
        bodyLabel.text = body
        bodyLabel.numberOfLines = 0
        
        let seperatorView = UIView()
        seperatorView.backgroundColor = .systemGray6
        
        v.addSubview(imageView)
        v.addSubview(userNameLabel)
        v.addSubview(titleLabel)
        v.addSubview(bodyLabel)
        v.addSubview(seperatorView)
        
        imageView.easy.layout(Width(40) , Height(40),Top(10),Leading(16))
        userNameLabel.easy.layout(CenterY(0).to(imageView,.centerY),Leading(16).to(imageView,.trailing),Height(30))
        titleLabel.easy.layout(Leading(16),Trailing(16),Top(10).to(imageView,.bottom))
        bodyLabel.easy.layout(Top(10).to(titleLabel,.bottom),Leading(16),Trailing(16),Bottom(10))
        seperatorView.easy.layout(Bottom(2),Height(8),Leading(0),Trailing(0))
        
        return v
        
    }
}
