//
//  RegistrationViewModel.swift
//  ToDoList
//
//  Created by David E Bratton on 4/11/20.
//  Copyright © 2020 David E Bratton. All rights reserved.
//

import UIKit
import Firebase

struct RegistrationInfo {
    // id is recieved from registering user below
    let username: String
    let fullname: String
    let email: String
    let password: String
    let profileImgUrl: UIImage
}

struct RegistrationService {
    
    static let shared = RegistrationService()
    
    func createUser(info: RegistrationInfo, completion: ((Error?) -> Void)?) {
        // #1 REGISTER USER
        Auth.auth().createUser(withEmail: info.email, password: info.password) { (user, error) in
            if let error = error {
                print("DEBUG: Failed to register user with error: \(error.localizedDescription)")
                completion!(error)
                return
            } else {
                guard let newUser = user?.user else { return }
                
                // #2 UPLOAD PROFILE IMAGE
                guard let imageData = info.profileImgUrl.jpegData(compressionQuality: 0.3) else { return }
                let imageRef = FB.IMAGE_PATH.child("\(FB.IMAGE_FOLDER)\(newUser.uid).jpg")
                let metaData = StorageMetadata()
                metaData.contentType = FB.IMAGE_CONTENT_TYPE
                imageRef.putData(imageData, metadata: metaData) { (metaData, error) in
                    if let error = error {
                        print("DEBUG: Error uploading image with error: \(error.localizedDescription)")
                        completion!(error)
                        return
                    } else {
                        
                        // #3 DOWNLOAD THE PROFILE IMG URL STRING
                        imageRef.downloadURL { (url, error) in
                            if let error = error {
                                print("DEBUG: Error downloading img url with error: \(error.localizedDescription)")
                                completion!(error)
                            } else {
                                guard let profileImgUrl = url?.absoluteString else { return }
                                
                                // #4 CREATE USER DOCUMENT WITH INFO
                                var docRef: DocumentReference!
                                let user = User.init(id: newUser.uid, username: info.username, fullname: info.fullname, email: info.email, profileImgUrl: profileImgUrl)
                                docRef = FB.USER_COLLECTION_FULL_PATH.document(user.id)
                                let data = User.convertModelToDictionary(user: user)
                                docRef.setData(data, completion: completion)
                            }
                        }
                    }
                }
            }
        }
    }
}
