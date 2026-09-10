import Foundation
import Combine

enum Difficulty: String, CaseIterable, Codable, Identifiable {
    case easy = "Easy"
    case hard = "Hard"
    case master = "Master"
    var id: String { rawValue }
}

enum AppScreen: Equatable {
    case splash, home, difficulty, levels, game, complete, gameOver, settings, shop, achievements, stats, comingSoon
}

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
    @Published var musicOn: Bool
    @Published var soundOn: Bool

    private let defaults = UserDefaults.standard
    private let puzzles: [Puzzle]

    init() {
        completed = Set(defaults.stringArray(forKey: "sequenceIQ.completed") ?? [])
        hints = defaults.object(forKey: "sequenceIQ.hints") as? Int ?? 3
        attempts = defaults.integer(forKey: "sequenceIQ.attempts")
        correctAnswers = defaults.integer(forKey: "sequenceIQ.correct")
        musicOn = defaults.object(forKey: "sequenceIQ.music") as? Bool ?? true
        soundOn = defaults.object(forKey: "sequenceIQ.sound") as? Bool ?? true
        puzzles = PuzzleRepository.load()
    }

    func start(_ difficulty: Difficulty, _ level: Int) {
        guard canPlay(difficulty, level) else { return }
        self.difficulty = difficulty
        self.level = level
        lives = 3
        hintStage = 0
        message = ""
        screen = .game
    }

    func open(_ difficulty: Difficulty) -> Bool {
        switch difficulty {
        case .easy: return true
        case .hard: return completedCount(.easy) == 20
        case .master: return completedCount(.hard) == 20
        }
    }

    func canPlay(_ difficulty: Difficulty, _ level: Int) -> Bool {
        open(difficulty) && (1...20).contains(level) && (level == 1 || completed.contains(key(difficulty, level - 1)))
    }

    func puzzle() -> Puzzle {
        puzzles.first { $0.difficulty == difficulty && $0.level == level }
            ?? PuzzleRepository.puzzle(difficulty: difficulty, level: level)
    }

    func visibleOptions() -> [Int] {
        let current = puzzle()
        switch hintStage {
        case 0:
            return current.options
        case 1:
            return [current.answer, current.options.first(where: { $0 != current.answer }) ?? current.answer]
        default:
            return [current.answer]
        }
    }

    func answer(_ value: Int) {
        guard screen == .game else { return }
        attempts += 1
        if value == puzzle().answer {
            correctAnswers += 1
            completed.insert(key(difficulty, level))
            persist()
            screen = .complete
        } else {
            lives -= 1
            message = lives == 0 ? "Game Over" : "Try again."
            persist()
            if lives == 0 { screen = .gameOver }
        }
    }

    func useHint() {
        guard hints > 0, hintStage < 3 else { return }
        hints -= 1
        hintStage += 1
        persist()
    }

    func setMusic(_ on: Bool) {
        musicOn = on
        defaults.set(on, forKey: "sequenceIQ.music")
    }

    func setSound(_ on: Bool) {
        soundOn = on
        defaults.set(on, forKey: "sequenceIQ.sound")
    }

    func retry() { start(difficulty, level) }

    func next() {
        if level < 20, completed.contains(key(difficulty, level)) {
            start(difficulty, level + 1)
        }
    }

    func completedCount(_ difficulty: Difficulty) -> Int {
        completed.filter { $0.hasPrefix("\(difficulty.rawValue)-") }.count
    }

    func isCompleted(_ difficulty: Difficulty, _ level: Int) -> Bool {
        completed.contains(key(difficulty, level))
    }

    private func key(_ difficulty: Difficulty, _ level: Int) -> String {
        "\(difficulty.rawValue)-\(level)"
    }

    private func persist() {
        defaults.set(Array(completed), forKey: "sequenceIQ.completed")
        defaults.set(hints, forKey: "sequenceIQ.hints")
        defaults.set(attempts, forKey: "sequenceIQ.attempts")
        defaults.set(correctAnswers, forKey: "sequenceIQ.correct")
    }
}
