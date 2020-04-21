//
//  ResetPasswordService.swift
//  ToDoList
//
//  Created by David E Bratton on 4/17/20.
//  Copyright © 2020 David E Bratton. All rights reserved.
//

import Foundation
import Firebase

struct ResetPasswordInfo {
    let email: String
}

struct ResetPasswordService {
    
    static let shared = ResetPasswordService()
    
    func resetPassword(info: ResetPasswordInfo, completion: @escaping(Bool, Error?) -> Void) {
        Auth.auth().sendPasswordReset(withEmail: info.email) { (error) in
            if let error = error {
                let reset = false
                print("\(error.localizedDescription)")
                completion(reset, error)
                return
            } else {
                let reset = true
                completion(reset, nil)
                return
            }
        }
    }
}
