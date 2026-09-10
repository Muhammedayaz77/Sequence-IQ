import SwiftUI

struct GameplayView: View {
    @ObservedObject var game: GameModel

    var body: some View {
        let puzzle = game.puzzle()
        VStack(spacing: 16) {
            ScreenHeader(title: "\(puzzle.difficulty) · Level \(puzzle.level)") { game.screen = .levels }
            HStack { Text("♥︎ \(game.lives)"); Spacer(); Text("💡 \(game.hints)") }
            Text("Find the next number").font(.headline)
            HStack(spacing: 8) {
                ForEach(Array(puzzle.sequence.enumerated()), id: \.offset) { _, number in
                    Text(number.map(String.init) ?? "?")
                        .font(.title3.bold()).frame(maxWidth: .infinity).padding(.vertical, 18)
                        .background(.ultraThinMaterial).clipShape(RoundedRectangle(cornerRadius: 12))
                }
            }
            if game.hintStage > 0 {
                Text(hintText(puzzle)).font(.subheadline).frame(maxWidth: .infinity).padding()
                    .background(.thinMaterial).clipShape(RoundedRectangle(cornerRadius: 12))
            }
            ForEach(game.visibleOptions(), id: \.self) { number in
                Button("\(number)") { game.answer(number) }.gameButton()
            }
            HStack {
                Button("💡 Hint (\(game.hints))") { game.useHint() }
                    .disabled(game.hints == 0 || game.hintStage >= 3)
                Button("↻ Restart") { game.retry() }
            }
            if !game.message.isEmpty { Text(game.message).foregroundStyle(.secondary) }
            Spacer()
        }.padding(20)
    }

    private func hintText(_ puzzle: Puzzle) -> String {
        switch game.hintStage {
        case 1: return "Hint 1: One incorrect choice remains."
        case 2: return "Hint 2: Only the correct choice remains."
        default: return "Hint 3: Answer is \(puzzle.answer)."
        }
    }
}

struct LevelCompleteView: View {
    @ObservedObject var game: GameModel
    var body: some View {
        VStack(spacing: 18) {
            Spacer(); Text("🏆").font(.system(size: 72)); Text("LEVEL COMPLETE").font(.caption.bold())
            Text("Excellent!").font(.largeTitle.bold()); Text("★ ★ ★").font(.title).foregroundStyle(.yellow)
            if game.level < 20 { Button("NEXT LEVEL ›") { game.next() }.gameButton() }
            Button("LEVEL MAP") { game.screen = .levels }.gameButton()
            Button("HOME") { game.screen = .home }.buttonStyle(.bordered); Spacer()
        }.padding(22)
    }
}

struct GameOverView: View {
    @ObservedObject var game: GameModel
    var body: some View {
        VStack(spacing: 18) {
            Spacer(); Text("💥").font(.system(size: 72)); Text("GAME OVER").font(.caption.bold()); Text("Try Again!").font(.largeTitle.bold())
            Text("You used all 3 lives."); Button("↻ RETRY") { game.retry() }.gameButton()
            Button("LEVEL MAP") { game.screen = .levels }.gameButton(); Button("HOME") { game.screen = .home }.buttonStyle(.bordered); Spacer()
        }.padding(22)
    }
}
