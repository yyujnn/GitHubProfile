//
//  RepositoryAPIManager.swift
//  GitHubProfile
//
//  Created by 정유진 on 2024/04/11.
//

import Foundation
import Alamofire

class RepositoryAPIManager {
    
    func fetchRepositories(for username: String, completion: @escaping (Result<[Repository], Error>) -> Void) {
        
        let url = "https://api.github.com/users/\(username)/repos"
        
        AF.request(url).responseDecodable(of: [Repository].self) { response in
            switch response.result {
            case .success(let repositories):
                completion(.success(repositories))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
