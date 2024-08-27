//
//  DetailViewModel.swift
//  GameTracker
//
//  Created by Henry Wertz on 4/1/24.
//

import Foundation


@MainActor
class DetailViewModel: ObservableObject {
    @Published var isLoading: Bool = true
    @Published var game: Game? = nil
    @Published var rating: Double = 0.0
    @Published var reviewText: String = ""
    
    func fetchGameData(gameId: String) async throws -> Game? {
        isLoading = true
        game = try await UserManager.shared.fetchGame(gameId: gameId)
        return game ?? nil
    }
    
    func getGameRating(userId: String, gameId: Int) async throws {
        (self.rating, self.reviewText) = try await UserManager.shared.getGameRating(userId: userId, gameId: gameId)
    }
}
