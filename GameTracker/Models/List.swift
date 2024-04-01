//
//  List.swift
//  GameTracker
//
//  Created by Henry Wertz on 4/1/24.
//

import Foundation

struct List: Codable {
    let id: UUID
    let title: String
    let games: [Game]
    
}
