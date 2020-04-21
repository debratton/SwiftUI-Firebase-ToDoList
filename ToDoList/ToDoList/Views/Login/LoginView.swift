//
//  ContentView.swift
//  ToDoList
//
//  Created by David E Bratton on 4/9/20.
//  Copyright © 2020 David E Bratton. All rights reserved.
//

import SwiftUI
import Firebase

struct LoginView: View {
    
    @State private var email = ""
    @State private var password = ""
    @State private var showRegistation = false
    @State private var showResetPassword = false
    @State private var showAlert = false
    @State private var messageTitle = ""
    @State private var messageBody = ""
    @State private var showActivityIndicator = false
    
    var body: some View {
        LoadingView(isShowing: $showActivityIndicator) {
            NavigationView {
                VStack {
                    ZStack {
                        // MARK: - Gray Rectangle
                        Rectangle()
                            .foregroundColor(.gray)
                            .cornerRadius(20)
                        
                        VStack {
                            // MARK: - Email Text Field
                            TextField("email...", text: self.$email)
                                .font(Font.system(size: 30, design: .default))
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .frame(width: UIScreen.main.bounds.width - 70)
                                .padding(.top, 20)
                            
                            // MARK: - Password Text Field
                            SecureField("password...", text: self.$password)
                                .font(Font.system(size: 30, design: .default))
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .frame(width: UIScreen.main.bounds.width - 70)
                                .padding(.top, 2)
                                .padding(.bottom, 20)
                            
                            
                            VStack {
                                // MARK: - Login Button
                                Button(action: {
                                    self.showActivityIndicator.toggle()
                                    guard self.email != "", self.password != "" else {
                                        self.showActivityIndicator.toggle()
                                        self.messageTitle = "Error!"
                                        self.messageBody = "Both email and password are required!"
                                        self.showAlert.toggle()
                                        return
                                    }
                                    
                                    let credentials = LoginInfo(email: self.email, password: self.password)
                                    LoginService.shared.logUserIn(info: credentials) { (error) in
                                        if let error = error {
                                            self.showActivityIndicator.toggle()
                                            self.messageTitle = "Error!"
                                            self.messageBody = error.localizedDescription
                                            self.showAlert.toggle()
                                        } else {
                                            self.showActivityIndicator.toggle()
                                        }
                                    }
                                    
                                }) {
                                    Text("Login")
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
                            
                            VStack {
                                // MARK: Reset Password Button
                                NavigationLink(destination: ResetPasswordView(),
                                               isActive: self.$showResetPassword
                                ) {
                                    Button(action: {
                                        print("DEBUG: Reset Password")
                                        self.showResetPassword.toggle()
                                    }) {
                                        Text("Reset Password")
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
                                } // End NavigationLink
                            } // End VStack
                                .frame(width: UIScreen.main.bounds.width - 150)
                                .padding(.top, 10)
                            
                            HStack {
                                // MARK: Dont Have An Account
                                Text("Don't have an account?")
                                
                                NavigationLink(destination: RegistrationView(),
                                               isActive: self.$showRegistation
                                ) {
                                    Button(action: {
                                        print("DEBUG: Move to Registration Screen")
                                        self.showRegistation.toggle()
                                    }) {
                                        Text("Click Here")
                                            .foregroundColor(.orange)
                                    } // End Button
                                } // End NavigationLink
                            } // End HStack
                                .padding(.top, 30)
                            
                            
                            // Move items in VStack to top
                            Spacer()
                            
                        } // End VStack
                    } // End ZStack
                        .frame(width: UIScreen.main.bounds.width - 50, height: 350)
                    
                    // Move everything to top
                    Spacer()
                    
                } // End VStack
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                    .navigationBarTitle("Login")
            } // End NavigationView
                .alert(isPresented: self.$showAlert) {
                    Alert(title: Text(self.messageTitle), message: Text(self.messageBody), dismissButton: .default(Text("Close")))
            }
            
        } // End Activity Indicator View
    } // End BodyView
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
