package com.hindtechgroup.sequenceiq.Model

import android.content.Context
import com.hindtechgroup.sequenceiq.Helper.PuzzleRepository

enum class Difficulty(val title: String) { EASY("Easy"), HARD("Hard"), MASTER("Master") }
enum class Screen { SPLASH, HOME, DIFFICULTY, LEVELS, GAME, COMPLETE, GAME_OVER, SETTINGS, SHOP, ACHIEVEMENTS, STATS, COMING_SOON }
data class Puzzle(val difficulty: Difficulty,val level:Int,val sequence:List<Int?>,val answer:Int,val options:List<Int>)

class GameModel(context: Context) {
 private val prefs=context.getSharedPreferences("sequenceIQ",Context.MODE_PRIVATE); private val puzzles=PuzzleRepository.load(context)
 var screen=Screen.SPLASH; var difficulty=Difficulty.EASY; var level=1; var lives=3; var hints=prefs.getInt("hints",3); var hintStage=0; var message=""; var attempts=prefs.getInt("attempts",0); var correctAnswers=prefs.getInt("correct",0)
 private val completed=prefs.getStringSet("completed",emptySet())!!.toMutableSet()
 fun open(d:Difficulty)=d==Difficulty.EASY||(d==Difficulty.HARD&&completedCount(Difficulty.EASY)==20)||(d==Difficulty.MASTER&&completedCount(Difficulty.HARD)==20)
 fun canPlay(d:Difficulty,l:Int)=open(d)&&l in 1..20&&(l==1||completed.contains("${d.title}-${l-1}"))
 fun completed(d:Difficulty,l:Int)=completed.contains("${d.title}-$l"); fun completedCount(d:Difficulty)=completed.count{it.startsWith("${d.title}-")}
 fun puzzle():Puzzle=puzzles.firstOrNull{it.difficulty==difficulty&&it.level==level} ?: error("Puzzle not found: $difficulty $level")
 fun start(d:Difficulty,l:Int){if(!canPlay(d,l))return;difficulty=d;level=l;lives=3;hintStage=0;message="";screen=Screen.GAME}
 fun answer(value:Int){if(screen!=Screen.GAME)return;attempts++;if(value==puzzle().answer){correctAnswers++;completed.add("${difficulty.title}-$level");persist();screen=Screen.COMPLETE}else{lives--;message=if(lives==0)"Game Over" else "Try again.";persist();if(lives==0)screen=Screen.GAME_OVER}}
 fun useHint(){if(hints>0&&hintStage<3){hints--;hintStage++;persist()}};fun retry(){start(difficulty,level)};fun next(){if(level<20&&completed(difficulty,level))start(difficulty,level+1)}
 private fun persist(){prefs.edit().putInt("hints",hints).putInt("attempts",attempts).putInt("correct",correctAnswers).putStringSet("completed",completed).apply()}
}
