//
//  LoginService.swift
//  ToDoList
//
//  Created by David E Bratton on 4/12/20.
//  Copyright © 2020 David E Bratton. All rights reserved.
//

import Foundation
import Firebase

struct LoginInfo {
    let email: String
    let password: String
}

struct LoginService {
    
    static let shared = LoginService()
    
    func logUserIn(info: LoginInfo, completion: ((Error?) -> Void)?) {
        Auth.auth().signIn(withEmail: info.email, password: info.password) { (result, error) in
            if let error = error {
                print("DEBUG: Failed to log user in with error: \(error.localizedDescription)")
                completion!(error)
                return
            } else {
                print("DEBUG: Login success: \(result?.user.uid ?? "")")
            }
        }
    }
}
