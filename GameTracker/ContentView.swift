//
//  ContentView.swift
//  GameTracker
//
//  Created by Henry Wertz on 2/19/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            BrowseView()
                .tabItem {
                    Image(systemName: "play")
                }
            SearchView()
                .tabItem {
                    Image(systemName: "magnifyingglass")
                }
            ProfileView()
                .tabItem {
                    Image(systemName: "person")
                }
        }
    }
}

#Preview {
    ContentView()
}
