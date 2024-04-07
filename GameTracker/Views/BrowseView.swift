//
//  BrowseView.swift
//  Letterboxd4Games
//
//  Created by Henry Wertz on 2/18/24.
//

import SwiftUI

struct BrowseView: View {
    @StateObject var viewModel = BrowseViewModel()
    @EnvironmentObject var userEnvironment: UserEnvironment
    var body: some View {
        ScrollView {
            let columns = [GridItem(.flexible(), spacing: 0), GridItem(.flexible(), spacing: 0), GridItem(.flexible(), spacing: 0)]
            LazyVGrid(columns: columns) {
                ForEach(viewModel.games) { game in
                    NavigationLink(destination: DetailView(game: game)) {
                        AsyncImage(url: URL(string: "https://images.igdb.com/igdb/image/upload/t_cover_big_2x/\(game.image_id).jpg")) { image in
                            image.resizable()
                                .scaledToFill()
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                                .transition(.opacity.animation(.easeInOut(duration: 0.7)))
                        } placeholder: {
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.gray.opacity(0.2))
                                .frame(width: 100, height: 150)
                                .overlay(
                                    Text(game.name)
                                        .font(.caption)
                                        .foregroundColor(.black)
                                        .lineLimit(2)
                                        .multilineTextAlignment(.center)
                                        .padding(4)
                                )
                        }
                        .frame(width: 100, height: 150)
                    }
                }
            }
            .navigationTitle("Browse")
            .onAppear {
                if !viewModel.dataLoaded {
                    viewModel.loadRecentGames()
                }
            }
        }
    }
    
}



#Preview {
    NavigationStack {
        BrowseView().environmentObject(UserEnvironment())
    }
}
