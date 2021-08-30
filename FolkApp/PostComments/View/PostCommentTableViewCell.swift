//
//  PostCommentTableViewCell.swift
//  FolkApp
//
//  Created by Hamza Almass on 8/30/21.
//

import UIKit
import EasyPeasy
import RxSwift
import RxCocoa
import PaddingLabel

class PostCommentTableViewCell: UITableViewCell {
    
    private let disposeBag = DisposeBag()
    
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 20
        imageView.clipsToBounds = true
        imageView.image = UIImage(named: "lines")?.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = .lightGray
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor.lightGray.cgColor
        imageView.backgroundColor = .clear
        return imageView
    }()
    
    private let emailLabel: UILabel = {
        let label = UILabel()
        label.text = "This is a email"
        label.textColor = UIColor(named: kTITLECOLOR)
        return label
    }()
    
    private let bodyLabel: PaddingLabel = {
        let label = PaddingLabel()
        label.leftInset = 6
        label.rightInset = 6
        label.bottomInset = 6
        label.topInset = 6
        label.text = "This is a body"
        label.textColor = UIColor(named: kTEXTCOLOR)
        label.numberOfLines = 0
        label.backgroundColor = UIColor.systemGray6
        label.layer.cornerRadius = 8
        label.clipsToBounds = true
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = UIColor(named: kBGCELLCOLOR)
        setupUI()
    }
    
    private func setupUI(){
        contentView.addSubview(iconImageView)
        iconImageView.easy.layout(Top(10),Leading(16),Width(40),Height(40))
        contentView.addSubview(emailLabel)
        emailLabel.easy.layout(CenterY(0).to(iconImageView,.centerY),Height(30),Leading(16).to(iconImageView,.trailing))
        contentView.addSubview(bodyLabel)
        bodyLabel.easy.layout(Top(10).to(iconImageView,.bottom),Leading(16),Trailing(16),Bottom(10))
    }
    
    func configureCell(postCommentVM: PostCommentViewModel){
        postCommentVM.commentEmail.bind(to: emailLabel.rx.text).disposed(by: disposeBag)
        postCommentVM.commentBody.bind(to: bodyLabel.rx.text).disposed(by: disposeBag)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
