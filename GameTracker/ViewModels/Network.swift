//
//  Network.swift
//  Letterboxd4Games
//
//  Created by Henry Wertz on 2/18/24.
//

import Foundation
import FirebaseFirestore
import FirebaseCore


class Network: ObservableObject {
    @Published var games: [Game] = []
    
    private let apiClientID = "ewp5ogg1xjgarr85eh6al8c4rlafc9"
    private let apiAuthorization = "Bearer 2ppze1nwlb60dt8uidkys7qhc6fnhx"
    init() {
        FirebaseApp.configure()
    }
    

    
//    func searchForGame(query: String) async throws -> GameResponse? {
//        if let gameData = try await checkFirestoreForGame(query: query) {
//            return gameData
//        } else {
//            let gameDataFromAPI = try await checkAPIForGameData(query: query)
//            
//            if let gameDataFromAPI = gameDataFromAPI {
//                await updateFireStoreWithGameData(gameDataFromAPI)
//            }
//            
//            return gameDataFromAPI
//        }
//    }
    
//    func checkFirestoreForGame(query: String) async throws -> GameResponse? {
//        let db = Firestore.firestore()
//        let gamesCollection = db.collection("games")
//        
//        
//    }
    
    func checkAPIForGameData(query: String) async throws -> GameResponse? {
        let apiURL = "https://api.igdb.com/v4/games"
        guard let url = URL(string: apiURL) else {
            fatalError("URL error")
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(apiClientID, forHTTPHeaderField: "Client-ID")
        request.setValue(apiAuthorization, forHTTPHeaderField: "Authorization")
        let requestBody = "fields name, total_rating, total_rating_count, cover.image_id; limit 25; search \"\(query)\";"
        request.httpBody = requestBody.data(using: .utf8)
        
        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            let decodedGames = try JSONDecoder().decode(GameResponse.self, from: data)
            return decodedGames
        } catch {
            print("Error fetching game data from API:", error)
            return nil
        }
    }
    
    func updateFireStoreWithGameData(_ gameResponse: GameResponse) async {
        
    }
    func getGames() {
        let apiURL = "https://api.igdb.com/v4/games"
        guard let url = URL(string: apiURL) else {
            fatalError("URL error")
        }
        var requestHeader = URLRequest.init(url: url)
        requestHeader.httpBody = "fields name, total_rating, total_rating_count, cover.image_id; limit 25; search \"Street Fighter\";".data(using: .utf8, allowLossyConversion: false)
        requestHeader.httpMethod = "POST"
        requestHeader.setValue("ewp5ogg1xjgarr85eh6al8c4rlafc9", forHTTPHeaderField: "Client-ID")
        requestHeader.setValue("Bearer 2ppze1nwlb60dt8uidkys7qhc6fnhx", forHTTPHeaderField: "Authorization")
        requestHeader.setValue("application/json", forHTTPHeaderField: "Accept")
        
        
        let dataTask = URLSession.shared.dataTask(with: requestHeader) { (data, response, error) in
            if let error = error {
                print("Request error:", error)
                return
            }
            guard let response = response as? HTTPURLResponse else { return }
            
            if response.statusCode == 200 {
                guard let data = data else { return }
                DispatchQueue.main.async {
                    do {
                        let decodedGames = try JSONDecoder().decode([Game].self, from: data)
                        self.games = decodedGames
                        
                        
                    } catch let error {
                        print("Error decoding:", error)
                    }
                }
            }
            
        }
        
        dataTask.resume()
        
    }
}



