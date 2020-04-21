//
//  ResetPasswordView.swift
//  ToDoList
//
//  Created by David E Bratton on 4/16/20.
//  Copyright © 2020 David E Bratton. All rights reserved.
//

import SwiftUI

struct ResetPasswordView: View {
    
    @Environment(\.presentationMode) var resetPasswordViewMode
    @State private var email = ""
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
                        TextField("email...", text: self.$email)
                            .font(Font.system(size: 30, design: .default))
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .frame(width: UIScreen.main.bounds.width - 70)
                            .padding(.top, 20)
                            .padding(.bottom, 10)
                        
                        VStack {
                            Button(action: {
                                self.showActivityIndicator.toggle()
                                guard self.email != "" else {
                                    self.showActivityIndicator.toggle()
                                    self.messageTitle = "Error!"
                                    self.messageBody = "You must enter a valid email!"
                                    self.showAlert.toggle()
                                    return
                                }
                                
                                let credentials = ResetPasswordInfo(email: self.email)
                                ResetPasswordService.shared.resetPassword(info: credentials) { (result, error) in
                                    if result {
                                        print("DEBUG: Success sending password reset!")
                                        self.showActivityIndicator.toggle()
                                        self.email = ""
                                        self.messageTitle = "Success!"
                                        self.messageBody = "Please check your email (\(self.email) and follow password reset directions."
                                        self.showAlert.toggle()
                                    } else {
                                        print("DEBUG: Error sending password reset with error \(error!.localizedDescription)")
                                        self.showActivityIndicator.toggle()
                                        self.messageTitle = "Error!"
                                        self.messageBody = error!.localizedDescription
                                        self.showAlert.toggle()
                                    }
                                }
                            }) {
                                Text("Reset")
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
                            }
                        } // End VStack
                            .frame(width: UIScreen.main.bounds.width - 150)
                        
                        // Move items in VStack to top
                        Spacer()
                        
                    } // End VStack
                } // End ZStack
                    .frame(width: UIScreen.main.bounds.width - 50, height: 170)
                
                // Move Everything to top
                Spacer()
                
            } // End VStack
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                .alert(isPresented: self.$showAlert) {
                    Alert(title: Text(self.messageTitle), message: Text(self.messageBody), dismissButton: .default(Text("Close")))
            }
                
            .navigationBarTitle("Reset Password")
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading:
                Button(action: {
                    self.resetPasswordViewMode.wrappedValue.dismiss()
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

struct ResetPasswordView_Previews: PreviewProvider {
    static var previews: some View {
        ResetPasswordView()
    }
}
