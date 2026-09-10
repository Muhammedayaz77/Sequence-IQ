# Sequence IQ

> **A Number Series & Logic Puzzle Game**

Sequence IQ is a puzzle game built around number-series challenges, pattern recognition, and logical thinking. Players progress through increasingly difficult puzzle levels, identify the underlying sequence, and select the correct answer from multiple choices.

## Ownership

**Sequence IQ is developed and owned by Hind Tech Group (HTG).**

This repository contains independent native implementations for **iOS, Android, Windows, and Web**.

## V1 Overview

- Easy — 20 levels
- Hard — 20 levels
- Master — 20 levels
- Total — 60 levels
- Every level has 4 answer options: 1 correct + 3 incorrect.

## Progression

- Easy is available from the beginning.
- Hard unlocks after all 20 Easy levels are completed.
- Master unlocks after all 20 Hard levels are completed.
- Levels must be completed sequentially.
- Completed levels remain available for replay.

## Lives & Hints

Players start with 3 lives. Only an incorrect answer consumes a life. Three incorrect answers cause Game Over. Hints do not consume lives and use the staged Hint 1 → Hint 2 → Hint 3 system defined in `GAME_RULES.txt`.

## Final Visual Design

**FINAL — Owner Approved.** The 12 approved screens and their graphics rules remain the visual source of truth. See `assets/FINAL_DESIGN_STATUS.md`.

## Puzzle Content

Puzzle content remains in independent `Puzzles.txt` files. Native iOS, Android and Windows implementations now load their local platform puzzle data rather than generating replacement puzzle content at runtime.

## Platform Structure

```text
Sequence-IQ/
├── GAME_RULES.txt
├── assets/
├── ios/       # Native SwiftUI / Xcode
├── android/   # Native Kotlin / Android
├── windows/   # Native C# / WPF (.NET 8)
└── web/       # Independent Web implementation
```

Each platform deploys independently and has its own application code and puzzle data. No cross-platform runtime is used.

## Windows

Windows is implemented as a native **WPF + .NET 8** desktop application under `windows/`. It follows the same View / Controller / Model / Helper separation and implements the same Sequence IQ gameplay and 12-screen navigation model.

A GitHub Actions workflow at `.github/workflows/windows-build.yml` builds the Windows project on `windows-latest`.

## Status

**Version:** V2 stabilization / native platform development

**Visual Design:** FINAL — Owner Approved

---

© Hind Tech Group (HTG). All rights reserved.
