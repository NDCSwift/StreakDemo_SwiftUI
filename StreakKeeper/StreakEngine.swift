//
        //
    //  Project: StreakKeeper
    //  File: StreakEngine.swift
    //  Created by Noah Carpenter 
    //
    //  📺 YouTube: Noah Does Coding
    //  https://www.youtube.com/@NoahDoesCoding
    //  Like and Subscribe for coding tutorials and fun! 💻✨
    //  Dream Big. Code Bigger 🚀
    //

    
import Foundation

// MARK: - StreakEngine
//
// The math brain behind the app. This is a plain Swift struct — no SwiftUI,
// no SwiftData — so the streak-counting logic can be reasoned about (and
// unit tested) completely on its own. It answers one question: "given a
// list of completion dates, how many days in a row — ending today or
// yesterday — has the user kept their streak going?"
struct StreakEngine {
    let calender: Calendar

    // MARK: Freeze tokens — an optional, design-level streak mechanic
    //
    // A "freeze" (Duolingo calls it a "streak freeze"/"streak shield") lets
    // a user miss one day without their streak resetting to zero. This is
    // NOT something every streak app needs — plenty of habit trackers use a
    // strict "miss a day, streak breaks" rule instead. Freezes are a
    // deliberate product decision to make the experience feel more
    // forgiving, which is a common lever for improving long-term retention
    // (users don't rage-quit after one bad day).
    //
    // Here it's modeled as the simplest possible thing: an in-memory count
    // that resets to 3 every time a new `StreakEngine` value is created.
    // That's fine for learning/demo purposes, but it means the "remaining
    // tokens" never actually persist or run out across app launches — every
    // fresh `StreakEngine()` gets 3 more. For a production app you'd want to:
    //   1. Persist the remaining token count somewhere durable — a SwiftData
    //      model, UserDefaults, or a backend — instead of a struct property
    //      that lives only as long as the value does.
    //   2. Decrement it permanently at the moment a freeze is actually
    //      spent, rather than recomputing a fresh local budget every time
    //      `currentStreak` runs (see `tokensRemaining` below).
    //   3. Record *which* date got frozen, so recalculating the streak
    //      later doesn't risk spending a second token covering the same gap.
    //   4. Decide the business rules yourself: do tokens regenerate weekly
    //      or monthly? Can they be earned or purchased (StoreKit)? Is there
    //      a max cap? None of this is "correct" vs "incorrect" — it's all
    //      product/UX taste that shapes how forgiving the streak feels.
    var freezeTokens = 3

    /// Walks backward day-by-day from `referenceDate`, counting completed
    /// days as streak, until it hits a gap with no freeze token left to
    /// cover it.
    func currentStreak(from dates: [Date], asOf referenceDate: Date = .now) -> Int {
        // Normalize every completion's timestamp down to just its calendar
        // day (midnight), so "9:00 AM" and "11:45 PM" on the same date both
        // land in the same bucket. `Set` gives us O(1) "was this day done?"
        // lookups instead of scanning the array on every step of the walk.
        let completedDays = Set(dates.map { calender.startOfDay(for: $0) })
        var cursor = calender.startOfDay(for: referenceDate)
        // A local, per-call budget of freezes to spend. Because this is
        // just a copy of `freezeTokens` taken fresh each call, nothing here
        // is actually "used up" between calls — see the design note above.
        var tokensRemaining = freezeTokens

        // If today hasn't been completed yet, don't treat "today" as the
        // miss that breaks the streak — just start counting from yesterday.
        // This is what lets the streak still read as "current" in the UI
        // even before the user has checked off today's task.
        if !completedDays.contains(cursor) {
            cursor = calender.date(byAdding: .day, value: -1, to: cursor)!
        }

        var streak = 0
        while true {
            if completedDays.contains(cursor) {
                // Completed day — extends the streak by one.
                streak += 1
            } else if tokensRemaining > 0 {
                // Missed day, but a freeze token covers it: the streak
                // survives (this day just doesn't add to the count), and
                // one token is spent so we keep walking backward.
                tokensRemaining -= 1
            } else {
                // Missed day with no freeze left to cover it — the streak
                // ends here.
                break
            }

            cursor = calender.date(byAdding: .day, value: -1, to: cursor)!
        }

        return streak
    }
}
