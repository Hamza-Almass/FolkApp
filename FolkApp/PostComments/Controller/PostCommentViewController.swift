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
    
    //MARK:- Property
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
        tableView.accessibilityIdentifier = "commentTableView"
        return tableView
    }()
    
    let titleStatusLabelNoComments: UILabel = {
      let label = UILabel()
        label.text = "No comments loaded"
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textColor = UIColor(named: kTEXTCOLOR)
        label.isHidden = true
        label.textAlignment = .center
        return label
    }()
    private let post: Post
    private var postCommentListVM: PostCommentListViewModel!
    private let dataService = DataService<[PostComment]>.init()
    private var animationView: AnimationView!
    
    /// init
    /// - Parameter post: Post
    init(post: Post){
        
        self.post = post
        super.init(nibName: nil, bundle: nil)
        // Fake date for test
        if ProcessInfo.processInfo.arguments.contains("-fakeData") {
            postCommentListVM = .init(dataService: self.dataService, post: post)
            postCommentListVM.comments.accept([.init(post: self.post, postId: 1, id: 1, name: " is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's", email: "fake@gmail", body: "standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum."),.init(post: self.post, postId: 1, id: 1, name: "t is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout. The point of using Lorem Ipsum i", email: "fake_fake@gmail.com", body: "that it has a more-or-less normal distribution of letters, as opposed to using 'Content here, content here', making it look like readable English. Many desktop publishing packages and web page editors now use Lorem Ipsum as their default model text, and a search for 'lorem ipsum' will uncover many web sites still in their infancy. Various versions have evolved over the years, sometimes by accident, sometimes on purpose (injected humour and the like).")])
        }else{
            // Real network call data
            postCommentListVM = .init(dataService: self.dataService, post: post)
            animationView = showLottieAnimation()
            animationView.isHidden = false
            postCommentListVM.fetchComments(url: getPostCommentURL(id: post.id ?? 0)) { [weak self] (error) in
                guard let s = self else { return }
                DispatchQueue.main.async {
                    s.animationView.isHidden = true
                }
                if let _ = error {
                    return
                }
            }
        }

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK:- viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor(named: kBGCOLOR)
      
        setupUI()
        bindUI()
    }
    //MARK:- SetupUI
    private func setupUI(){
        view.addSubview(tableView)
        tableView.easy.layout(Edges(0))
        view.addSubview(titleStatusLabelNoComments)
        titleStatusLabelNoComments.easy.layout(Center(0),Leading(16) , Trailing(16) , Height(35))
    }
    //MARK:- BindUI
    private func bindUI(){
        if postCommentListVM != nil {
            tableView.rx.setDelegate(self).disposed(by: postCommentListVM.disposeBag)
            postCommentListVM.comments.bind(to: tableView.rx.items(cellIdentifier: kPOSTCOMMENTTABLEVIEWCELLID, cellType: PostCommentTableViewCell.self)) { (index,comment,cell) in
                let v = UIView()
                v.backgroundColor = .clear
                cell.configureCell(postCommentVM: .init(postComment: comment))
            }.disposed(by: postCommentListVM.disposeBag)
            
            postCommentListVM.comments.map({$0.count > 0 ? true : false}).bind(to: titleStatusLabelNoComments.rx.isHidden).disposed(by: postCommentListVM.disposeBag)
        }
        
    }
    //MARK:- Table view header
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if postCommentListVM != nil {
            return createHeaderView(userName: postCommentListVM.myPost.username ?? "", title: postCommentListVM.myPost.title ?? "", body: postCommentListVM.myPost.body ?? "")
        }
       return nil
    }

}

//MARK:- Extension
extension PostCommentViewController {
    
    //MARK:- Create header table view
    /// Create header table view
    /// - Parameters:
    ///   - userName: string
    ///   - title: string
    ///   - body: string
    /// - Returns: UIView
    fileprivate func createHeaderView(userName: String , title: String , body: String) -> UIView {
       
        let v = UIView()
        v.backgroundColor = UIColor(named: kBGCELLCOLOR)
        
        let imageView = UIImageView()
        imageView.image = UIImage(named: "lines")?.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = .lightGray
        imageView.layer.borderColor = UIColor.lightGray.cgColor
        imageView.layer.borderWidth = 1
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
