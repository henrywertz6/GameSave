//
//  ActivityLog.swift
//  GameTracker
//
//  Created by Henry Wertz on 4/13/24.
//

import Foundation

struct ActivityLog: Codable, Identifiable {
    let id: UUID
    let userId: String
    let activityType: String
    let timestamp: Date
    let listId: UUID?
    let listName: String?
    let gameId: String?
    let gameName: String?
    let reviewId: UUID?
    let rating: Double?
    
}
