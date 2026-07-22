//
        //
    //  Project: StreakKeeper
    //  File: ContentView.swift
    //  Created by Noah Carpenter 
    //
    //  📺 YouTube: Noah Does Coding
    //  https://www.youtube.com/@NoahDoesCoding
    //  Like and Subscribe for coding tutorials and fun! 💻✨
    //  Dream Big. Code Bigger 🚀
    //

    

import SwiftUI
import SwiftData
import Foundation

struct ContentView: View {
    // @Query is SwiftData's live-fetching property wrapper: it pulls every
    // `Completion` from the model container, sorted by date, and — because
    // it's backed by the same modelContext everything else here uses —
    // automatically re-runs and refreshes this view whenever a `Completion`
    // is inserted or deleted. No manual "reload" step needed.
    @Query(sort: \Completion.date) private var completions: [Completion]
    // The SwiftData context for this view's environment; used below to
    // insert new `Completion` records when the user taps the button.
    @Environment(\.modelContext) private var modelContext
    // One `StreakEngine` per `ContentView` instance. Because `freezeTokens`
    // defaults to 3 on every new engine (see StreakEngine.swift), this is
    // exactly the kind of place a production app would instead read a
    // persisted token count from disk/backend, rather than getting a fresh
    // budget for free each time the view is recreated.
    private let engine = StreakEngine(calender: .current)

    // Recomputed every time `body` runs (i.e. whenever `completions`
    // changes, thanks to @Query). This is what keeps the on-screen streak
    // number always in sync with the underlying data — see the note in
    // Completion.swift about deriving rather than storing the streak.
    private var currentStreak: Int {
        engine.currentStreak(from: completions.map(\.date))
    }

    // Builds the last 30 calendar days, oldest first, for the grid below.
    private var last30Days: [Date] {
        (0..<30).compactMap {
            Calendar.current.date(byAdding: .day, value: -$0, to: .now)
        } .reversed()
    }
    // A Set of just the calendar-day (midnight-normalized) dates that have
    // a completion, so the grid can do an O(1) "is this day filled in?"
    // check per cell instead of scanning `completions` 30 times.
    private var completedDays: Set<Date> {
        Set(completions.map { Calendar.current.startOfDay(for: $0.date) })
    }
    
    var body: some View {

        VStack{
            // The flame "lights up" (pulses) only while there's an active
            // streak — a small bit of animated feedback tied directly to
            // `currentStreak > 0`, no separate state variable needed.
            Image(systemName: "flame.fill")
                .font(.system(size: 80))
                .foregroundStyle(.orange)
                .symbolEffect(.pulse, isActive: currentStreak > 0)

            // `.contentTransition(.numericText())` gives the streak count a
            // smooth rolling-digit animation whenever it changes, instead of
            // an abrupt swap — a nice free polish effect for numbers.
            Text("\(currentStreak)")
                .font(.system(size: 64))
                .fontWeight(.bold)
                .contentTransition(.numericText())

            // Inserting into `modelContext` is all that's needed — SwiftData
            // saves it, and the `@Query` above automatically notices the
            // change and re-renders this view with the updated streak.
            Button("Mark Today Done") {
                modelContext.insert(Completion(date: .now))
            }
            .buttonStyle(.borderedProminent)
            .padding()

            Text("Streak Calendar")
                .font(.title)
                .padding()
            // A simple 30-day heat-map style grid: one tile per day, filled
            // orange if that day has a completion. Note this grid doesn't
            // visually distinguish "completed" from "covered by a freeze
            // token" — a production app would likely want a third visual
            // state (e.g. a snowflake icon) so users can see which of their
            // freezes got spent and where.
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 6) {
                ForEach(last30Days, id: \.self) { day in
                RoundedRectangle(cornerRadius: 16)
                        .fill(completedDays.contains(Calendar.current.startOfDay(for: day)) ? .orange : .secondary.opacity(0.2))
                        .frame(height: 28)
                }

            }
        }
        // Sample debug code, left commented out: seeds a completion for
        // "today" as soon as the view appears, handy for quickly eyeballing
        // the streak UI while developing without tapping the button.
//        .onAppear {
//            modelContext.insert(Completion(date: .now))
//        }

    }
}

#Preview {
    ContentView()
}
