//
//  UserManager.swift
//  GameTracker
//
//  Created by Henry Wertz on 3/11/24.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

final class UserManager {
    static let shared = UserManager()
    private init() {}
    
    var db = Firestore.firestore()
    func createNewUser(auth: AuthDataResultModel) async throws {
        let user = User(
            id: auth.uid,
            display_name: auth.display_name!,
            profilePic: auth.photoUrl,
            preferredPlatforms: [],
            friends: nil,
            following: nil,
            datecreated: Date(),
            email: auth.email!
            
        )
        
        try db.collection("users").document(auth.uid).setData(from: user)
    }
    
    func getUserLibraryId(userId: String) async throws -> Set<String> {
        let gameLibrary = try await db.collection("users").document(userId).collection("gameLibrary").getDocuments()
        var games: Set<String> = []
        for gameLog in gameLibrary.documents {
            games.insert(gameLog.documentID)
        }
        
        return games
        
    }
    
    func getUserReviewSet(userId: String) async throws -> Set<String> {
      let reviewLibrary = try await db.collection("users").document(userId).collection("reviewLibrary").getDocuments()
      var reviews: Set<String> = []
      for gameReview in reviewLibrary.documents {
        let gameId = gameReview.get("gameId") as? Int  // Access gameId as optional Int

        if let gameId = gameId {
          reviews.insert(String(gameId)) // Convert Int to String for Set
        } else {
          reviews.insert("Missing Game ID") // Handle missing gameId
        }
      }
      return reviews
    }

    
    func addGameToLibrary(userId: String, game: Game) async throws {
        let gameLibraryCollection = db.collection("users").document(userId).collection("gameLibrary")
        let gameLog = GameLog(
            gameId: String(game.id),
            status: GameStatus.Played,
            reviewId: "",
            reviewed: false,
            dateAdded: Date()
            
        )
        
        do {
            try gameLibraryCollection.document(String(game.id)).setData(from: gameLog)
            print("Game with id \(game.id) added to library")
        }
        catch {
            print(error)
        }
        
    }
    
    
    func removeGameFromLibrary(userId: String, game: Game) async throws {
        try await db.collection("users").document(userId).collection("gameLibrary").document(String(game.id)).delete()
        print("Game with id \(game.id) removed from library")
    }
    
    func addReview(userId: String, gameId: String, rating: Double, reviewText: String?) async throws {
        let reviewLibraryCollection = db.collection("users").document(userId).collection("reviewLibrary")
        
        let gameReview = GameReview(
            id: UUID(),
            gameId: Int(gameId) ?? 0,
            rating: rating,
            reviewText: reviewText,
            createdAt: Date()
        )
        do {
            try reviewLibraryCollection.document().setData(from: gameReview)
            print("Game with id \(gameId) has been reviewed. ReviewId: \(gameReview.id)")
        }
        catch {
            print(error)
        }
    }
    
    func getGameRating(userId: String, gameId: String) async throws -> Double {
        let reviewLibraryCollection = db.collection("users").document(userId).collection("reviewLibrary")
        
        let reviewQuery = reviewLibraryCollection.whereField("gameId", isEqualTo: gameId)
        
        let querySnapshot = try await reviewQuery.getDocuments()
        
        if querySnapshot.isEmpty {
            return -1.0 // No review found for the game
        }
        
        guard let reviewDoc = querySnapshot.documents.first else {
            throw NSError(domain: "Firestore Error", code: -1, userInfo: ["message": "Unexpected document structure"])
        }
        
        let reviewData = reviewDoc.data()
        let rating = reviewData["rating"] as? Double
        
        return rating!
        
    }
    
    
    func getGameLibrary(userId: String) async throws -> GameData {
        let userRef = db.collection("users").document(userId)
        let gamesRef = db.collection("games")
        
        var gameData: [Game] = []
        var gameLibraryData: [GameLog] = []
        do {
            let querySnapshot = try await userRef.collection("gameLibrary").getDocuments()
            for document in querySnapshot.documents {
                gameLibraryData.append(try document.data(as: GameLog.self))
                let game = try await gamesRef.document(document.documentID).getDocument()
                gameData.append(try game.data(as: Game.self))
            }
        } catch {
            print("Error getting documents: \(error)")
        }
        
        return GameData(gameData: gameData, gameLibraryData: gameLibraryData)
        
        
        
        
    }
    
    func createList(userId: String, initialGames: [String], title: String, isPublic: Bool) async throws {
        let listRef = db.collection("lists")
        var gameIdList: [String] = []
        for gameId in initialGames {
            gameIdList.append(gameId)
        }
        let listObject = GameList(id: UUID(), title: title, userId: userId, games: gameIdList, isPublic: isPublic)
        
        try listRef.addDocument(from: listObject)
        
    }
    
    func fetchGame(gameId: String) async throws -> Game {
        return try await db.collection("games").document(gameId).getDocument(as: Game.self)
        
        
    }

    
    
}
