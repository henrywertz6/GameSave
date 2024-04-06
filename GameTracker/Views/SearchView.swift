//
//  SearchView.swift
//  Letterboxd4Games
//
//  Created by Henry Wertz on 2/18/24.
//

import SwiftUI

struct SearchView: View {
    @StateObject private var viewModel = SearchViewModel()
    
    var body: some View {
        VStack {
            
            NavigationStack {
                TextField("Search video games...", text: $viewModel.searchText)
                    .padding()
                List(viewModel.searchResults) { game in
                    let year = viewModel.getYearFromTimeStamp(timestamp: game.first_release_date ?? 0)
                    NavigationLink(destination: DetailFetchView(gameId: String(game.id))) {
                        HStack {
                            AsyncImage(url: URL(string: "https://images.igdb.com/igdb/image/upload/t_cover_big_2x/\(game.image_id ?? "bingus").jpg")) { image in
                                image.resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 88, height: 125)
                                    .clipShape(RoundedRectangle(cornerRadius: 8))
                                    .transition(.opacity)
                            } placeholder: {
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color.gray.opacity(0.2))
                                    .frame(width: 88, height: 125)
                                    .overlay(
                                        Text(game.name)
                                            .font(.caption)
                                            .foregroundColor(.white)
                                            .lineLimit(2)
                                            .multilineTextAlignment(.center)
                                            .padding(4)
                                    )
                            }
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                            )
                            .shadow(color: Color.black.opacity(0.2), radius: 4, x: 0, y: 2)
                            .transition(.opacity)
                            Text(game.name + " (\(year ?? ""))")
                        }
                    }
                    
                }
            }
        }
        .onDisappear {
            viewModel.cancellable?.cancel()
        }
        .onAppear {
            viewModel.setupDebounceSubscription()
        }
        
        
    }
}

#Preview {
    SearchView()
}
