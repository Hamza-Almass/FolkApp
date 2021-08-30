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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(named: kBGCOLOR)
        
        onBordingView()
        setupUI()
        setupNavBarIcons()
    }
    
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
    
    private func onBordingView(){
        let pageViewController = PageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        pageViewController.modalPresentationStyle = .fullScreen
        present(pageViewController, animated: true, completion: nil)
        
        pageViewController.completion = { [weak self] in
            guard let s = self else { return }
            s.fetchPosts()
            s.bindUI()
        }
    }
    
    private func fetchPosts(){
        animationView = showLottieAnimation()
        animationView.isHidden = false
        postListVM = PostListViewModel(dataService: dataService)
        postListVM.fetchAllPosts(url: "https://jsonplaceholder.typicode.com/posts") { [weak self] (error)  in
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
    
    private func setupUI(){
        view.addSubview(tableView)
        tableView.easy.layout(Edges.init(16))
    }
    
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

