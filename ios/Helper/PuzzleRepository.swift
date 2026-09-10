import Foundation

enum PuzzleRepository {
    static func load() -> [Puzzle] {
        guard let url = Bundle.main.url(forResource: "Puzzles", withExtension: "txt"), let text = try? String(contentsOf: url) else { return [] }
        return text.split(whereSeparator: \.isNewline).compactMap { line in
            let parts = line.split(separator: "|", omittingEmptySubsequences: false).map(String.init)
            guard parts.count == 5, !parts[0].hasPrefix("#"), let difficulty = Difficulty(rawValue: parts[1]), let level = Int(parts[0].dropFirst()), let answer = Int(parts[4]) else { return nil }
            let sequence = parts[2].split(separator: ",").map { $0 == "?" ? nil : Int($0.trimmingCharacters(in: .whitespaces)) }
            let options = parts[3].split(separator: ",").compactMap { Int($0.trimmingCharacters(in: .whitespaces)) }
            guard sequence.count == 6, options.count == 4 else { return nil }
            return Puzzle(difficulty: difficulty, level: level, sequence: sequence, answer: answer, options: options)
        }.sorted { ($0.difficulty.rawValue, $0.level) < ($1.difficulty.rawValue, $1.level) }
    }
    static func puzzle(difficulty: Difficulty, level: Int) -> Puzzle { load().first { $0.difficulty == difficulty && $0.level == level } ?? Puzzle(difficulty: difficulty, level: level, sequence: [nil], answer: 0, options: []) }
}
