//
//  SettingsViewModel.swift
//  GameTracker
//
//  Created by Henry Wertz on 3/11/24.
//

import Foundation


@MainActor
final class SettingsViewModel: ObservableObject {
    
    func signOut() throws {
        try AuthenticationManager.shared.signOut()
    }
    
    func resetPassword() async throws {
        let currUser = try AuthenticationManager.shared.getAuthenticatedUser()
        guard let email = currUser.email else {
            throw URLError(.fileDoesNotExist)
        }
        try await AuthenticationManager.shared.resetPassword(email: email)
    }
}
