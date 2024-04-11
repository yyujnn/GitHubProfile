//
//  Repository.swift
//  GitHubProfile
//
//  Created by 정유진 on 2024/04/11.
//

import Foundation

struct Repository {
    let name: String
    let language: String
    
    init(name: String, language: String) {
        self.name = name
        self.language = language
    }
}

