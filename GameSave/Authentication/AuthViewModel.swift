//
//  AuthViewModel.swift
//  GameTracker
//
//  Created by Henry Wertz on 3/11/24.
//

import Foundation


@MainActor
final class AuthViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var display_name = ""
    func signUp() async throws -> AuthDataResultModel? {
        // password validation can occur here
        guard !email.isEmpty, !password.isEmpty else {
            print("No email or password found.")
            return nil
        }
        
        let authDataResult = try await AuthenticationManager.shared.createUser(email: email, password: password, display_name: display_name)
        guard !display_name.isEmpty else {
            print("No username found.")
            return nil
        }
        
        return authDataResult
        
        
    }
    
    func signIn() async throws -> AuthDataResultModel? {
        // password validation can occur here
        guard !email.isEmpty, !password.isEmpty else {
            print("No email or password found.")
            return nil
        }
        
        return try await AuthenticationManager.shared.signInUser(email: email, password: password)
        
    }
    
    func resetPassword() async throws {
        guard !email.isEmpty else {
            print("No email found.")
            return
        }
        
        try await AuthenticationManager.shared.resetPassword(email: email)
    }
    
    
    
}
