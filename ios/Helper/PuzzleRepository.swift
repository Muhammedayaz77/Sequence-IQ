import Foundation

enum PuzzleRepository {
    static func load() -> [Puzzle] {
        guard let url = Bundle.main.url(forResource: "Puzzles", withExtension: "txt"),
              let text = try? String(contentsOf: url) else {
            return []
        }

        var puzzles: [Puzzle] = []
        var keys = Set<String>()

        for line in text.split(whereSeparator: \.isNewline) {
            let parts = line.split(separator: "|", omittingEmptySubsequences: false).map(String.init)
            guard parts.count == 5, !parts[0].trimmingCharacters(in: .whitespaces).hasPrefix("#"),
                  let difficulty = Difficulty(rawValue: parts[1].trimmingCharacters(in: .whitespaces)),
                  let level = Int(parts[0].trimmingCharacters(in: .whitespaces).dropFirst()),
                  (1...20).contains(level), let answer = Int(parts[4].trimmingCharacters(in: .whitespaces)) else {
                continue
            }

            let sequence = parts[2].split(separator: ",").map {
                let value = $0.trimmingCharacters(in: .whitespaces)
                return value == "?" ? nil : Int(value)
            }
            let options = parts[3].split(separator: ",").compactMap {
                Int($0.trimmingCharacters(in: .whitespaces))
            }
            let key = "\(difficulty.rawValue)-\(level)"

            guard sequence.count == 6, sequence.filter({ $0 == nil }).count == 1,
                  options.count == 4, Set(options).count == 4, options.contains(answer),
                  keys.insert(key).inserted else {
                continue
            }
            puzzles.append(Puzzle(difficulty: difficulty, level: level, sequence: sequence, answer: answer, options: options))
        }

        guard puzzles.count == 60 else { return [] }
        let required = Set(Difficulty.allCases.flatMap { difficulty in
            (1...20).map { "\(difficulty.rawValue)-\($0)" }
        })
        guard Set(puzzles.map { "\($0.difficulty.rawValue)-\($0.level)" }) == required else { return [] }

        return puzzles.sorted {
            ($0.difficulty.rawValue, $0.level) < ($1.difficulty.rawValue, $1.level)
        }
    }

    static func puzzle(difficulty: Difficulty, level: Int) -> Puzzle {
        guard let puzzle = load().first(where: { $0.difficulty == difficulty && $0.level == level }) else {
            fatalError("Missing puzzle: \(difficulty) level \(level)")
        }
        return puzzle
    }
}
