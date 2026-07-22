//
        //
    //  Project: StreakKeeper
    //  File: StreakKeeperApp.swift
    //  Created by Noah Carpenter 
    //
    //  📺 YouTube: Noah Does Coding
    //  https://www.youtube.com/@NoahDoesCoding
    //  Like and Subscribe for coding tutorials and fun! 💻✨
    //  Dream Big. Code Bigger 🚀
    //

    

import SwiftUI
import SwiftData

// MARK: - StreakKeeperApp
//
// The app's entry point. `@main` marks this as where the program starts.
@main
struct StreakKeeperApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        // `.modelContainer(for:)` sets up SwiftData's persistent store for
        // the `Completion` model and injects a `modelContext` into the
        // environment for every view in this scene — which is exactly what
        // ContentView reads via `@Environment(\.modelContext)` and what
        // powers its `@Query`.
        .modelContainer(for: Completion.self)
    }
}
