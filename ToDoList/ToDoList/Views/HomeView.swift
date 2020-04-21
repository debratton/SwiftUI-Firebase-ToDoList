//
//  HomeView.swift
//  ToDoList
//
//  Created by David E Bratton on 4/12/20.
//  Copyright © 2020 David E Bratton. All rights reserved.
//

import SwiftUI

struct HomeView: View {
    
    @EnvironmentObject var session: SessionStore
    
    func getUser() {
        session.listen()
    }
    
    var body: some View {
        Group {
            if session.session != nil {
                CategoryView()
            } else {
                LoginView()
            }
        } // End Group
            .onAppear {
                self.getUser()
        }
    } // End BodyView
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
