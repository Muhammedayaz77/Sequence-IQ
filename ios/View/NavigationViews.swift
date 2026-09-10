import SwiftUI

struct SplashView: View {
    @State private var ready = false
    var body: some View { VStack(spacing: 18) { Text("🧠").font(.system(size: 74)); Text("SEQUENCE\nIQ").font(.system(size: 46, weight: .black)).multilineTextAlignment(.center); Text("Find the Pattern\nBoost Your Brain").multilineTextAlignment(.center); ProgressView("Loading...") }.task { try? await Task.sleep(for: .seconds(1.5)); ready = true }.onChange(of: ready) { _, value in if value { } } }
}

struct HomeView: View {
    @ObservedObject var game: GameModel
    var body: some View { VStack(spacing: 18) { Spacer(); Text("🧠").font(.system(size: 72)); Text("SEQUENCE\nIQ").font(.system(size: 44, weight: .black)).multilineTextAlignment(.center); Text("Find the Pattern\nBoost Your Brain"); Button("▶  PLAY") { game.screen = .difficulty }.gameButton(); HStack { Button("SHOP") { game.screen = .shop }; Button("PLAY") { game.screen = .difficulty }; Button("SOON") { game.screen = .comingSoon } }.buttonStyle(.bordered); Spacer(); Text("“Small Steps\nMake a Sharper Mind”").multilineTextAlignment(.center) }.padding(22) }
}

struct DifficultyView: View {
    @ObservedObject var game: GameModel
    var body: some View { VStack(spacing: 18) { ScreenHeader(title: "Choose Difficulty") { game.screen = .home }; ForEach(Difficulty.allCases) { d in Button { if game.open(d) { game.difficulty = d; game.screen = .levels } } label: { VStack { Text(d.rawValue).font(.title2.bold()); Text(game.open(d) ? "\(game.completedCount(d))/20 completed" : "🔒 Complete previous difficulty") } }.gameButton().disabled(!game.open(d)) }; Spacer() }.padding(22) }
}

struct LevelMapView: View {
    @ObservedObject var game: GameModel
    var body: some View { VStack(spacing: 14) { ScreenHeader(title: "\(game.difficulty.rawValue) Levels") { game.screen = .difficulty }; HStack { ForEach(Difficulty.allCases) { d in Button(d.rawValue) { if game.open(d) { game.difficulty = d } }.disabled(!game.open(d)) } }.buttonStyle(.borderedProminent); ScrollView { LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 14) { ForEach(1...20, id: \.self) { i in let playable = game.canPlay(game.difficulty,i); Button { game.start(game.difficulty,i) } label: { VStack(spacing: 5) { Text("\(i)").font(.title3.bold()); Text(game.isCompleted(game.difficulty,i) ? "★ ★ ★" : playable ? "CURRENT" : "🔒").font(.caption) }.frame(maxWidth: .infinity).padding(.vertical, 18) }.buttonStyle(.borderedProminent).disabled(!playable) } } }.scrollIndicators(.hidden) } .padding(18) }
}

struct ScreenHeader: View { let title: String; let back: () -> Void; var body: some View { HStack { Button("‹") { back() }.font(.largeTitle); Spacer(); Text(title).font(.title2.bold()); Spacer(); Color.clear.frame(width: 30) } }
}
