//
//  User.swift
//  GameTracker
//
//  Created by Henry Wertz on 3/12/24.
//

import Foundation
import FirebaseFirestore
struct User: Codable {
    @DocumentID var id: String?
    var display_name: String
    var profilePic: String?
    var preferredPlatforms: [String]
    var friends: [String]?
    var following: [String]?
    var datecreated: Date
    var email: String
    var lists: [List]?
}




//struct User: Codable {
//    let id: Int
//    let name: String
//    
//}
