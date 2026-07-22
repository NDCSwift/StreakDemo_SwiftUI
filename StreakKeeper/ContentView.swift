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
    @Query(sort: \Completion.date) private var completions: [Completion]
    @Environment(\.modelContext) private var modelContext
    private let engine = StreakEngine(calender: .current)
    
    private var currentStreak: Int {
        engine.currentStreak(from: completions.map(\.date))
    }
    
    private var last30Days: [Date] {
        (0..<30).compactMap {
            Calendar.current.date(byAdding: .day, value: -$0, to: .now)
        } .reversed()
    }
    private var completedDays: Set<Date> {
        Set(completions.map { Calendar.current.startOfDay(for: $0.date) })
    }
    
    var body: some View {
       
        VStack{
            Image(systemName: "flame.fill")
                .font(.system(size: 80))
                .foregroundStyle(.orange)
                .symbolEffect(.pulse, isActive: currentStreak > 0)
            
            Text("\(currentStreak)")
                .font(.system(size: 64))
                .fontWeight(.bold)
                .contentTransition(.numericText())
            
            Button("Mark Today Done") {
                modelContext.insert(Completion(date: .now))
            }
            .buttonStyle(.borderedProminent)
            .padding()
            
            Text("Streak Calendar")
                .font(.title)
                .padding()
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 6) {
                ForEach(last30Days, id: \.self) { day in
                RoundedRectangle(cornerRadius: 16)
                        .fill(completedDays.contains(Calendar.current.startOfDay(for: day)) ? .orange : .secondary.opacity(0.2))
                        .frame(height: 28)
                }
            
            }
        }
//        .onAppear {
//            modelContext.insert(Completion(date: .now))
//        }
        
    }
}

#Preview {
    ContentView()
}
