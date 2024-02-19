//
//  Game.swift
//  Letterboxd4Games
//
//  Created by Henry Wertz on 2/18/24.
//

import Foundation

struct Game: Codable, Identifiable {
//    let id: Int
    let id: Int
    let name: String
    let cover: Cover?
//    let released: String
//    let metacritic: Int
//    let background_image: String
}

struct Cover: Codable {
    let id: Int
    let image_id: String
}

struct GameResponse: Decodable {
    let results: [Game]
}


