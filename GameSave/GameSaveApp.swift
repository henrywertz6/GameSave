//
//  GameTrackerApp.swift
//  GameTracker
//
//  Created by Henry Wertz on 2/19/24.
//

import SwiftUI
import FirebaseCore
@main
struct GameSaveApp: App {
    init() {
        FirebaseApp.configure()
    }
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
