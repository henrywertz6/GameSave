//
//  GameLog.swift
//  GameTracker
//
//  Created by Henry Wertz on 3/21/24.
//

import Foundation
import FirebaseFirestore

struct GameLog: Codable {
    @DocumentID var gameId: String?
    var status: GameStatus?
    var reviewId: String?
    var reviewed: Bool
    var dateAdded: Date
}

enum GameStatus: String, Codable {
    case Played
    case Playing
    case Wishlist
}
