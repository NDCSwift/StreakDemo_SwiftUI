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

@main
struct StreakKeeperApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: Completion.self)
    }
}
