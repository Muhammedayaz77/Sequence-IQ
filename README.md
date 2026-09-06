# Sequence IQ

> **A Number Series & Logic Puzzle Game**

Sequence IQ is a puzzle game built around number-series challenges, pattern recognition, and logical thinking. Players progress through increasingly difficult puzzle levels, identify the underlying sequence, and select the correct answer from multiple choices.

## Ownership

**Sequence IQ is developed and owned by Hind Tech Group (HTG).**

This repository contains the source and project assets for the Sequence IQ game. The project is being developed with independent implementations for iOS, Android, and Web.

## V1 Overview

Version 1 includes three difficulty groups:

- **Easy** — 20 levels
- **Hard** — 20 levels
- **Master** — 20 levels

That gives V1 a total of **60 levels**.

Each level contains one number-series puzzle with four answer options: one correct answer and three incorrect answers.

### Progression

- Easy is available from the beginning.
- Hard unlocks after completing Easy.
- Master unlocks after completing Hard.
- Completed levels remain available for replay.
- Level selection uses a visual progression path.

### Lives

- Players start with **3 lives**.
- Only an incorrect answer consumes a life.
- Hints do not consume lives.
- The game ends after the third incorrect answer.

### Hint System

Each puzzle supports staged hints:

1. **Hint 1:** removes two incorrect options, leaving one incorrect and one correct option.
2. **Hint 2:** removes the remaining incorrect option, leaving only the correct answer.
3. **Hint 3:** reveals the final answer.

## Home Experience

The main home experience contains three areas:

- **Shop** — includes a daily free hint that can be collected once per day while online.
- **Play** — provides Open Play and level selection.
- **Coming Soon** — reserved for future content and features.

## Account & Connection

Sequence IQ uses **Connect** terminology rather than Login.

Supported connection methods in V1:

- Connect with Facebook
- Connect with Email

Each connection method provides **5 free hints once**. Disconnecting and reconnecting does not allow the reward to be claimed repeatedly.

Connected players have an account ID that can be used for progress synchronization.

## Online & Offline Support

Sequence IQ is designed to remain playable without an internet connection.

**Offline:**

- Puzzle gameplay
- Local progress
- Level unlocking and completion
- Settings
- Locally available hints

**Online required:**

- Account connection
- Cloud progress synchronization
- Daily free hint claim

## Settings

Music and Sound are controlled independently:

- Music ON/OFF
- Sound ON/OFF

## Puzzle Content

Puzzle content is stored in `.txt` files and is intentionally kept outside of a database.

Each platform maintains its own puzzle file so that iOS, Android, and Web implementations remain independent.

## Platform Architecture

The repository is organized into three independent platform implementations:

```text
Sequence-IQ/
├── GAME_RULES.txt
├── README.md
├── ios/
│   └── Puzzles.txt
├── android/
│   └── Puzzles.txt
└── web/
    └── Puzzles.txt
```

The platforms must not depend on a shared cross-platform runtime or shared application code. Each platform is developed and deployed independently.

## V1 Scope

V1 intentionally focuses on the core number-series puzzle experience. Features such as leaderboards, multiplayer, daily challenges, timed modes, endless modes, additional puzzle categories, social sharing, paid hint packs, notifications, and the V2 three-star system are outside the V1 scope unless separately approved.

## Project Rules

The complete permanent project rules and finalized V1 decisions are maintained in [`GAME_RULES.txt`](GAME_RULES.txt). That file is the source of truth for future development and project continuity.

## Status

**Version:** V1

**Repository:** Public development repository.

## Web Game

🎮 **Play Sequence IQ on the Web:**

https://muhammedayaz77.github.io/Sequence-IQ/

---

© Hind Tech Group (HTG). All rights reserved.
