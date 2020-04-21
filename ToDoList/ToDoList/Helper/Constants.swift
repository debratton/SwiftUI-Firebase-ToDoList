//
//  Constants.swift
//  ToDoList
//
//  Created by David E Bratton on 4/11/20.
//  Copyright © 2020 David E Bratton. All rights reserved.
//

import Foundation
import Firebase

struct FB {
    // PROFILE IMAGES
//    static let PICS = Storage.storage()
//    static let PIC_PATH = "/profile_images/\(UUID().uuidString)"
    static let IMAGE_PATH = Storage.storage().reference()
    static let IMAGE_FOLDER = "/profile_images/"
    static let IMAGE_CONTENT_TYPE = "image/jpg"
    
    // USERS
    static let DB = Firestore.firestore()
    static let USER_COLLECTION = "users"
    static let USER_COLLECTION_FULL_PATH = Firestore.firestore().collection("users")
    static let USER_ID = "id"
    static let USER_USERNAME = "username"
    static let USER_FULLNAME = "fullname"
    static let USER_EMAIL = "email"
    static let USER_PROFILE_IMG_URL = "profileImageUrl"
}
