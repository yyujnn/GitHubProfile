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
    let profileAPIManager = ProfileAPIManager()
    let repositoryAPIManager = RepositoryAPIManager()
    
    let username = "yyujnn"
    var repositories: [Repository] = []
    var page = 1
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var userId: UILabel!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userLocation: UILabel!
    @IBOutlet weak var followersCount: UILabel!
    @IBOutlet weak var followingCount: UILabel!
    
    @IBOutlet weak var repositorytableView: UITableView!

    
    override func viewDidLoad() {
        super.viewDidLoad()

        configTableView()
        setUserProfileView(for: username)
        fetchRepository(for: username)
    }
    
    // MARK: - TableView 구성
    private func configTableView() {
        repositorytableView.dataSource = self
        repositorytableView.delegate = self
        
        let nibName = UINib(nibName: "RepositoryTableViewCell",
                            bundle: nil)
        repositorytableView.register(nibName, forCellReuseIdentifier: "RepositoryTableViewCell")
    }
    
    // MARK: - ProfileView 가져오기
    func setUserProfileView(for username: String) {
        profileAPIManager.fetchUserProfile(for: username) { [weak self] result in
            switch result {
            case .success(let userProfile):
                DispatchQueue.main.async {
                    self?.setProfileData(userProfile)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func setProfileData(_ userProfile: UserProfile) {
        if let profileImageUrl = URL(string: userProfile.avatarUrl) {
            self.profileImage.kf.setImage(with: profileImageUrl)
        }
        self.userId.text = userProfile.login
        self.userName.text = userProfile.name
        self.userLocation.text = userProfile.location
        self.followersCount.text = "✨Followers: \(userProfile.followers)"
        self.followingCount.text = "✨Following: \(userProfile.following)"
    }
    
    // MARK: - Repository 가져오기
    func fetchRepository(for username: String) {
        repositoryAPIManager.fetchUserRepositories(for: "al45tair", page: page) { [weak self] result in
            switch result {
            case .success(let repositories):
                self?.repositories = repositories
                DispatchQueue.main.async {
                    self?.repositorytableView.reloadData()
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
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "RepositoryTableViewCell",  for: indexPath) as? RepositoryTableViewCell else { return UITableViewCell() }
        
        cell.setData(repositories[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}

