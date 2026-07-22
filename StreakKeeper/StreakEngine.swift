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


struct StreakEngine {
    let calender: Calendar
    var freezeTokens = 3
    
    func currentStreak(from dates: [Date], asOf referenceDate: Date = .now) -> Int {
        let completedDays = Set(dates.map { calender.startOfDay(for: $0) })
        var cursor = calender.startOfDay(for: referenceDate)
        var tokensRemaining = freezeTokens
        
        if !completedDays.contains(cursor) {
            cursor = calender.date(byAdding: .day, value: -1, to: cursor)!
        }
        
        var streak = 0
        while true {
            if completedDays.contains(cursor) {
                streak += 1
            } else if tokensRemaining > 0 {
                tokensRemaining -= 1
            } else {
                break
            }
            
            cursor = calender.date(byAdding: .day, value: -1, to: cursor)!
        }
        
        return streak
    }
}
