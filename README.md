# 🔥 StreakKeeper

A small SwiftUI + SwiftData demo app that tracks daily habit streaks, complete with an optional "freeze token" mechanic for forgiving missed days.

---

## 🤔 What this is

StreakKeeper is a minimal habit-streak tracker: tap a button to mark today done, and watch a flame counter and a 30-day calendar grid update live. It's built to demonstrate deriving UI state (the streak count) from persisted data (`Completion` records) instead of storing and syncing a separate counter, plus a heavily-commented look at how "streak freezes" work as an optional product decision rather than a required part of streak math.

## ✅ Why you'd use it

- **Derived state pattern** — the streak count is computed live from SwiftData `@Query` results every time the data changes, so there's nothing to keep in sync and nothing that can drift out of date.
- **SwiftData basics** — a minimal `@Model` class and `@Query`/`@Environment(\.modelContext)` wiring show persistence with almost no boilerplate.
- **Freeze tokens as a design pattern** — `StreakEngine.swift` walks through what a "streak freeze" actually does, why it's optional, and what changes are needed to make it production-ready (persistence, permanent decrementing, StoreKit, etc.).

## 📺 Watch on YouTube

[![Watch on YouTube](https://img.shields.io/badge/YouTube-Watch%20the%20Tutorial-red?style=for-the-badge&logo=youtube)](https://youtube.com/watch?v=PLACEHOLDER)

> This project was built for the [NoahDoesCoding YouTube channel](https://www.youtube.com/@NoahDoesCoding).

---

## 🚀 Getting Started

### 1. Clone
```bash
git clone https://github.com/NDCSwift/StreakDemo_SwiftUI.git
cd StreakDemo_SwiftUI
```

### 2. Open
Open `StreakKeeper.xcodeproj` in Xcode.

### 3. Team
Select your Apple Developer team under **Signing & Capabilities** for the `StreakKeeper` target.

### 4. Bundle ID
Update the bundle identifier if needed — it currently defaults to `com.example.StreakKeeper`.

## 🛠️ Notes

- The core streak-counting logic lives in `StreakEngine.swift` and has no SwiftUI or SwiftData dependencies, so it's easy to read (and test) on its own.
- Freeze tokens are a **design choice**, not a requirement — they default to 3 per `StreakEngine` and reset every time one is created, which is fine for a demo but not for production. See the inline comments for what persisting them properly would look like.
- Every file has inline comments aimed at people learning SwiftUI and SwiftData for the first time.

## 📦 Requirements

- Xcode 26+
- iOS 26+
- Swift 6

📺 [Watch the guide on YouTube](https://youtube.com/watch?v=PLACEHOLDER)
