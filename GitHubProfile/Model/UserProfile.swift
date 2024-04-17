//
//  UserProfile.swift
//  
//
//  Created by 정유진 on 2024/04/11.
//

import UIKit

struct UserProfile: Decodable {
    var login: String
    var avatarUrl: String
    let name: String
    let location: String?
    var followers: Int
    var following: Int
    
    // JSON 데이터를 모델 객체로 변환할 때 사용되는 CodingKeys
    private enum CodingKeys: String, CodingKey {
        case login
        case avatarUrl = "avatar_url"
        case name
        case location
        case followers
        case following
    }
}
