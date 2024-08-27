//
//  FetchListView.swift
//  GameTracker
//
//  Created by Henry Wertz on 4/16/24.
//

import SwiftUI

struct FetchListView: View {
    @EnvironmentObject var userEnvironment: UserEnvironment
    @StateObject var viewModel = ListViewModel()
    var listId: UUID
    var body: some View {
        VStack {
            if viewModel.isLoading {
                Text("Loading...")
            }
            else {
                Text(viewModel.currentList!.title)
                    .font(.title)
                List(viewModel.games) { game in
                    let year = viewModel.getYearFromTimeStamp(timestamp: game.first_release_date ?? 0)
                    NavigationLink(destination: DetailView(game: game)) {
                        HStack {
                            
                            
                            AsyncImage(url: URL(string: "https://images.igdb.com/igdb/image/upload/t_cover_big_2x/\(game.image_id ?? "bingus").jpg")) { image in
                                image.resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 88, height: 125)
                                    .clipShape(RoundedRectangle(cornerRadius: 8))
                                    .transition(.opacity.animation(.easeInOut(duration: 0.7)))
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
                            Text(game.name + " (\(year ?? ""))" )
                        }
                    }
                    
                }
            }
        }
        .onAppear {
            Task {
                if viewModel.isLoading {
                    guard let user = userEnvironment.user else {return}
                    try await viewModel.fetchListById(listId: listId)
                    try await viewModel.fetchGamePreviews(userId: user.uid, list: viewModel.currentList!)
                    viewModel.isLoading = false
                }
            }
        }
    }
}

#Preview {
    FetchListView(listId: UUID(uuidString: "00000000-0000-0000-0000-000000000000")!).environmentObject(UserEnvironment())
}
