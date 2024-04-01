//
//  ProfileViewModel.swift
//  GameTracker
//
//  Created by Henry Wertz on 3/31/24.
//

import Foundation

@MainActor
final class ProfileViewModel: ObservableObject {
    @Published private(set) var user: AuthDataResultModel? = nil
    @Published var userGameLibrary: [Game] = []
    @Published var userGameLogLibrary: [GameLog] = []
    
    func loadCurrentUser() async throws {
        self.user = try AuthenticationManager.shared.getAuthenticatedUser()
    }
    
    func fetchUserGameLibrary(userId: String) async throws {
        let fetchedUserGameLibrary = try await UserManager.shared.getGameLibrary(userId: userId)
        self.userGameLibrary = fetchedUserGameLibrary.gameData
        self.userGameLogLibrary = fetchedUserGameLibrary.gameLibraryData
    }
}


