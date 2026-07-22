//
        //
    //  Project: StreakKeeper
    //  File: Completion.swift
    //  Created by Noah Carpenter 
    //
    //  📺 YouTube: Noah Does Coding
    //  https://www.youtube.com/@NoahDoesCoding
    //  Like and Subscribe for coding tutorials and fun! 💻✨
    //  Dream Big. Code Bigger 🚀
    //

    
import SwiftData
import Foundation

// MARK: - Completion
//
// A SwiftData model representing a single "I did the thing today" event.
// `@Model` is a SwiftData macro that turns this plain class into a
// persisted, database-backed object — no manual Core Data boilerplate.
// Every time the user marks a day as done, one `Completion` gets inserted
// with today's date (see the button action in ContentView).
//
// Notice there's no `streak` property here — the streak count is never
// stored, only *derived* on demand by feeding every `Completion.date` into
// `StreakEngine.currentStreak(from:)`. That's a deliberate choice: with
// nothing to keep in sync, the displayed streak can never drift out of date
// with the underlying completions.
@Model
final class Completion {
    var date: Date
    init(date: Date) {
        self.date = date
    }
}
