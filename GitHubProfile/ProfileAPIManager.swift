//
//  ProfileAPIManager.swift
//  GitHubProfile
//
//  Created by 정유진 on 2024/04/11.
//

import Foundation
import Alamofire

class ProfileAPIManager {
    func fetchUserProfile(for username: String, completion: @escaping (Result<UserProfile, Error>) -> Void) {
        let urlString = "https://api.github.com/users/\(username)"
        AF.request(urlString).responseDecodable(of: UserProfile.self) { response in
            switch response.result {
            case .success(let userProfile):
                completion(.success(userProfile))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

