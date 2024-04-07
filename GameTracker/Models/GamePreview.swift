//
//  GamePreview.swift
//  GameTracker
//
//  Created by Henry Wertz on 4/7/24.
//

import Foundation

struct GamePreview: Codable, Identifiable {
    let id: Int
    let name: String
    let first_release_date: Double
    let image_id: String?
}
