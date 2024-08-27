//
//  SocialSearchView.swift
//  GameTracker
//
//  Created by Henry Wertz on 4/13/24.
//

import SwiftUI

struct SocialSearchView: View {
    @StateObject var viewModel = SocialViewModel()
    var body: some View {
        VStack {
            TextField("Search for users...", text: $viewModel.searchText)
                .textInputAutocapitalization(.never)
            
            List(viewModel.searchResults) { user in
                NavigationLink(destination: UserProfileView(userId: user.id, display_name: user.display_name)) {
                    Text(user.display_name)
                }
                
                
            }
        }
        .padding()
    }
}

#Preview {
    SocialSearchView()
}
