//
//  ViewController.swift
//  GitHubProfile
//
//  Created by 정유진 on 2024/04/10.
//

import UIKit
import Alamofire
import Kingfisher

class ViewController: UIViewController {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var userId: UILabel!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userLocation: UILabel!
    @IBOutlet weak var followersCount: UILabel!
    @IBOutlet weak var followingCount: UILabel!
    
    @IBOutlet weak var repositorytableView: UITableView!
    
    var repositories: [Repository] = []
    let username = "yyujnn"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // sampleData
        repositories = [
            Repository(name: "Repository 1", language: "Swift"),
            Repository(name: "Repository 2", language: "Java"),
            Repository(name: "Repository 3", language: "JavaScript")
        ]
        
        repositorytableView.dataSource = self
        repositorytableView.delegate = self
        registerXib()
        setUserProfileView(for: username)
        // Do any additional setup after loading the view.
    }
    
    // 셀 등록
    private func registerXib() {
        let nibName = UINib(nibName: "RepositoryTableViewCell",
                            bundle: nil)
        repositorytableView.register(nibName, forCellReuseIdentifier: "RepositoryTableViewCell")
    }
    
    // 프로필뷰 가져오기
    func setUserProfileView(for username: String) {
        let userProfile = ProfileAPIManager()
        userProfile.fetchUserProfile(for: username) { [weak self] result in
            switch result {
            case .success(let userProfile):
                DispatchQueue.main.async {
                    // 프로필 이미지 업데이트
                    if let profileImageUrl = URL(string: userProfile.avatarUrl) {
                        self?.profileImage.kf.setImage(with: profileImageUrl)
                    }
                    self?.userId.text = username
                    self?.userName.text = userProfile.name
                    self?.userLocation.text = userProfile.location
                    // 팔로워 수 업데이트
                    self?.followersCount.text = "✨Followers: \(userProfile.followers)"
                    // 팔로잉 수 업데이트
                    self?.followingCount.text = "✨Following: \(userProfile.following)"
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    
}
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return repositories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RepositoryTableViewCell",  for: indexPath) as! RepositoryTableViewCell
        
        cell.setData(repositories[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}

