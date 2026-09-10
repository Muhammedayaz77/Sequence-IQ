import SwiftUI

@main struct SequenceIQApp: App { var body: some Scene { WindowGroup { RootView() } } }

struct RootView: View {
    @StateObject private var game = GameModel()
    var body: some View {
        ZStack { GameBackground(); Group { switch game.screen { case .splash: SplashView(); case .home: HomeView(game: game); case .difficulty: DifficultyView(game: game); case .levels: LevelMapView(game: game); case .game: GameplayView(game: game); case .complete: LevelCompleteView(game: game); case .gameOver: GameOverView(game: game); case .settings: SettingsView(game: game); case .shop: ShopView(game: game); case .achievements: AchievementsView(game: game); case .stats: StatsView(game: game); case .comingSoon: ComingSoonView(game: game) } } }.task { try? await Task.sleep(for: .seconds(1.5)); if game.screen == .splash { game.screen = .home } }.preferredColorScheme(.dark)
    }
}

struct GameBackground: View { var body: some View { LinearGradient(colors: [.blue.opacity(0.55), .indigo, .black], startPoint: .top, endPoint: .bottom).ignoresSafeArea() } }
struct GameButton: ViewModifier { func body(content: Content) -> some View { content.font(.headline.bold()).foregroundStyle(.white).frame(maxWidth: .infinity).padding(.vertical, 14).background(RoundedRectangle(cornerRadius: 16).fill(.blue.gradient)).overlay(RoundedRectangle(cornerRadius: 16).stroke(.white.opacity(0.15))) } }
extension View { func gameButton() -> some View { modifier(GameButton()) } }
