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
import SPAlert
import Lottie

class PostViewController: UIViewController {

    //MARK:- Property
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.register(PostTableViewCell.self, forCellReuseIdentifier: kPOSTTABLEVIEWCELLID)
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableView.automaticDimension
        tableView.backgroundColor = UIColor(named: kBGCOLOR)
        tableView.showsVerticalScrollIndicator = false
        return tableView
    }()
    
    //MARK:- Post VC properties
    let navbarTextImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "helloFolk")
        imageView.backgroundColor = .clear
        return imageView
    }()
   
    let navbarLineImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "lines")
        imageView.backgroundColor = .clear
        return imageView
    }()
    
   
    private let dataService: DataService<[Post]> = .init()
    private var postListVM: PostListViewModel!
    private var animationView: AnimationView!
    
    //MARK:- viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.accessibilityIdentifier = "PostView"
        tableView.accessibilityIdentifier = "postTableView"
        view.backgroundColor = UIColor(named: kBGCOLOR)
        
        onBordingView()
        setupUI()
        setupNavBarIcons()
    
    }
    
    //MARK:- SetupNavBar
    /// SetupNavBarIcons
    private func setupNavBarIcons(){
        let iconNavbarHStackView = UIStackView(arrangedSubviews: [navbarLineImageView , navbarTextImageView])
        iconNavbarHStackView.axis = .horizontal
        iconNavbarHStackView.alignment = .fill
        iconNavbarHStackView.distribution = .fill
        iconNavbarHStackView.spacing = 5
        navbarLineImageView.widthAnchor.constraint(equalToConstant: 20).isActive = true
        navbarLineImageView.heightAnchor.constraint(equalToConstant: 20).isActive = true
        iconNavbarHStackView.tag = 1000
        navigationController?.navigationBar.addSubview(iconNavbarHStackView)
        iconNavbarHStackView.easy.layout(CenterX(0),CenterY(0),Width(self.view.frame.width * 0.3))
    }
    //MARK:- Create on bording view and show it
    /// Create on bording View and show it
    private func onBordingView(){
        let pageViewController = PageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        pageViewController.modalPresentationStyle = .fullScreen
        present(pageViewController, animated: true, completion: nil)
        
        pageViewController.completion = { [weak self] in
            guard let s = self else { return }
            if ProcessInfo.processInfo.arguments.contains("-fakeData") {
                s.postListVM = .init(dataService: s.dataService)
                s.postListVM.posts.accept([.init(userId: 1, id: 1, title: "It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout. The point of using Lorem", body: "Ipsum is that it has a more-or-less normal distribution of letters, as opposed to using 'Content here, content here', making it look like readable English. Many desktop publishing packages and web page editors now use Lorem Ipsum as their default model text, and a search for 'lorem ipsum' will uncover many web sites still in their infancy. Various versions have evolved over the years, sometimes by accident,", username: "Fake user name 1"),.init(userId: 2, id: 2, title: "Contrary to popular belief, Lorem Ipsum is not simply random text. It has roots in a piece of classical Latin literature from 45 BC, making it over 2000 years", body: "Richard McClintock, a Latin professor at Hampden-Sydney College in Virginia, looked up one of the more obscure Latin words, consectetur, from a Lorem Ipsum passage, and going through the cites of the word in classical literature, discovered the undoubtable source. Lorem Ipsum comes from sections 1.10.32 and 1.10.33 of de Finibus Bonorum et Malorum (The Extremes of Good and Evil) by Cicero", username: "Fake user name 2")])
            }else{
                s.fetchPosts()
            }
            s.bindUI()
        }
    }
    
    /// Fetch posts form json placeholder
    private func fetchPosts(){
        animationView = showLottieAnimation()
        animationView.isHidden = false
        postListVM = PostListViewModel(dataService: dataService)
        postListVM.fetchAllPosts(url: kPOSTSURL) { [weak self] (error)  in
            guard let s = self else { return }
            
            DispatchQueue.main.async {
                s.animationView.isHidden = true
            }

            if let error = error {
                DispatchQueue.main.async {
                    s.showSPAlert(title: "Error", message: error.localizedDescription, iconPreset: .error, haptic: .error)
                    return
                }
            }
        }
    }
    //MARK:- SetupUI
    /// SetuUI
    private func setupUI(){
        view.addSubview(tableView)
        tableView.easy.layout(Edges.init(16))
    }
    
    //MARK:- Bind UI
    /// Bind UI
    private func bindUI(){
        if postListVM != nil {
            postListVM.posts.bind(to: tableView.rx.items(cellIdentifier: kPOSTTABLEVIEWCELLID, cellType: PostTableViewCell.self)) { (index , post , cell) in
                let v = UIView()
                v.backgroundColor = .clear
                cell.selectedBackgroundView = v
                cell.configureCell(postVM: .init(post: post))
            }.disposed(by: postListVM.disposeBag)
            
            tableView.rx.itemSelected.subscribe(onNext: { [weak self] (indexP) in
                guard let s = self else { return }
                let postCommentController = PostCommentViewController(post: s.postListVM.posts.value[indexP.row])
                s.navigationController?.pushViewController(postCommentController, animated: true)
            }).disposed(by: postListVM.disposeBag)
        }
    }

}

