import SwiftUI

struct SettingsView: View {
    @ObservedObject var game: GameModel
    @AppStorage("sequenceIQ.music") private var music = true
    @AppStorage("sequenceIQ.sound") private var sound = true
    var body: some View { VStack(spacing: 18) { ScreenHeader(title: "Settings") { game.screen = .home }; Toggle("Music", isOn: $music).padding().background(.thinMaterial).clipShape(RoundedRectangle(cornerRadius: 14)); Toggle("Sound", isOn: $sound).padding().background(.thinMaterial).clipShape(RoundedRectangle(cornerRadius: 14)); Spacer() }.padding(22) }
}

struct ShopView: View {
    @ObservedObject var game: GameModel
    var body: some View { VStack(spacing: 18) { ScreenHeader(title: "Shop") { game.screen = .home }; Text("💡").font(.system(size: 60)); Text("Daily Free Hint").font(.title2.bold()); Text("Collect one free hint while online.\nCloud claim can be connected later.").multilineTextAlignment(.center); Button("CLAIM DAILY HINT") { game.hints += 1 }.gameButton(); Spacer() }.padding(22) }
}

struct AchievementsView: View {
    @ObservedObject var game: GameModel
    var body: some View { VStack(spacing: 16) { ScreenHeader(title: "Achievements") { game.screen = .home }; achievement("First Step", game.completedCount(.easy) >= 1); achievement("Easy Master", game.completedCount(.easy) == 20); achievement("Hard Master", game.completedCount(.hard) == 20); achievement("IQ Champion", game.completedCount(.master) == 20); Spacer() }.padding(22) }
    private func achievement(_ title: String, _ unlocked: Bool) -> some View { HStack { Text(unlocked ? "🏆" : "🔒"); Text(title).font(.headline); Spacer(); Text(unlocked ? "Unlocked" : "Locked").foregroundStyle(.secondary) }.padding().background(.thinMaterial).clipShape(RoundedRectangle(cornerRadius: 14)) }
}

struct StatsView: View {
    @ObservedObject var game: GameModel
    var body: some View { VStack(spacing: 18) { ScreenHeader(title: "Stats") { game.screen = .home }; stat("Easy", game.completedCount(.easy)); stat("Hard", game.completedCount(.hard)); stat("Master", game.completedCount(.master)); stat("Correct Answers", game.correctAnswers); stat("Attempts", game.attempts); Spacer() }.padding(22) }
    private func stat(_ label: String, _ value: Int) -> some View { HStack { Text(label); Spacer(); Text("\(value)").bold() }.padding().background(.thinMaterial).clipShape(RoundedRectangle(cornerRadius: 14)) }
}

struct ComingSoonView: View {
    @ObservedObject var game: GameModel
    var body: some View { VStack(spacing: 18) { ScreenHeader(title: "Coming Soon") { game.screen = .home }; Text("🚀").font(.system(size: 70)); Text("More Challenges Are Coming").font(.title2.bold()); Text("New modes and puzzle experiences will be added in future releases.").multilineTextAlignment(.center); Spacer() }.padding(22) }
}
