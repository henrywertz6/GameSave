//
//  ListObject.swift
//  GameTracker
//
//  Created by Henry Wertz on 4/4/24.
//

import Foundation

struct ListObject: Codable, Hashable, Identifiable {
    let id: String
    let image_id: String?
    let name: String
    let year: String
}
