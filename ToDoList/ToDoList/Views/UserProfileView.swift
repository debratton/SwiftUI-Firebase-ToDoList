//
//  UserProfileView.swift
//  ToDoList
//
//  Created by David E Bratton on 4/13/20.
//  Copyright © 2020 David E Bratton. All rights reserved.
//

import SwiftUI
import SDWebImageSwiftUI
import Firebase

struct UserProfileView: View {
    
    var passedUser: UserViewModel
    @Environment(\.presentationMode) var profileViewMode
    @State private var showImagePicker = false
    @State private var image: Image? = nil
    @State private var fbImage: UIImage? = nil
    @State private var fullname = ""
    @State private var email = ""
    @State private var username = ""
    @State private var password = ""
    @State private var showAlert = false
    @State private var messageTitle = ""
    @State private var messageBody = ""
    @State private var showActivityIndicator = false
    @State private var updateProfileImg = false
    @State private var updateEmail = false
    @State private var greyBackgroundHeight: CGFloat = 450
    
    var body: some View {
        LoadingView(isShowing: $showActivityIndicator) {
            VStack {
                ZStack {
                    Rectangle()
                        .foregroundColor(.gray)
                        .cornerRadius(20)
                    
                    VStack {
                        if !self.updateEmail {
                            VStack {
                                // MARK: - ImagePicker
                                if self.image == nil {
                                    WebImage(url: URL(string: self.passedUser.user?.profileImgUrl ?? ""))
                                        .renderingMode(.original) // This is needed otherwise img doesn't display with navlink
                                        .resizable()
                                        .placeholder {
                                            Circle().foregroundColor(.gray)
                                    }
                                    .clipShape(Circle())
                                    .overlay(Circle().stroke(Color.black, style: StrokeStyle(lineWidth: 3)))
                                    .frame(width: 100, height: 100)
                                    .onTapGesture {
                                        self.showImagePicker.toggle()
                                    }
                                } else {
                                    self.image?
                                        .resizable()
                                        .clipShape(Circle())
                                        .overlay(Circle().stroke(Color.black, style: StrokeStyle(lineWidth: 3)))
                                        .frame(width: 100, height: 100)
                                        .onTapGesture {
                                            self.showImagePicker.toggle()
                                    }
                                }
                                
                            } // End VStack
                                .padding(.top, 20)
                            
                            HStack {
                                // MARK: - ChangeEmail
                                // I had to place in struct below since everything is inside Activity Indicator View
                                ChangeEmail(updateEmail: self.$updateEmail, showAlert: self.$showAlert, messageTitle: self.$messageTitle, messageBody: self.$messageBody, greyBackgroundHeight: self.$greyBackgroundHeight)
                            }
                            .frame(width: UIScreen.main.bounds.width - 70)
                            
                            VStack {
                                // MARK: - FullName TextField
                                TextField("fullname...", text: self.$fullname)
                                    .font(Font.system(size: 30, design: .default))
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .frame(width: UIScreen.main.bounds.width - 70)
                                    .padding(.top, 10)
                                    .onAppear {
                                        self.fullname = self.passedUser.user?.fullname ?? ""
                                }
                                
                                // MARK: - Email TextField
                                TextField("email...", text: self.$email)
                                    .font(Font.system(size: 30, design: .default))
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .frame(width: UIScreen.main.bounds.width - 70)
                                    .padding(.top, 2)
                                    .onAppear {
                                        self.email = self.passedUser.user?.email ?? ""
                                }
                                
                                // MARK: - Username TextField
                                TextField("username...", text: self.$username)
                                    .font(Font.system(size: 30, design: .default))
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .frame(width: UIScreen.main.bounds.width - 70)
                                    .padding(.top, 2)
                                    .onAppear {
                                        self.username = self.passedUser.user?.username ?? ""
                                }
                                
                            } // End VStack
                        } else {
                            VStack {
                                HStack {
                                    // MARK: - ChangeEmail
                                    // I had to place in struct below since everything is inside Activity Indicator View
                                    ChangeEmail(updateEmail: self.$updateEmail, showAlert: self.$showAlert, messageTitle: self.$messageTitle, messageBody: self.$messageBody, greyBackgroundHeight: self.$greyBackgroundHeight)
                                }
                                .frame(width: UIScreen.main.bounds.width - 70)
                                .padding(.top, 20)
                                
                                // MARK: - Email TextField
                                TextField("email...", text: self.$email)
                                    .font(Font.system(size: 30, design: .default))
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .frame(width: UIScreen.main.bounds.width - 70)
                                    .padding(.top, 10)
                                    .onAppear {
                                        self.email = self.passedUser.user?.email ?? ""
                                }
                            } // End VStack
                        } // End IF THEN ELSE FOR CHANGE EMAIL
                        
                        VStack {
                            // MARK: - Register Button
                            Button(action: {
                                print("DEBUG: Update User Profile")
                                self.showActivityIndicator.toggle()
                                guard self.username != "", self.fullname != "", self.email != "" else {
                                    self.showActivityIndicator.toggle()
                                    self.messageTitle = "Error!"
                                    self.messageBody = "All fields are required!"
                                    self.showAlert.toggle()
                                    return
                                }
                                
                                if self.updateEmail {
                                    print("DEBUG: UPDATE email")
                                    
                                    let emailUpdateOnly = UserEmailUpdate(id: self.passedUser.user!.id, email: self.email)
                                    UserViewModel.shared.updateEmail(info: emailUpdateOnly) { (error) in
                                        if let error = error {
                                            print("DEBUG: Error changing email \(error.localizedDescription)")
                                            self.showActivityIndicator.toggle()
                                            self.messageTitle = "Error!"
                                            self.messageBody = error.localizedDescription
                                            self.showAlert.toggle()
                                            return
                                        }
                                    }
                                } else {
                                    print("DEBUG: DONT UPDATE email")
                                    if self.image != nil {
                                        let userInfo = UserInfoWithImage(id: self.passedUser.user!.id, username: self.username, fullname: self.fullname, profileImgUrl: self.passedUser.user!.profileImgUrl, newprofileImg: self.fbImage)
                                        UserViewModel.shared.updateUserInfoWithImage(info: userInfo) { (result, error) in
                                            if result {
                                                self.showActivityIndicator.toggle()
                                                self.messageTitle = "Success!"
                                                self.messageBody = "Profile updated successfully!"
                                                self.showAlert.toggle()
                                            } else {
                                                if let error = error {
                                                    print("DEBUG: Error updating profile info with error \(error.localizedDescription)")
                                                    self.showActivityIndicator.toggle()
                                                    self.messageTitle = "Error!"
                                                    self.messageBody = error.localizedDescription
                                                    self.showAlert.toggle()
                                                }
                                                
                                            }
                                        }
                                    } else {
                                        let userInfo = UserInfoNoImage(id: self.passedUser.user!.id, username: self.username, fullname: self.fullname)
                                        UserViewModel.shared.updateUserInfoNoImage(info: userInfo) { (result, error) in
                                            if result {
                                                self.showActivityIndicator.toggle()
                                                self.messageTitle = "Success!"
                                                self.messageBody = "Profile updated successfully!"
                                                self.showAlert.toggle()
                                            } else {
                                                if let error = error {
                                                    print("DEBUG: Error updating profile info with error \(error.localizedDescription)")
                                                    self.showActivityIndicator.toggle()
                                                    self.messageTitle = "Error!"
                                                    self.messageBody = error.localizedDescription
                                                    self.showAlert.toggle()
                                                }
                                            }
                                        }
                                    }
                                    
                                }
                            }) {
                                Text("Update Info")
                                    .fontWeight(.bold)
                                    .font(.title)
                                    .frame(minWidth: 0, maxWidth: .infinity)
                                    .foregroundColor(.white)
                                    .background(Color.black)
                                    .padding(5)
                                    .background(Color.black)
                                    .foregroundColor(.white)
                                    .padding(10)
                                    .border(Color.black, width: 5)
                            } // End Button
                        } // End VStack
                            .frame(width: UIScreen.main.bounds.width - 150)
                            .padding(.top, 20)
                        
                        // Move items in VStack to top
                        Spacer()
                        
                    } // End VStack
                } // End ZStack
                    //.frame(width: UIScreen.main.bounds.width - 50, height: 460)
                    .frame(width: UIScreen.main.bounds.width - 50, height: self.greyBackgroundHeight)
                
                // Move everything to top
                Spacer()
                
            } // End VStack
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                
                .navigationBarTitle("User Profile")
                .navigationBarBackButtonHidden(true)
                .navigationBarItems(leading:
                    Button(action: {
                        self.profileViewMode.wrappedValue.dismiss()
                    }) {
                        HStack {
                            Image(systemName: "arrow.left.circle")
                                .font(Font.system(.title).bold())
                                .foregroundColor(.gray)
                            Text("Back")
                                .font(Font.system(.title).bold())
                                .foregroundColor(.gray)
                        } // End HStack
                }, trailing:
                    Button(action: {
                        let currentUser = Auth.auth()
                        do {
                            try currentUser.signOut()
                        } catch {
                            print("Error signing out: \(error.localizedDescription)")
                        }
                    }) {
                        Image(systemName: "clear")
                            .font(Font.system(.title).bold())
                            .foregroundColor(.gray)
                    }
            )
        } // End Activity Indicator View
            
            // Both Alert and ImagePicker have to be outside of Activity Indicator View or they do not display
            .alert(isPresented: self.$showAlert) {
                Alert(title: Text(self.messageTitle), message: Text(self.messageBody), dismissButton: .default(Text("Close")))
        } // End Alert
            .sheet(isPresented: self.$showImagePicker) {
                ProfileImagePickerView(showImagePicker: self.$showImagePicker, image: self.$image, fbImage: self.$fbImage)
        } // End Image Picker
    } // End BodyView
}

