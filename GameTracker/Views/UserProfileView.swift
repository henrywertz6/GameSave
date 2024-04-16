//
//  UserProfileView.swift
//  GameTracker
//
//  Created by Henry Wertz on 4/9/24.
//

import SwiftUI

struct UserProfileView: View {
    @EnvironmentObject var userEnvironment: UserEnvironment
    @StateObject private var viewModel = ProfileViewModel()
    var userId: String
    var display_name: String
    
    var body: some View {
        VStack {
            Image("chub")
                .resizable()
                .frame(width: 125, height: 125)
                .clipShape(Circle())
                .padding(.horizontal)
            Text(display_name)
                .font(.title)
            Button {
                Task {
                    try await viewModel.followUser(userIdToFollow: userEnvironment.user!.uid, followedUserId: userId)
                    userEnvironment.following.insert(userId)
                }
            } label: {
                Text("Follow")
                    .padding()
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(height:55)
                    .background(Color.blue)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .padding(.vertical, 6)
            }
            ScrollView {
                let columns = [GridItem(.flexible(), spacing: 0), GridItem(.flexible(), spacing: 0), GridItem(.flexible(), spacing: 0)]
                LazyVGrid(columns: columns) {
                    ForEach(viewModel.userGameLibrary) { game in
                        NavigationLink(destination: DetailView(game: game)) {
                            AsyncImage(url: URL(string: "https://images.igdb.com/igdb/image/upload/t_cover_big_2x/\(game.image_id).jpg")) { image in
                                image.resizable()
                                    .scaledToFill()
                                    .clipShape(RoundedRectangle(cornerRadius: 8))
                                    .transition(.opacity.animation(.easeInOut(duration: 0.5)))
                            } placeholder: {
                                
                            }
                            .frame(width: 100, height: 150)
                            
                        }
                    }
                }
                
            }
            
        }
        .onAppear {
            Task {
                try await viewModel.fetchUserGameLibrary(userId: userId)
            }
        }
    }
}

#Preview {
    NavigationStack {
        UserProfileView(userId: "asdfasdfasdf", display_name: "username")
    }
}
