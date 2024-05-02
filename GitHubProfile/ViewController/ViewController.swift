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
    var isLoadingLast = false
    var profile: UserProfile?
   
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        configTableView()
        setUserProfileView(for: username)
        fetchRepository(for: username)
    }
    
    // MARK: - TableView 구성
    private func configTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.register(ProfileTableViewCell.self, forCellReuseIdentifier: ProfileTableViewCell.identifier)
        
        let nibName = UINib(nibName: "RepositoryTableViewCell",
                            bundle: nil)
        tableView.register(nibName, forCellReuseIdentifier: "RepositoryTableViewCell")
        
        // MARK: - Pull to Refresh
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshFire), for: .valueChanged)
        tableView.refreshControl = refreshControl
    }
    
    @objc func refreshFire() {
        fetchRepository(for: "al45tair")
    }
    
    // MARK: - LoadMore
    func loadMore() {
        if isLoadingLast == true {
            print("마지막 페이지까지 load")
            return
        }
        page += 1
        repositoryAPIManager.fetchUserRepositories(for: "al45tair", page: page) { [weak self] result in
            print("Load more api fired")
            guard let self = `self` else { return }
            switch result {
            case .success(let repositories):
                if repositories.isEmpty == true {
                    self.isLoadingLast = true
                    return
                }
                self.repositories = self.repositories + repositories
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }

    // MARK: - ProfileView 가져오기
    func setUserProfileView(for username: String) {
        profileAPIManager.fetchUserProfile(for: username) { [weak self] result in
            switch result {
            case .success(let userProfile):
                self?.profile = userProfile
                DispatchQueue.main.async {
                    
                }
            case .failure(let error):
                print(error)
            }
        }
    }

    
    // MARK: - Repository 가져오기
    func fetchRepository(for username: String) {
        isLoadingLast = false
        
        repositoryAPIManager.fetchUserRepositories(for: "al45tair", page: page) { [weak self] result in
            switch result {
            case .success(let repositories):
                self?.repositories = repositories
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self?.tableView.refreshControl?.endRefreshing()
                    self?.tableView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return repositories.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ProfileTableViewCell.identifier) as? ProfileTableViewCell else { return UITableViewCell() }
            
            if let profile {
                cell.setProfileData(profile)
            }
            
            return cell
            
        } else if indexPath.section == 1 {
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "RepositoryTableViewCell",  for: indexPath) as? RepositoryTableViewCell else { return UITableViewCell() }
            
            cell.setData(repositories[indexPath.row])
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 120
        } else {
            return 70
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == repositories.count - 1 {
            print("Load More")
            loadMore()
        }
    }
}

