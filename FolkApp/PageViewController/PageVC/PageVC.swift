//
//  PageVC.swift
//  FolkApp
//
//  Created by Hamza Almass on 8/31/21.
//

import Lottie
import UIKit
import EasyPeasy

class PageVC: UIViewController {
    
    /**
     - Description: Custom init for prepare the page view controller
     - Parameter: icon: String , title: String , body: String
     */
    
    private var iconLottie: String = ""
    
    init(icon: String , title: String , body: String){
        self.iconLottie = icon
        super.init(nibName: nil, bundle: nil)
        iconImageView = createAnimationView(name: icon)
        titleLabel.text = title
        bodyLabel.text = body
        iconImageView.contentMode = .scaleAspectFit
        titleLabel.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        setupUI()
        
    }
    
    //MARK:- Property page view controller
    var iconImageView: AnimationView!
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont(name: "Arial", size: 18)
        label.textColor = UIColor(named: kTEXTCOLOR)
        label.numberOfLines = 0
        return label
    }()
    
    let bodyLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont(name: "Arial", size: 15)
        label.textColor = UIColor(named: kTEXTCOLOR)
        label.numberOfLines = 0
        return label
    }()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       
        iconImageView.play { (isPlay) in
            if isPlay == false {
                self.iconImageView.play()
            }
        }
    }
    
    fileprivate func setupUI(){
        
        view.addSubview(iconImageView)
        view.addSubview(titleLabel)
        view.addSubview(bodyLabel)
        
        iconImageView.easy.layout(Top(40),Leading(32),Trailing(32),Height(self.view.frame.height * 0.5))
        titleLabel.easy.layout(Top(15).to(iconImageView,.bottom),Height(35),CenterX(0))
        bodyLabel.easy.layout(Top(15).to(titleLabel,.bottom),Trailing(62),CenterX(0),Leading(62))

        
    }
    
}
