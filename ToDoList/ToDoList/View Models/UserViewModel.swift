//
//  UserViewModel.swift
//  ToDoList
//
//  Created by David E Bratton on 4/13/20.
//  Copyright © 2020 David E Bratton. All rights reserved.
//

import Foundation
import Firebase

struct UserInfoWithImage {
    let id: String
    let username: String
    let fullname: String
    let profileImgUrl: String
    let newprofileImg: UIImage?
    
    static func convertUserInfoToDictionary(user: UserInfoWithImage) -> [String : Any] {
        let data: [String : Any] = [
            FB.USER_ID : user.id,
            FB.USER_USERNAME : user.username,
            FB.USER_FULLNAME : user.fullname,
            FB.USER_PROFILE_IMG_URL : user.profileImgUrl
        ]
        
        return data
    }
}

struct UserInfoNoImage {
    let id: String
    let username: String
    let fullname: String
    
    static func convertUserInfoToDictionary(user: UserInfoNoImage) -> [String : Any] {
        let data: [String : Any] = [
            FB.USER_ID : user.id,
            FB.USER_USERNAME : user.username,
            FB.USER_FULLNAME : user.fullname
        ]
        
        return data
    }
}

struct UserEmailUpdate {
    let id: String
    let email: String
    
    static func convertEmailUpdateToDictionary(user: UserEmailUpdate) -> [String : Any] {
        let data: [String : Any] = [
            FB.USER_ID : user.id,
            FB.USER_EMAIL : user.email
        ]
        
        return data
    }
}

class UserViewModel: ObservableObject {
    
    static let shared = UserViewModel()
    var userListener: ListenerRegistration!
    
    @Published var user: User?
    
    init() {
        getCurrentUser()
    }
    
    // DELETE AFTER TESTING
    func oldGetCurrentUser() {
        if let currentUser = Auth.auth().currentUser {
            FB.DB.queryUser(id: currentUser.uid)
                .getDocument { (snap, error) in
                    if let error = error {
                        print("DEBUG: Error fetching user with error: \(error.localizedDescription)")
                    } else {
                        guard let data = snap?.data() else { return }
                        let userRef = User(data: data)
                        self.user = userRef
                    }
            }
        }
    }
    
    func getCurrentUser() {
        if let currentUser = Auth.auth().currentUser {
            userListener = FB.DB.queryUser(id: currentUser.uid).addSnapshotListener({ (snapshot, error) in
                if let error = error {
                    print("DEBUG: Error fetching current user with error: \(error.localizedDescription)")
                    return
                } else {
                    guard let data = snapshot?.data() else { return }
                    let userRef = User(data: data)
                    self.user = userRef
                }
            })
        }
    }
    
    func updateEmail(info: UserEmailUpdate, completion: @escaping (Error?) -> Void) {
        var docRef: DocumentReference!
        let user = UserEmailUpdate(id: info.id, email: info.email)
        docRef = FB.USER_COLLECTION_FULL_PATH.document(user.id)
        let data = UserEmailUpdate.convertEmailUpdateToDictionary(user: user)
        docRef.setData(data, merge: true) { (error) in
            if let error = error {
                print("DEBUG: Error updating user document \(error.localizedDescription)")
                completion(error)
                return
            } else {
                let currentUser = Auth.auth().currentUser
                currentUser?.updateEmail(to: info.email, completion: { (error) in
                    if let error = error {
                        print("DEBUG: Error updating email on authentication doc \(error.localizedDescription)")
                        completion(error)
                        return
                    } else {
                     let userSignOut = Auth.auth()
                     do {
                         try userSignOut.signOut()
                     } catch {
                         print("Error signing out: \(error.localizedDescription)")
                     }
                 }
                 
                })
            }
        }
    }
    
    func updateUserInfoWithImage(info: UserInfoWithImage, completion: @escaping (Bool, Error?) -> Void) {
        // #1 UPLOAD IMAGE
        guard let imageData = info.newprofileImg!.jpegData(compressionQuality: 0.3) else { return }
        let imageRef = FB.IMAGE_PATH.child("\(FB.IMAGE_FOLDER)\(info.id).jpg")
        let metaData = StorageMetadata()
        metaData.contentType = FB.IMAGE_CONTENT_TYPE
        imageRef.putData(imageData, metadata: metaData) { (metaData, error) in
            if let error = error {
                print("DEBUG: Error uploading image with error: \(error.localizedDescription)")
                completion(false, error)
                return
            } else {
                // #2 DOWNLOAD IMAGE URL STRING
                imageRef.downloadURL { (url, error) in
                    if let error = error {
                        print("DEBUG: Error downloading url string with error: \(error.localizedDescription)")
                        completion(false, error)
                        return
                    } else {
                        guard let profileImgUrl = url?.absoluteString else { return }
                        
                        // #3 UPDATE USER DOCUMENT
                        var docRef: DocumentReference!
                        let user = UserInfoWithImage(id: info.id, username: info.username, fullname: info.fullname, profileImgUrl: profileImgUrl, newprofileImg: nil)
                        docRef = FB.USER_COLLECTION_FULL_PATH.document(info.id)
                        let data = UserInfoWithImage.convertUserInfoToDictionary(user: user)
                        docRef.setData(data, merge: true) { (error) in
                            if let error = error {
                                print("DEBUG: Error updating user profile with error: \(error.localizedDescription)")
                                let result = false
                                completion(result, error)
                                return
                            } else {
                                //self.getCurrentUser()
                                let result = true
                                completion(result, nil)
                            }
                        }
                    }
                }
            }
        }
    }
    
    func updateUserInfoNoImage(info: UserInfoNoImage, completion: @escaping (Bool, Error?) -> Void) {
        var docRef: DocumentReference!
        let user = UserInfoNoImage(id: info.id, username: info.username, fullname: info.fullname)
        docRef = FB.USER_COLLECTION_FULL_PATH.document(info.id)
        let data = UserInfoNoImage.convertUserInfoToDictionary(user: user)
        docRef.setData(data, merge: true) { (error) in
            if let error = error {
                print("DEBUG: Error updating user profile with error: \(error.localizedDescription)")
                let result = false
                completion(result, error)
                return
            } else {
                let result = true
                completion(result, nil)
            }
        }
    }
}
