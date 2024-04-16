//
//  DetailView.swift
//  GameTracker
//
//  Created by Henry Wertz on 3/20/24.
//

import SwiftUI

struct DetailView: View {
    @EnvironmentObject var userEnvironment: UserEnvironment
    @StateObject var viewModel = DetailViewModel()
    @State var game: Game
    
    var label = ""
    
    var maximumRating = 5
    
    var offImage: Image?
    var onImage = Image(systemName: "star.fill")
    
    var offColor = Color.gray
    var onColor = Color.yellow
    
    
    var body: some View {
        VStack {
            AsyncImage(url: URL(string: "https://images.igdb.com/igdb/image/upload/t_cover_big_2x/\(game.image_id).jpg")) { image in
                image.resizable()
                    .scaledToFill()
                    .clipShape(RoundedRectangle(cornerRadius: 8))
            } placeholder: {
                
            }
            .frame(width: 100, height: 150)
            Text(game.name)
            Text(String(game.rating!))
                .bold()
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
                        try await UserManager.shared.addReview(userId: user.uid, gameId: String(game.id), rating: viewModel.rating, reviewText: viewModel.reviewText, gameName: game.name)
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
                try await viewModel.getGameRating(userId: user.uid, gameId: game.id)
            }
        }
        .padding()
    }
}

#Preview {
    NavigationStack {
        DetailView(game: Game(id: 1, name: "Street Fighter 6",  total_rating: 234, total_rating_count: 34, rating: 96.234, image_id: "co5vst", first_release_date: 23423423)).environmentObject(UserEnvironment())
    }
}
