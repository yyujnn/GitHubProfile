//
//  RepositoryAPIManager.swift
//  GitHubProfile
//
//  Created by 정유진 on 2024/04/11.
//

import Foundation
import Alamofire

class RepositoryAPIManager {
    // MARK: - URL Session 사용해서 가져오기
    let url = "https://api.github.com/users/al45tair/repos"
    
    func fetchUserRepositories(for username: String, completion: @escaping (Result<[Repository], Error>) -> Void) {
        guard let url = URL(string: "\(self.url)") else {
            completion(.failure(NSError(domain: "URL 변환 실패", code: 401)))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error {
                completion(.failure(error))
                return
            }
            
            guard let data else {
                completion(.failure(NSError(domain: "Data가 없어요.", code: 402)))
                return
            }
            
            do {
                let repositories = try JSONDecoder().decode([Repository].self, from: data)
                completion(.success(repositories))
            } catch {
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
    
    // MARK: - Alamofire 사용해서 가져오기
    func fetchRepositories(for username: String, completion: @escaping (Result<[Repository], Error>) -> Void) {

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
