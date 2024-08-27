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
            followers: [],
            following: [],
            datecreated: Date(),
            email: auth.email!
            
        )
        
        let searchUser = UserSearch(id: auth.uid, display_name: auth.display_name!)
        
        try db.collection("users").document(auth.uid).setData(from: user)
        try db.collection("usersearch").document(auth.uid).setData(from: searchUser)
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
            let activityLog = ActivityLog(id: UUID(), userId: userId, activityType: "Game", timestamp: Date(), listId: nil, listName: nil, gameId: String(game.id), gameName: game.name, reviewId: nil, rating: nil)
            try await UserManager.shared.addActivityLog(activityLog: activityLog)
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
    
    func addReview(userId: String, gameId: String, rating: Double, reviewText: String?, gameName: String) async throws {
        let reviewLibraryCollection = db.collection("users").document(userId).collection("reviewLibrary")
        let reviewId = UUID()
        let gameReview = GameReview(
            id: reviewId,
            gameId: Int(gameId) ?? 0,
            rating: rating,
            reviewText: reviewText,
            createdAt: Date()
        )
        do {
            try reviewLibraryCollection.document().setData(from: gameReview)
            let activityLog = ActivityLog(id: UUID(), userId: userId, activityType: "Review", timestamp: Date(), listId: nil, listName: nil,  gameId: gameId, gameName: gameName, reviewId: reviewId, rating: rating)
            try await UserManager.shared.addActivityLog(activityLog: activityLog)
            print("Game with id \(gameId) has been reviewed. ReviewId: \(gameReview.id)")
        }
        catch {
            print(error)
        }
    }
    
    func getGameRating(userId: String, gameId: Int) async throws -> (Double, String) {
        let reviewLibraryCollection = db.collection("users").document(userId).collection("reviewLibrary")
        
        let reviewQuery = reviewLibraryCollection.whereField("gameId", isEqualTo: gameId)
        
        let querySnapshot = try await reviewQuery.getDocuments()
        
        if querySnapshot.isEmpty {
            return (-1.0, "") // No review found for the game
        }
        
        guard let reviewDoc = querySnapshot.documents.first else {
            throw NSError(domain: "Firestore Error", code: -1, userInfo: ["message": "Unexpected document structure"])
        }
        
        let reviewData = reviewDoc.data()
        let rating = reviewData["rating"] as? Double
        let reviewText = reviewData["reviewText"] as? String
        
        return (rating ?? -1.0, reviewText ?? "")
        
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
        let listId = UUID()
        let listObject = GameList(id: listId, title: title, userId: userId, games: gameIdList, isPublic: isPublic)
        
        do {
            try listRef.document(listId.uuidString).setData(from: listObject)
        } catch {
            print("Error creating list: \(error)")
        }
        let activityLog = ActivityLog(id: UUID(), userId: userId, activityType: "List", timestamp: Date(), listId: listId, listName: title, gameId: nil, gameName: nil, reviewId: nil, rating: nil)
        try await UserManager.shared.addActivityLog(activityLog: activityLog)
        
    }
    
    func fetchGame(gameId: String) async throws -> Game {
        return try await db.collection("games").document(gameId).getDocument(as: Game.self)
        
        
    }
    
    func fetchUserLists(userId: String) async throws -> [GameList] {
        let listRef = db.collection("lists")
        let userListsRef = try await listRef.whereField("userId", isEqualTo: userId).getDocuments()
        
        var gameLists: [GameList] = []
        
        for document in userListsRef.documents {
            do {
                let decoder = Firestore.Decoder()
                let data = document.data()
                let decodedData = try decoder.decode(GameList.self, from: data)
                gameLists.append(decodedData)
            } catch {
                print("Error decoding GameList: \(error)")
            }
        }
        
        return gameLists
        
    }
    
    func fetchGamePreview(gameId: String) async throws -> Game {
        let gameRef = db.collection("games").document(gameId)
        
        do {
            let gamePreview = try await gameRef.getDocument(as: Game.self)
            return gamePreview
            
            
        }
        catch {
            print("Error loading GamePreview: \(error)")
            throw error
        }
        
    }
    
    func searchUsers(searchText: String) async throws {
        let userRef = db.collection("users")
        let query = userRef
            .whereField("display_name", isGreaterThanOrEqualTo: searchText)
            .whereField("display_name", isLessThanOrEqualTo: searchText + "\u{f8ff}")
        
        try await query.getDocuments()
    }
    
    func followUser(userIdToFollow: String, followedUserId: String) async throws {
        let userRef = db.collection("users").document(userIdToFollow)
        let followedUserRef = db.collection("users").document(followedUserId)
        
        try await userRef.updateData([
            "following": FieldValue.arrayUnion([followedUserId])
        ])
        
        try await followedUserRef.updateData([
            "followers": FieldValue.arrayUnion([userIdToFollow])
        ])
        
        
        
    }
    
    func getFollowersFollowingSets(userId: String) async throws -> (Set<String>, Set<String>) {
        let userRef = db.collection("users").document(userId)
        let userData = try await userRef.getDocument(as: User.self)
        var followers: Set<String> = []
        var following: Set<String> = []
        for id in userData.followers {
            followers.insert(id)
        }
        
        for id in userData.following {
            following.insert(id)
        }
        return (followers, following)
    }
    
    func getSocialActivity(userId: String, following: Set<String>) async throws -> [ActivityLog] {
        let activityRef = db.collection("activity")
        var activityResults: [ActivityLog] = []
        let query = activityRef.whereField("userId", in: Array(following)).limit(to: 20).order(by: "timestamp", descending: true)
        do {
            let querySnapshot = try await query.getDocuments()
            
            for document in querySnapshot.documents {
                do {
                    let activityLog = try document.data(as: ActivityLog.self)
                    activityResults.append(activityLog)
                } catch {
                    print("Error decoding activity log: \(error)")
                }
            }
        } catch {
            print("Error getting activity documents: \(error)")
        }
        
        return activityResults
        
    }
    
    func addActivityLog(activityLog: ActivityLog) async throws {
        let activityRef = db.collection("activity")
        try activityRef.document(activityLog.id.uuidString).setData(from: activityLog)
    }
    
    func getDisplayNames(activityLogs: [ActivityLog]) async throws -> [String:String] {
        let userCollectionRef = db.collection("users")
        var displayNames: [String:String] = [:]
        for activityLog in activityLogs {
            if displayNames[activityLog.userId] == nil {
                let userSnapshot = try await userCollectionRef.document(activityLog.userId).getDocument()
                if let userData = userSnapshot.data(),
                   let displayName = userData["display_name"] as? String {
                    displayNames[activityLog.userId] = displayName
                }
            }
        }
        return displayNames
    }
    
    func fetchListById(listId: UUID) async throws -> GameList? {
        let listRef = db.collection("lists")
        do {
            return try await listRef.document(listId.uuidString).getDocument(as: GameList.self)
        } catch {
            print("Error fetching list: \(error)")
            return nil
        }
    }
}
