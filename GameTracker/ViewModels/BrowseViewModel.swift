//
//  BrowseViewModel.swift
//  GameTracker
//
//  Created by Henry Wertz on 3/19/24.
//

import Foundation
import FirebaseCore
import FirebaseFirestore

class BrowseViewModel: ObservableObject {
    @Published var games: [Game] = []
    @Published var dataLoaded = false
    
    func loadRecentGames() {
        
        let db = Firestore.firestore()
        // Construct the initial query with order, limit, and pagination cursor (empty for first page)
        let query = db.collection("games")
            .whereField("category", isEqualTo: 0)
            .order(by: "rating", descending: true)
            .limit(to: 25)
        
        
        print("about to start fetching games")
        // Fetch documents based on the constructed query
        query.getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error fetching games:", error)
                // You can handle the error here by showing an alert to the user or retrying the operation
                return
            }
            
            guard let querySnapshot = querySnapshot else {
                print("No games found")
                return
            }
            
            // Use Codable to convert documents to Game objects
            let newGames = querySnapshot.documents.compactMap { document in
                do {
                    // Attempt to decode the document data into a Game object
                    let gameData = try document.data(as: Game.self)
                    return gameData
                } catch {
                    print("Error decoding game data:", error)
                    return nil
                }
            }
            self.games.append(contentsOf: newGames)
            
            
            self.dataLoaded = true
            
            // Check if there are more documents available (for pagination)
//            if !querySnapshot.isEmpty {
//                self.currentPage += 1
//            }
        }
    }
    
    
    func addGameToLibrary(gameId: Int, status: GameStatus? = nil) async throws {
        
    }
}
