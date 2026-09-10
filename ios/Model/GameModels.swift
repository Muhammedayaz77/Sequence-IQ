import Foundation

enum Difficulty: String, CaseIterable, Codable, Identifiable {
    case easy = "Easy", hard = "Hard", master = "Master"
    var id: String { rawValue }
}

enum AppScreen: Equatable { case splash, home, difficulty, levels, game, complete, gameOver, settings, shop, achievements, stats, comingSoon }

struct Puzzle: Codable, Equatable {
    let difficulty: Difficulty
    let level: Int
    let sequence: [Int?]
    let answer: Int
    let options: [Int]
}

@MainActor final class GameModel: ObservableObject {
    @Published var screen: AppScreen = .splash
    @Published var difficulty: Difficulty = .easy
    @Published var level = 1
    @Published var lives = 3
    @Published var hints = 3
    @Published var hintStage = 0
    @Published var message = ""
    @Published private(set) var completed: Set<String> = []
    @Published private(set) var attempts = 0
    @Published private(set) var correctAnswers = 0

    private let defaults = UserDefaults.standard
    private let completedKey = "sequenceIQ.completed"
    private let hintsKey = "sequenceIQ.hints"
    private let attemptsKey = "sequenceIQ.attempts"
    private let correctKey = "sequenceIQ.correct"

    init() {
        completed = Set(defaults.stringArray(forKey: completedKey) ?? [])
        hints = max(0, defaults.integer(forKey: hintsKey))
        if defaults.object(forKey: hintsKey) == nil { hints = 3 }
        attempts = defaults.integer(forKey: attemptsKey)
        correctAnswers = defaults.integer(forKey: correctKey)
    }

    func start(_ difficulty: Difficulty, _ level: Int) {
        guard canPlay(difficulty, level) else { return }
        self.difficulty = difficulty; self.level = level; lives = 3; hintStage = 0; message = ""; screen = .game
    }

    func open(_ difficulty: Difficulty) -> Bool {
        switch difficulty {
        case .easy: return true
        case .hard: return completedCount(.easy) == 20
        case .master: return completedCount(.hard) == 20
        }
    }

    func canPlay(_ difficulty: Difficulty, _ level: Int) -> Bool {
        guard open(difficulty), (1...20).contains(level) else { return false }
        return level == 1 || completed.contains(key(difficulty, level - 1))
    }

    func puzzle() -> Puzzle {
        let a = level + 1
        switch difficulty {
        case .easy: return Puzzle(difficulty: difficulty, level: level, sequence: [a,a+2,a+4,a+6,nil,a+10], answer: a+8, options: [a+8,a+12,a+4,a+14])
        case .hard: return Puzzle(difficulty: difficulty, level: level, sequence: [a,a*2,a*4,a*8,nil,a*32], answer: a*16, options: [a*16,a*12,a*24,a*32])
        case .master: return Puzzle(difficulty: difficulty, level: level, sequence: [a,a+3,a+8,a+15,nil,a+35], answer: a+24, options: [a+24,a+31,a+21,a+36])
        }
    }

    func answer(_ value: Int) {
        guard screen == .game else { return }
        attempts += 1
        if value == puzzle().answer {
            correctAnswers += 1; completed.insert(key(difficulty, level)); persist(); screen = .complete
        } else {
            lives -= 1; message = lives == 0 ? "Game Over" : "Try again."
            persist(); if lives == 0 { screen = .gameOver }
        }
    }

    func useHint() { guard hints > 0, hintStage < 3 else { return }; hints -= 1; hintStage += 1; persist() }
    func retry() { start(difficulty, level) }
    func next() { if level < 20, completed.contains(key(difficulty, level)) { start(difficulty, level + 1) } }
    func completedCount(_ d: Difficulty) -> Int { completed.filter { $0.hasPrefix("\(d.rawValue)-") }.count }
    func isCompleted(_ d: Difficulty, _ l: Int) -> Bool { completed.contains(key(d,l)) }
    private func key(_ d: Difficulty, _ l: Int) -> String { "\(d.rawValue)-\(l)" }
    private func persist() {
        defaults.set(Array(completed), forKey: completedKey); defaults.set(hints, forKey: hintsKey); defaults.set(attempts, forKey: attemptsKey); defaults.set(correctAnswers, forKey: correctKey)
    }
}
