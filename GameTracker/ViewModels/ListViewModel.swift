//
//  ListViewModel.swift
//  GameTracker
//
//  Created by Henry Wertz on 4/1/24.
//

import Foundation


//
//  ListViewModel.swift
//  GameTracker
//
//  Created by Henry Wertz on 4/1/24.
//

import Foundation
import FirebaseCore
import FirebaseFirestore

@MainActor
class ListViewModel: ObservableObject {
    @Published var currentList: GameList? = nil
    @Published var userLists: [GameList] = []
    @Published var games: [Game] = []
    @Published var isLoading: Bool = true
    
    
    func createList(userId: String, initialGames: [String], title: String, isPublic: Bool) async throws {
        guard !title.isEmpty else {
            print("List title cannot be empty")
            return
        }
        try await UserManager.shared.createList(userId: userId, initialGames: initialGames, title: title, isPublic: isPublic)
    }
    
    func fetchUserLists(userId: String) async throws {
        userLists = try await UserManager.shared.fetchUserLists(userId: userId)
    }
    
    func fetchGamePreviews(userId: String, list: GameList) async throws {
        isLoading = true
        for game in list.games {
            games.append(try await fetchGamePreview(for: game))
        }
    }
    
    func fetchGamePreview(for gameId: String) async throws -> Game {
        return try await UserManager.shared.fetchGamePreview(gameId: gameId)
    }
    
    func getYearFromTimeStamp(timestamp: Double) -> String? {
        let date = Date(timeIntervalSince1970: timestamp)
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy"
        let yearString = formatter.string(from: date)
        return yearString
        
    }
    
    func fetchListById(listId: UUID) async throws {
        self.currentList = try await UserManager.shared.fetchListById(listId: listId)
    }
    
}
