//
//  ListViewModel.swift
//  GameTracker
//
//  Created by Henry Wertz on 4/1/24.
//

import Foundation


//
//  ListViewModel.swift
//  GameTracker
//
//  Created by Henry Wertz on 4/1/24.
//

import Foundation
import FirebaseCore
import FirebaseFirestore

@MainActor
class ListViewModel: ObservableObject {
    @Published var currentList: GameList? = nil
    
    
    func createList(userId: String, initialGames: [String], title: String, isPublic: Bool) async throws {
        try await UserManager.shared.createList(userId: userId, initialGames: initialGames, title: title, isPublic: isPublic)
    }
    
    func fetchUserLists() {
        
    }
    
    
}
