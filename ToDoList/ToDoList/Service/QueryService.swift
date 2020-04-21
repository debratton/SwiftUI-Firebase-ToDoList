//
//  QueryService.swift
//  ToDoList
//
//  Created by David E Bratton on 4/13/20.
//  Copyright © 2020 David E Bratton. All rights reserved.
//

import Foundation
import Firebase

extension Firestore {
    
    func queryUser(id: String) -> DocumentReference {
        return collection(FB.USER_COLLECTION).document(id)
    }
    
    func queryUsers(type: String, id: String) -> Query {
        switch type {
        case "AllUsers":
            return collection(FB.USER_COLLECTION)
        case "CurrentUser":
            return collection(FB.USER_COLLECTION).whereField(FB.USER_ID, isEqualTo: id)
        default:
            return collection("")
        }
    }
}
