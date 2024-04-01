//
//  AuthenticationManager.swift
//  GameTracker
//
//  Created by Henry Wertz on 2/27/24.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
struct AuthDataResultModel {
    let uid: String
    let email: String?
    let photoUrl: String?
    var display_name: String?
    
    
    init(user: FirebaseAuth.User) {
        self.uid = user.uid
        self.email = user.email
        self.photoUrl = user.photoURL?.absoluteString
        self.display_name = user.displayName
    }
}
final class AuthenticationManager {
    
    private let auth = Auth.auth()
    
    static let shared = AuthenticationManager()
    private init() {
        
    }
    func getAuthenticatedUser() throws -> AuthDataResultModel {
        guard let user = auth.currentUser else {
            throw URLError(.badServerResponse)
        }
        return AuthDataResultModel(user: user)
    }
    
    @discardableResult
    func createUser(email: String, password: String, display_name: String) async throws -> AuthDataResultModel {
        try await auth.createUser(withEmail: email, password: password)
        let changeRequest = auth.currentUser?.createProfileChangeRequest()
        changeRequest?.displayName = display_name
        try await changeRequest?.commitChanges()
        
        return try getAuthenticatedUser()
    }
    @discardableResult
    func signInUser(email: String, password: String) async throws -> AuthDataResultModel {
        let authDataResult = try await auth.signIn(withEmail: email, password: password)
        return AuthDataResultModel(user: authDataResult.user)
    }
    
    func resetPassword(email: String) async throws {
        try await auth.sendPasswordReset(withEmail: email)
    }
    
    func signOut() throws {
        try Auth.auth().signOut()
    }
    
//    func doesUserExist(email: String) async throws -> Bool {
//        let auth = Auth.auth()
//        do {
//            let signInMethods = try await auth.fe
//            return !signInMethods.isEmpty // User exists if there are sign-in methods
//        } catch {
//            throw error // Re-throw caught error
//        }
//    }
    
}
