//
//  AddGamesView.swift
//  GameTracker
//
//  Created by Henry Wertz on 4/6/24.
//

import SwiftUI

struct AddGamesView: View {
    @Binding var selectedGameIDs: [String]
    @Binding var selectedGames: [ListObject]
    @StateObject private var searchViewModel = SearchViewModel()
    var body: some View {
        NavigationStack {
            VStack {
                TextField("Search video games...", text: $searchViewModel.searchText)
                    .padding()
                List(searchViewModel.searchResults) { game in
                    let year = searchViewModel.getYearFromTimeStamp(timestamp: game.first_release_date ?? 0)
                    
                    HStack {
                        ZStack {
                            AsyncImage(url: URL(string: "https://images.igdb.com/igdb/image/upload/t_cover_big_2x/\(game.image_id ?? "bingus").jpg")) { image in
                                image.resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 88, height: 125)
                                    .clipShape(RoundedRectangle(cornerRadius: 8))
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
                        }
                        
                        Toggle(isOn: Binding(
                            get: { selectedGameIDs.contains(game.id) },
                            set: { isSelected in
                                if isSelected {
                                    selectedGameIDs.append(game.id)
                                    selectedGames.append(ListObject(id: game.id, image_id: game.image_id, name: game.name, year: year!))
                                } else {
                                    if let index = selectedGameIDs.firstIndex(of: game.id) {
                                        selectedGameIDs.remove(at: index)
                                    }
                                    if let index = selectedGames.firstIndex(where: {$0.id == game.id} ) {
                                        selectedGames.remove(at: index)
                                    }
                                }
                            }
                        )) {
                            Text("\(game.name) (\(year!))")
                        }
                    }
                }
            }
            .onDisappear {
                searchViewModel.cancellable?.cancel()
            }
            .onAppear {
                searchViewModel.setupDebounceSubscription()
            }
            .navigationTitle("Add Games")
        }
    }
}

#Preview {
    NavigationStack {
        AddGamesView(
            selectedGameIDs: .constant(["1", "2", "3"]),
            selectedGames: .constant([
                ListObject(id: "1", image_id: "image1", name: "Game 1", year: "2021"),
                ListObject(id: "2", image_id: "image2", name: "Game 2", year: "2022"),
                ListObject(id: "3", image_id: "image3", name: "Game 3", year: "2023")
            ])
        )
    }
}
