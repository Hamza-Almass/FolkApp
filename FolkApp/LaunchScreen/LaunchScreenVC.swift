//
//  LaunchScreenVC.swift
//  FolkApp
//
//  Created by Hamza Almass on 8/31/21.
//

import UIKit
import EasyPeasy

class LaunchScreenVC: UIViewController {
    
    // Property
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .clear
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 0
        return imageView
    }()
    
    /// init
    /// - Parameter icon: String
    init(icon: String){
        super.init(nibName: nil, bundle: nil)
        imageView.image = UIImage(named: icon)
        setupImageView()
        view.accessibilityIdentifier = "launchScreen"
    }
    //MARK:- set image view
    func setImageView(imageNumber: Int){
        
        imageView.image = UIImage(named: "\(imageNumber)")
        let transition = CATransition()
        transition.type = .fade
        transition.duration = 1
        transition.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        imageView.layer.add(transition, forKey: "")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK:- viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    }
    //MARK:- SetupImageView
    fileprivate func setupImageView(){
        view.addSubview(imageView)
        imageView.easy.layout(Edges(0))
    }
    
}
