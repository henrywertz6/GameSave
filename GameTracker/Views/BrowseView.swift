//
//  BrowseView.swift
//  Letterboxd4Games
//
//  Created by Henry Wertz on 2/18/24.
//

import SwiftUI

struct BrowseView: View {
    @EnvironmentObject var network: Network
    private var gridItemLayout = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
    var body: some View {
        ScrollView {
            Text("Games")
                .font(.title)
                .bold()
            
            LazyVGrid(columns: gridItemLayout) {
                ForEach(network.games) { game in
                        AsyncImage(
                            url: URL(string: "https://images.igdb.com/igdb/image/upload/t_cover_small_2x/\(game.cover?.image_id ?? "co2uuv").jpg"),
                            content: { image in
                                image.resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .cornerRadius(7)
//                                    .overlay(RoundedRectangle(cornerRadius: 7).stroke(.gray, lineWidth: 2))
                                    
                            },
                            placeholder: {
                                AsyncImage(url: URL(string: "https://placehold.co/180x256"))
                            })
                            
                    
                }
            }
        }
        .onAppear {
            network.getGames()
        }
    }
}

enum apiError: Error {
    case invalidURL
    case invalidResponse
    case invalidData
}

#Preview {
    BrowseView().environmentObject(Network())
}
