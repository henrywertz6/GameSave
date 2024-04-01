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
                            } placeholder: {
                                
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
