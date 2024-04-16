//
//  DetailFetchView.swift
//  GameTracker
//
//  Created by Henry Wertz on 4/1/24.
//

import SwiftUI

struct DetailFetchView: View {
    @EnvironmentObject var userEnvironment: UserEnvironment
    @StateObject var viewModel = DetailViewModel()
    var gameId: String
    
    var body: some View {
        VStack {
            if viewModel.isLoading {
                Text("Loading...")
            }
            else {
                AsyncImage(url: URL(string: "https://images.igdb.com/igdb/image/upload/t_cover_big_2x/\(viewModel.game?.image_id ?? "bingus").jpg")) { image in
                    image.resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 141, height: 212)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                        .transition(.opacity.animation(.easeInOut(duration: 0.7)))
                } placeholder: {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.gray.opacity(0.2))
                        .frame(width: 141, height: 212)
                        .overlay(
                            Text(viewModel.game!.name)
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
                Text(viewModel.game!.name)
                Text(String((viewModel.game?.rating ?? 0)))
                let isInLibrary = userEnvironment.library.contains(gameId)
                let isReviewed = userEnvironment.reviews.contains(gameId)
                Button {
                    Task {
                        guard let user = userEnvironment.user else {return}
                        if !isInLibrary {
                            try await UserManager.shared.addGameToLibrary(userId: user.uid, game: viewModel.game!)
                            userEnvironment.library.insert(String(gameId))
                        }
                        else {
                            print("removing game from library")
                            try await UserManager.shared.removeGameFromLibrary(userId: user.uid, game: viewModel.game!)
                            userEnvironment.library.remove(String(gameId))
                        }
                        
                    }
                } label: {
                    Text(isInLibrary ? "Remove from Library" : "Add to Library")
                        .padding()
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(height:55)
                        .background(Color.blue)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        .transition(.opacity)
                    
                }
                StarRatingSlider(
                    count: $viewModel.rating,
                    minimum: 1,
                    maximum: 5,
                    spacing: 8
                ) { active, i in
                    let index = Double(i)
                    let isFilled = index < viewModel.rating
                    Image(systemName: isFilled ? ((viewModel.rating - index).isEqual(to: 0.5) ? "star.leadinghalf.fill" : "star.fill") : "star")
                        .font(.system(size: 40))
                        .foregroundStyle(active ? .yellow : .gray.opacity(0.3))
                }
                .disabled(isReviewed)
                if isReviewed {
                    Text(viewModel.reviewText)
                } else {
                    TextEditor(text: $viewModel.reviewText)
                                    .frame(height: 150)
                                    .border(Color.gray, width: 1)
                                    .cornerRadius(5)
                                    .padding(.horizontal)
                                    .disabled(isReviewed)
                }
                Button {
                    Task {
                        guard let user = userEnvironment.user else {return}
                        if !isReviewed {
                            try await UserManager.shared.addReview(userId: user.uid, gameId: String(gameId), rating: viewModel.rating, reviewText: viewModel.reviewText, gameName: viewModel.game?.name ?? "")
                            userEnvironment.reviews.insert(String(gameId))
                        }
                        else {
                            // implement removing review and call it here
                        }
                    }
                } label: {
                    Text(!isReviewed ? "Review" : "Reviewed")
                        .padding()
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(height:55)
                        .background(Color.blue)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                }
                .disabled(isReviewed)
            }
            
            
            
            
            
            
        }
        .onAppear {
            Task {
                do {
                    guard let user = userEnvironment.user else {return}
                    viewModel.game = try await viewModel.fetchGameData(gameId: String(gameId))
                    try await viewModel.getGameRating(userId: user.uid, gameId: Int(gameId) ?? 0)
                    viewModel.isLoading = false
                }
                catch {
                    print("Error fetching game: \(error)")
                }
            }
        }
        .padding()
    }
}

#Preview {
    DetailFetchView(gameId: "191692").environmentObject(UserEnvironment())
}
