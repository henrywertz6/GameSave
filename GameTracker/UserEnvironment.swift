//
//  UserEnvironment.swift
//  GameTracker
//
//  Created by Henry Wertz on 3/18/24.
//

import Foundation
import FirebaseFirestore

@MainActor class UserEnvironment: ObservableObject {
    @Published var user: AuthDataResultModel? = nil
    @Published var library: Set<String> = []
    @Published var reviews: Set<String> = []
    
    
    func createSet() async {
        do {
            library = try await UserManager.shared.getUserLibraryId(userId: user!.uid)
        }
        catch {
            print(error)
        }
        
    }
    
    func createReviewSet() async {
        do {
            reviews = try await UserManager.shared.getUserReviewSet(userId: user!.uid)
        }
        catch {
            print(error)
        }
    }
    
    
}
