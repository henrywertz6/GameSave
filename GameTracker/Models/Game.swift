//
//  Game.swift
//  Letterboxd4Games
//
//  Created by Henry Wertz on 2/18/24.
//

import Foundation

struct Game: Codable, Identifiable {
    let id: Int
    let name: String
    let total_rating: Double?
    let total_rating_count: Int?
    let rating: Double?
    let image_id: String

}


struct GameResponse: Decodable {
    let results: [Game]
}


