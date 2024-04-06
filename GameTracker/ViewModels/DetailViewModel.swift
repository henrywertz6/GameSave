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
    
    func fetchGameData(gameId: String) async throws -> Game? {
        isLoading = true
        print("i am starting to load the game")
        game = try await UserManager.shared.fetchGame(gameId: gameId)
        print("i have finished loading the game")
        return game ?? nil
    }
}