struct ChangeEmail: View {
    
    @Binding var updateEmail: Bool
    @Binding var showAlert: Bool
    @Binding var messageTitle: String
    @Binding var messageBody: String
    @Binding var greyBackgroundHeight: CGFloat
    
    var body: some View {
        Toggle(isOn: self.$updateEmail) {
            if !self.updateEmail {
                Text("Update Email: ")
                    +
                    Text("No")
                        .fontWeight(.bold)
            } else {
                Text("Update Email: ")
                    +
                    Text("Yes")
                        .fontWeight(.bold)
            }
        }.onTapGesture {
            if !self.updateEmail {
                self.greyBackgroundHeight = 230
                self.messageTitle = "Alert!"
                self.messageBody = "⦿ If you are changing your email, this operation must be done seperately since it is tied to your login. \n\n⦿ If you have not logged in recently, you may recieve an error indicating to logout and back in before performing the operation.\n\n⦿ Once you hit the Update Info button, we will attempt to reset your email and you will be logged out of the system and will re-authenticate with your new email and password."
                self.showAlert.toggle()
            } else {
                self.greyBackgroundHeight = 450
            }
        }
    }
}

struct UserProfileView_Previews: PreviewProvider {
    static var previews: some View {
        UserProfileView(passedUser: UserViewModel())
    }
}
