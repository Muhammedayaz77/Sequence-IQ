# Web V2 — Separate Screen Views

Each screen is an independent View responsibility. The current approved 12-screen set is locked by the repository final-design rules.

1. Splash Screen — `SplashView`
2. Home Screen — `HomeView`
3. Difficulty Select — `DifficultySelectView`
4. Level Map (Easy) — `LevelMapView`
5. Gameplay Screen — `GameplayView`
6. Level Complete — `LevelCompleteView`
7. Game Over — `GameOverView`
8. Settings — `SettingsView`
9. Shop — `ShopView`
10. Achievements — `AchievementsView`
11. Stats — `StatsView`
12. Coming Soon — `ComingSoonView`

No screen may be represented by accidental overflow/stacking of another screen.