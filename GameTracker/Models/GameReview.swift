//
//  GameReview.swift
//  GameTracker
//
//  Created by Henry Wertz on 3/21/24.
//

import Foundation

struct GameReview: Codable {
    let id: UUID
    let gameId: Int
    let rating: Double
    let reviewText: String?
    let createdAt: Date
}
