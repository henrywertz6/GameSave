//
//  Network.swift
//  Letterboxd4Games
//
//  Created by Henry Wertz on 2/18/24.
//

import Foundation

class Network: ObservableObject {
    @Published var games: [Game] = []
    
    
    func getGames() {
    //    let apiURL = "https://api.rawg.io/api/games?search=Hades&page_size=1&key=\(apiKey)"
    //    print(apiURL)
        let apiURL = "https://api.igdb.com/v4/games"
        guard let url = URL(string: apiURL) else {
            fatalError("URL error")
        }
        var requestHeader = URLRequest.init(url: url)
        requestHeader.httpBody = "fields name, cover.image_id; limit 25; search \"Black Ops\";".data(using: .utf8, allowLossyConversion: false)
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



