//
//  GameList.swift
//  GameTracker
//
//  Created by Henry Wertz on 4/1/24.
//

import Foundation

struct GameList: Codable, Identifiable {
    let id: UUID
    let title: String
    let userId: String
    let games: [String]
    let isPublic: Bool
    
}

extension GameList: Sequence {
    func makeIterator() -> Array<String>.Iterator {
        return games.makeIterator()
    }
}
