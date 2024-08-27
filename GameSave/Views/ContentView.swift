//
//  ContentView.swift
//  GameTracker
//
//  Created by Henry Wertz on 2/19/24.
//

import SwiftUI

struct ContentView: View {
    
    var body: some View {
            RootView()
//        ZStack {
//            VStack {
//                TabView(selection: $selectedTab) {
//                    if selectedTab == .house {
//                        BrowseView().environmentObject(Network())
//                    }
//                    if selectedTab == .magnifyingglass {
//                        SearchView().environmentObject(Network())
//                    }
//                    if selectedTab == .person {
//                        ProfileView().environmentObject(Network())
//                    }
//                }
//            }
//            VStack {
//                Spacer()
//                CustomTabBar(selectedTab: $selectedTab)
//            }
//            
//        }
        
//        TabView {
//            BrowseView().environmentObject(Network())
//                .tabItem {
//                    Label("", systemImage: "play")
//                }
//            SearchView().environmentObject(Network())
//                .tabItem {
//                    Image(systemName: "magnifyingglass")
//                    
//                }
//            ProfileView()
//                .tabItem {
//                    Image(systemName: "person")
//                }
//        }
    }
}

#Preview {
    ContentView()
}
