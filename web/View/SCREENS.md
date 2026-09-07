# Web V2 — Final 12-Screen Verification Map

Each approved screen is implemented as an independent View and is shown/hidden by `AppController`. Only one primary screen is active at a time; screen scroll positions are reset when navigating.

1. Splash Screen — `SplashView`
2. Home Screen — `HomeView`
3. Difficulty Select — `DifficultyView`
4. Level Map (Easy) — `LevelMapView`
5. Gameplay Screen — `GameplayView`
6. Level Complete — `LevelCompleteView`
7. Game Over — `GameOverView`
8. Settings — `SettingsView`
9. Shop — `ShopView`
10. Achievements — `AchievementsView`
11. Stats — `StatsView`
12. Coming Soon — `ComingSoonView`

## Verified flow targets

Splash → Home → Difficulty → Level Map → Gameplay

Gameplay → Level Complete → Next Level → Gameplay

Gameplay → Game Over → Retry / Level Map / Home

Home → Settings / Shop / Achievements / Stats / Coming Soon

Level Map → Difficulty → Home

Every back/home action returns to a real parent screen; no screen is represented by accidental overflow or stacked page content.

## Test note

This repository update is prepared for owner testing of the Web implementation. Native iOS/Android project source remains independently organized and is not claimed build-verified by this document.
