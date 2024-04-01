//
//  GameList.swift
//  GameTracker
//
//  Created by Henry Wertz on 4/1/24.
//

import Foundation

struct GameList: Codable {
    let id: UUID
    let title: String
    let userId: String
    let games: [Int]
    let isPublic: Bool
    
}
