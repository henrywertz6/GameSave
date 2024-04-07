//
//  RootView.swift
//  GameTracker
//
//  Created by Henry Wertz on 2/27/24.
//

import SwiftUI

struct RootView: View {
    @State private var showSignInView: Bool = false
    @StateObject var userEnvironment = UserEnvironment()
    
    var body: some View {
        TabView {
            NavigationStack {
                BrowseView()
                
            }
            .tabItem { Label("Browse", systemImage: "arcade.stick.console") }
            SearchView()
                .tabItem { Label("Search", systemImage: "magnifyingglass")}
            MyListsView()
            .tabItem { Label("Lists", systemImage: "list.bullet")}
            SocialView()
                .tabItem{ Label("Social", systemImage: "bolt")}
            NavigationStack {
                ProfileView(showSignInView: $showSignInView)
                    .toolbar {
                        ToolbarItem(placement: .topBarTrailing) {
                            NavigationLink {
                                SettingsView(showSignInView: $showSignInView)
                            } label: {
                                Image(systemName: "gear")
                                    .font(.headline)
                            }
                            
                        }
                    }
                
            }
            .tabItem { Label("Profile", systemImage: "person") }
        }
        .onAppear {
            let authUser = try? AuthenticationManager.shared.getAuthenticatedUser()
            userEnvironment.user = authUser
            
            self.showSignInView = authUser == nil
        }
        .task {
            if let user = userEnvironment.user {
                await userEnvironment.createSet()
                await userEnvironment.createReviewSet()
            }
        }
        .fullScreenCover(isPresented: $showSignInView, content: {
            NavigationStack {
                AuthenticationView(showSignInView: $showSignInView)
            }
        })
        .environmentObject(userEnvironment)
        
    }
}

#Preview {
    RootView()
}
