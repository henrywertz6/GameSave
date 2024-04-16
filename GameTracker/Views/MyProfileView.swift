//
//  ProfileView.swift
//  Letterboxd4Games
//
//  Created by Henry Wertz on 2/18/24.
//

import SwiftUI


struct MyProfileView: View {
    @EnvironmentObject var userEnvironment: UserEnvironment
    @StateObject private var viewModel = ProfileViewModel()
    @Binding var showSignInView: Bool
    
    var body: some View {
        NavigationStack {
            Image("chub")
                .resizable()
                .frame(width: 125, height: 125)
                .clipShape(Circle())
                .padding(.horizontal)
            if let user = userEnvironment.user {
                Text(user.display_name!)
                    .font(.title)
                
            }
            HStack {
                VStack {
                    Text("Followers")
                    Text(String(userEnvironment.followers.count))
                        .bold()
                }
                VStack {
                    Text("Following")
                    Text(String(userEnvironment.following.count))
                        .bold()
                }
                
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
            Spacer()
            
            
        }
        .navigationTitle("Profile")
        
        .onAppear {
            
            Task {
                guard let user = userEnvironment.user else {return}
                try await viewModel.loadCurrentUser()
                try await viewModel.fetchUserGameLibrary(userId: userEnvironment.user!.uid)
            }
        }
    }
    
}

#Preview {
    NavigationStack {
        MyProfileView(showSignInView: .constant(false)).environmentObject(UserEnvironment())
    }
    
}
