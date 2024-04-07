//
//  ListView.swift
//  GameTracker
//
//  Created by Henry Wertz on 4/6/24.
//

import SwiftUI

struct ListView: View {
    @EnvironmentObject var userEnvironment: UserEnvironment
    @State var list: GameList
    @StateObject var viewModel = ListViewModel()
    var body: some View {
        VStack {
            if viewModel.isLoading {
                Text("Loading...")
            }
            else {
                Text(list.title)
                    .font(.title)
                List(viewModel.gamePreviews) { game in
                    HStack {
                        let year = viewModel.getYearFromTimeStamp(timestamp: game.first_release_date)
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
//                .transition(.opacity.animation(.easeInOut(duration: 0.5)))
            }
            
        }
        .onAppear {
            Task {
                guard let user = userEnvironment.user else {return}
                try await viewModel.fetchGamePreviews(userId: user.uid, list: list)
                viewModel.isLoading = false
            }
            
            
        }
    }
}

#Preview {
    NavigationStack {
        ListView(list: GameList(
            id: UUID(uuidString: "00000000-0000-0000-0000-000000000000")!,
            title: "My Favorite Games",
            userId: "user123",
            games: [
                "113112",
                "11737",
                "27134",
                "25076",
                "52189"
            ],
            isPublic: true
        ))
        .environmentObject(UserEnvironment())
    }
}
