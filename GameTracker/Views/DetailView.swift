//
//  DetailView.swift
//  GameTracker
//
//  Created by Henry Wertz on 3/20/24.
//

import SwiftUI

struct DetailView: View {
    @EnvironmentObject var userEnvironment: UserEnvironment
    let game: Game
    @State var rating: Double = 0
    
    var label = ""
    
    var maximumRating = 5
    
    var offImage: Image?
    var onImage = Image(systemName: "star.fill")
    
    var offColor = Color.gray
    var onColor = Color.yellow
    
    
    var body: some View {
        VStack {
            Text(game.name)
            Text(String(game.rating!))
            let gameId = String(game.id)
            let isInLibrary = userEnvironment.library.contains(gameId)
            let isReviewed = userEnvironment.reviews.contains(gameId)
            Button {
                Task {
                    guard let user = userEnvironment.user else {return}
                    if !isInLibrary {
                        try await UserManager.shared.addGameToLibrary(userId: user.uid, game: game)
                        userEnvironment.library.insert(gameId)
                    }
                    else {
                        print("removing game from library")
                        try await UserManager.shared.removeGameFromLibrary(userId: user.uid, game: game)
                        userEnvironment.library.remove(gameId)
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
                        try await UserManager.shared.addReview(userId: user.uid, game: game, rating: rating, reviewText: "")
                        userEnvironment.reviews.insert(gameId)
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
        .onAppear {
            Task {
                guard let user = userEnvironment.user else {return}
                rating = try await UserManager.shared.getGameRating(userId: user.uid, game: game)
            }
        }
        .padding()
    }
}

#Preview {
    NavigationStack {
        DetailView(game: Game(id: 23, name: "Bingus",  total_rating: 234, total_rating_count: 34, rating: 76.234, image_id: "asdfaasd")).environmentObject(UserEnvironment())
    }
}
