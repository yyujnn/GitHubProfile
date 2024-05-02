//
//  ProfileTableViewCell.swift
//  GitHubProfile
//
//  Created by 정유진 on 2024/05/02.
//

import Foundation
import Kingfisher
import SnapKit

class ProfileTableViewCell: UITableViewCell {
    
    static let identifier = "ProfileTableViewCell"
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 12.0
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    let idLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.textColor = .black
        return label
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = .black
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setupConstraints() {
        
        addSubview(profileImageView)
        addSubview(idLabel)
        addSubview(nameLabel)
        
        profileImageView.snp.makeConstraints { make in
            make.width.equalTo(profileImageView.snp.height)
            make.leading.equalToSuperview().inset(10)
            make.top.equalToSuperview().inset(10)
            make.bottom.equalToSuperview().inset(10)
        }
        
        idLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(50)
            make.trailing.equalToSuperview().inset(10)
            make.leading.equalTo(profileImageView.snp.trailing).inset(-10)
        }

        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(idLabel.snp.top).inset(-20)
            make.trailing.equalToSuperview().inset(10)
            make.leading.equalTo(profileImageView.snp.trailing).inset(-10)
        }
        
    }
    
    func setProfileData(_ user: UserProfile) {
        if let profileImageUrl = URL(string: user.avatarUrl) {
            profileImageView.kf.setImage(with: profileImageUrl)
        }
        
        idLabel.text = user.login
        nameLabel.text = "\(user.name)"
        
        /*
        userLocation.text = user.location
        followersCount.text = "✨Followers: \(user.followers)"
        followingCount.text = "✨Following: \(user.following)"
         */
    }
}
