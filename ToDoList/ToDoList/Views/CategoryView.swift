//
//  CategoryView.swift
//  ToDoList
//
//  Created by David E Bratton on 4/11/20.
//  Copyright © 2020 David E Bratton. All rights reserved.
//

import SwiftUI
import Firebase
import SDWebImageSwiftUI

struct CategoryView: View {
    
    @ObservedObject var userVM = UserViewModel()
    @State private var showUserProfileView = false
    @State private var showAddCategoryView = false
    
    var body: some View {
        NavigationView {
            VStack {
                Text(userVM.user?.email ?? "")

                Button(action: {
                    let fbAuth = Auth.auth()
                    do {
                        try fbAuth.signOut()
                    } catch {
                        print("Error signing out: \(error.localizedDescription)")
                    }
                }) {
                    Text("Sign Out")
                } // End Button
            } // End VStack
            .navigationBarTitle("ToDo List")
            .navigationBarItems(
                leading:
                NavigationLink(
                    destination: UserProfileView(passedUser: userVM),
                    isActive: $showUserProfileView
                ) {
                    Button(action: {
                        self.showUserProfileView.toggle()
                    }, label: {
                        WebImage(url: URL(string: userVM.user?.profileImgUrl ?? ""))
                            .renderingMode(.original) // This is needed otherwise img doesn't display with navlink
                            .resizable()
                            .placeholder {
                                Circle().foregroundColor(.gray)
                        }
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color.gray, style: StrokeStyle(lineWidth: 2)))
                        .frame(width: 40, height: 40)
                    })
                }
                
                , trailing:
                NavigationLink(
                    destination: AddCategoryView(),
                    isActive: $showAddCategoryView
                ) {
                    Button(action: {
                        self.showAddCategoryView.toggle()
                    }, label: {
                        Image(systemName: "square.and.pencil")
                            .font(Font.system(.largeTitle).bold())
                            .font(Font.system(.subheadline))
                            .foregroundColor(.gray)
                    })
            })
        } // End NavigationView
            .onAppear {
                //self.userVM.getCurrentUser()
        }
        .accentColor(.gray)
        .environment(\.colorScheme, .dark)
    }
}

struct CategoryView_Previews: PreviewProvider {
    static var previews: some View {
        CategoryView()
    }
}
