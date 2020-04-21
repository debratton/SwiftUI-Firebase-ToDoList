//
//  RegistrationView.swift
//  ToDoList
//
//  Created by David E Bratton on 4/10/20.
//  Copyright © 2020 David E Bratton. All rights reserved.
//

import SwiftUI
//import SDWebImageSwiftUI

struct RegistrationView: View {
    
    @Environment(\.presentationMode) var registrationViewMode
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
    
    var body: some View {
        LoadingView(isShowing: $showActivityIndicator) {
            VStack {
                ZStack {
                    Rectangle()
                        .foregroundColor(.gray)
                        .cornerRadius(20)
                    
                    VStack {
                        VStack {
                            // MARK: - ImagePicker
                            if self.image == nil {
                                Image("placeholder")
                                    .resizable()
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
                        
                        VStack {
                            // MARK: - FullName TextField
                            TextField("fullname...", text: self.$fullname)
                                .font(Font.system(size: 30, design: .default))
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .frame(width: UIScreen.main.bounds.width - 70)
                                .padding(.top, 10)
                            
                            // MARK: - Email TextField
                            TextField("email...", text: self.$email)
                                .font(Font.system(size: 30, design: .default))
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .frame(width: UIScreen.main.bounds.width - 70)
                                .padding(.top, 2)
                            
                            // MARK: - Username TextField
                            TextField("username...", text: self.$username)
                                .font(Font.system(size: 30, design: .default))
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .frame(width: UIScreen.main.bounds.width - 70)
                                .padding(.top, 2)
                            
                            // MARK: - Password TextField
                            SecureField("password...", text: self.$password)
                                .font(Font.system(size: 30, design: .default))
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .frame(width: UIScreen.main.bounds.width - 70)
                                .padding(.top, 2)
                                .padding(.bottom, 20)
                        } // End VStack
                        
                        VStack {
                            // MARK: - Register Button
                            Button(action: {
                                print("DEBUG: Register New User")
                                self.showActivityIndicator.toggle()
                                guard self.username != "", self.fullname != "", self.email != "", self.fbImage != nil else {
                                    self.showActivityIndicator.toggle()
                                    self.messageTitle = "Error!"
                                    self.messageBody = "All fields are required including profile pic!"
                                    self.showAlert.toggle()
                                    return
                                }
                                
                                guard let profileImage = self.fbImage else { return }
                                let registrationInfo = RegistrationInfo(username: self.username.lowercased(), fullname: self.fullname, email: self.email.lowercased(), password: self.password, profileImgUrl: profileImage)
                                
                                RegistrationService.shared.createUser(info: registrationInfo) { (error) in
                                    if let error = error {
                                        print("DEBUG: Error registering user with error: \(error.localizedDescription)")
                                        self.showActivityIndicator.toggle()
                                        self.messageTitle = "Error!"
                                        self.messageBody = "Registration problem: \(error.localizedDescription)"
                                        self.showAlert.toggle()
                                    } else {
                                        print("DEBUG: Success")
                                        self.showActivityIndicator.toggle()
                                    }
                                }
                                
                            }) {
                                Text("Register")
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
                            .padding(.bottom, 30)
                        
                        HStack {
                            // MARK: - Already Have Account Button
                            Text("Already have an account?")
                            
                            Button(action: {
                                print("DEBUG: Move to Login Screen")
                                self.registrationViewMode.wrappedValue.dismiss()
                            }) {
                                Text("Click Here")
                                    .foregroundColor(.orange)
                            }
                        } // End HStack
                        
                        // Move items in VStack to top
                        Spacer()
                        
                    } // End VStack
                } // End ZStack
                    .frame(width: UIScreen.main.bounds.width - 50, height: 500)
                
                // Move everything to top
                Spacer()
                
            } // End VStack
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                .alert(isPresented: self.$showAlert) {
                    Alert(title: Text(self.messageTitle), message: Text(self.messageBody), dismissButton: .default(Text("Close")))
            } // End Alert
                .sheet(isPresented: self.$showImagePicker) {
                    ProfileImagePickerView(showImagePicker: self.$showImagePicker, image: self.$image, fbImage: self.$fbImage)
            }
            .navigationBarTitle("Registration")
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading:
                Button(action: {
                    self.registrationViewMode.wrappedValue.dismiss()
                }) {
                    HStack {
                        Image(systemName: "arrow.left.circle")
                            .font(Font.system(.title).bold())
                            .foregroundColor(.gray)
                        Text("Back")
                            .font(Font.system(.title).bold())
                            .foregroundColor(.gray)
                    } // End HStack
            })
        } // End Activity Indicator View
    } // End BodyView
}

struct RegistrationView_Previews: PreviewProvider {
    static var previews: some View {
        RegistrationView()
    }
}
