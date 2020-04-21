//
//  User.swift
//  ToDoList
//
//  Created by David E Bratton on 4/9/20.
//  Copyright © 2020 David E Bratton. All rights reserved.
//

import Foundation
import Firebase

class User {
    let id: String
    let username: String
    let fullname: String
    let email: String
    let profileImgUrl: String
    
    init(id: String, username: String, fullname: String, email: String, profileImgUrl: String) {
        self.id = id
        self.username = username
        self.fullname = fullname
        self.email = email
        self.profileImgUrl = profileImgUrl
    }
    
    init(data: [String : Any]) {
        id = data[FB.USER_ID] as? String ?? ""
        username = data[FB.USER_USERNAME] as? String ?? ""
        fullname = data[FB.USER_FULLNAME] as? String ?? ""
        email = data[FB.USER_EMAIL] as? String ?? ""
        profileImgUrl = data[FB.USER_PROFILE_IMG_URL] as? String ?? ""
    }
    
    static func convertModelToDictionary(user: User) -> [String : Any] {
        let data: [String : Any] = [
            FB.USER_ID : user.id,
            FB.USER_USERNAME : user.username,
            FB.USER_FULLNAME : user.fullname,
            FB.USER_EMAIL : user.email,
            FB.USER_PROFILE_IMG_URL : user.profileImgUrl
        ]
        
        return data
    }
}
