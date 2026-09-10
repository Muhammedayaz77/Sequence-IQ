import Foundation
import Combine

enum Difficulty: String, CaseIterable, Codable, Identifiable { case easy="Easy", hard="Hard", master="Master"; var id:String{rawValue} }
enum AppScreen: Equatable { case splash,home,difficulty,levels,game,complete,gameOver,settings,shop,achievements,stats,comingSoon }
struct Puzzle: Codable, Equatable { let difficulty:Difficulty; let level:Int; let sequence:[Int?]; let answer:Int; let options:[Int] }

@MainActor final class GameModel: ObservableObject {
 @Published var screen:AppScreen = .splash; @Published var difficulty:Difficulty = .easy; @Published var level=1; @Published var lives=3; @Published var hints=3; @Published var hintStage=0; @Published var message=""; @Published private(set) var completed:Set<String>=[]; @Published private(set) var attempts=0; @Published private(set) var correctAnswers=0
 @Published var musicOn:Bool; @Published var soundOn:Bool
 private let defaults=UserDefaults.standard; private let puzzles:[Puzzle]
 init(){ completed=Set(defaults.stringArray(forKey:"sequenceIQ.completed") ?? []); hints=defaults.object(forKey:"sequenceIQ.hints") as? Int ?? 3; attempts=defaults.integer(forKey:"sequenceIQ.attempts"); correctAnswers=defaults.integer(forKey:"sequenceIQ.correct"); musicOn=defaults.object(forKey:"sequenceIQ.music") as? Bool ?? true; soundOn=defaults.object(forKey:"sequenceIQ.sound") as? Bool ?? true; puzzles=PuzzleRepository.load() }
 func start(_ d:Difficulty,_ l:Int){guard canPlay(d,l) else{return};difficulty=d;level=l;lives=3;hintStage=0;message="";screen=.game}
 func open(_ d:Difficulty)->Bool{switch d{case .easy:return true;case .hard:return completedCount(.easy)==20;case .master:return completedCount(.hard)==20}}
 func canPlay(_ d:Difficulty,_ l:Int)->Bool{open(d)&&(1...20).contains(l)&&(l==1||completed.contains(key(d,l-1)))}
 func puzzle()->Puzzle{puzzles.first{$0.difficulty==difficulty&&$0.level==level} ?? PuzzleRepository.puzzle(difficulty:difficulty,level:level)}
 func answer(_ value:Int){guard screen==.game else{return};attempts+=1;if value==puzzle().answer{correctAnswers+=1;completed.insert(key(difficulty,level));persist();screen=.complete}else{lives-=1;message=lives==0 ? "Game Over":"Try again.";persist();if lives==0{screen=.gameOver}}}
 func useHint(){guard hints>0&&hintStage<3 else{return};hints-=1;hintStage+=1;persist()}
 func setMusic(_ on:Bool){musicOn=on;defaults.set(on,forKey:"sequenceIQ.music")}
 func setSound(_ on:Bool){soundOn=on;defaults.set(on,forKey:"sequenceIQ.sound")}
 func retry(){start(difficulty,level)};func next(){if level<20&&completed.contains(key(difficulty,level)){start(difficulty,level+1)}}
 func completedCount(_ d:Difficulty)->Int{completed.filter{$0.hasPrefix("\(d.rawValue)-")}.count};func isCompleted(_ d:Difficulty,_ l:Int)->Bool{completed.contains(key(d,l))};private func key(_ d:Difficulty,_ l:Int)->String{"\(d.rawValue)-\(l)"}
 private func persist(){defaults.set(Array(completed),forKey:"sequenceIQ.completed");defaults.set(hints,forKey:"sequenceIQ.hints");defaults.set(attempts,forKey:"sequenceIQ.attempts");defaults.set(correctAnswers,forKey:"sequenceIQ.correct")}
}
