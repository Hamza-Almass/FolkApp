//
//  PostTableViewCell.swift
//  FolkApp
//
//  Created by Hamza Almass on 8/30/21.
//

import EasyPeasy
import UIKit

class PostTableViewCell: UITableViewCell {
    
    private let iconImageView:UIImageView = {
        let imageView = UIImageView()
        imageView.image = nil
        imageView.backgroundColor = .yellow
        imageView.layer.cornerRadius = 20
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let userNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Username"
        label.textColor = UIColor(named: kTEXTCOLOR)
        return label
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Title label"
        label.textColor = UIColor(named: kTITLECOLOR)
        label.numberOfLines = 0
        return label
    }()
    
    private let bodyLabel: UILabel = {
        let label = UILabel()
        label.text = "body label"
        label.textColor = UIColor(named: kTEXTCOLOR)?.withAlphaComponent(0.6)
        label.numberOfLines = 0
        return label
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = UIColor(named: kBGCOLOR)
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 8
        contentView.clipsToBounds = true
        setupUI()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: .init(top: 5, left: 5, bottom: 5, right: 5))
    }
    
    func configureCell(postVM: PostViewModel){
        postVM.postUserName.bind(to: userNameLabel.rx.text).disposed(by: postVM.disposeBag)
        postVM.postTitle.bind(to: titleLabel.rx.text).disposed(by: postVM.disposeBag)
        postVM.postBody.bind(to: bodyLabel.rx.text).disposed(by: postVM.disposeBag)
    }
    
    private func setupUI(){
        contentView.addSubview(iconImageView)
        iconImageView.easy.layout(Leading(16) , Width(40) , Height(40) ,Top(16))
        contentView.addSubview(userNameLabel)
        userNameLabel.easy.layout(CenterY(0).to(iconImageView,.centerY) , Leading(16).to(iconImageView,.trailing),Height(30))
        contentView.addSubview(titleLabel)
        titleLabel.easy.layout(Top(10).to(iconImageView,.bottom),Leading(16),Trailing(16))
        contentView.addSubview(bodyLabel)
        bodyLabel.easy.layout(Top(20).to(titleLabel,.bottom),Trailing(16),Bottom(16),Leading(16))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
