//
//  ProfileAPIManager.swift
//  GitHubProfile
//
//  Created by 정유진 on 2024/04/11.
//

import Foundation
import Alamofire

class ProfileAPIManager {
    let url = "https://api.github.com/users/"
    
    func fetchUserProfile(for username: String, completion: @escaping (Result<UserProfile, Error>) -> Void) {
        let urlString = "\(self.url)\(username)"
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
