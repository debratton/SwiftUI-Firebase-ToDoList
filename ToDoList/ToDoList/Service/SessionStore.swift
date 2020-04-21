//
//  AuthService.swift
//  ToDoList
//
//  Created by David E Bratton on 4/12/20.
//  Copyright © 2020 David E Bratton. All rights reserved.
//

import SwiftUI
import Firebase
import Combine

class SessionStore: ObservableObject {
    
    @Published var session = Auth.auth().currentUser
    var handle: AuthStateDidChangeListenerHandle?
    
    func listen() {
        handle = Auth.auth().addStateDidChangeListener { (auth, user) in
            if let user = user {
                print("INFO SHOULD BE DISPLAYED")
                print("User ID: \(user.uid)")
                print("User Email: \(user.email ?? "")")
                self.session = user
            } else {
                print("NO INFO SHOULD BE DISPLAYED")
                print("User ID: \(user?.uid ?? "")")
                print("User Email: \(user?.email ?? "")")
                self.session = nil
            }
        }
    }
}
