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
    @State var rating: Double = 0
    
    var body: some View {
        VStack {
            if viewModel.isLoading {
                Text("yo wtf")
            }
            else {
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
                    count: $rating,
                    minimum: 1,
                    maximum: 5,
                    spacing: 8
                ) { active, i in
                    let index = Double(i)
                    let isFilled = index < rating
                    Image(systemName: isFilled ? ((rating - index).isEqual(to: 0.5) ? "star.leadinghalf.fill" : "star.fill") : "star")
                        .font(.system(size: 40))
                        .foregroundStyle(active ? .yellow : .gray.opacity(0.3))
                }
                
                Button {
                    Task {
                        guard let user = userEnvironment.user else {return}
                        if !isReviewed {
                            try await UserManager.shared.addReview(userId: user.uid, gameId: String(gameId), rating: rating, reviewText: "")
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
                    rating = try await UserManager.shared.getGameRating(userId: user.uid, gameId: String(gameId))
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
