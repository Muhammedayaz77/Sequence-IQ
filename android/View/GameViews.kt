package com.hindtechgroup.sequenceiq.View

import android.graphics.Color
import android.view.Gravity
import android.view.ViewGroup
import android.widget.*
import com.hindtechgroup.sequenceiq.Model.*

class GameViews(private val activity: android.app.Activity, private val model: GameModel, private val action: (Screen) -> Unit, private val answer: (Int) -> Unit, private val hint: () -> Unit, private val retry: () -> Unit, private val next: () -> Unit) {
    private fun base() = LinearLayout(activity).apply { orientation = LinearLayout.VERTICAL; gravity = Gravity.CENTER; setPadding(28, 24, 28, 24); setBackgroundColor(Color.rgb(10, 18, 55)) }
    private fun text(value: String, size: Float = 20f) = TextView(activity).apply { text = value; textSize = size; setTextColor(Color.WHITE); gravity = Gravity.CENTER; setPadding(8, 10, 8, 10) }
    private fun button(label: String, enabled: Boolean = true, click: () -> Unit) = Button(activity).apply { text = label; isEnabled = enabled; setOnClickListener { click() }; layoutParams = LinearLayout.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.WRAP_CONTENT).apply { setMargins(0, 6, 0, 6) } }

    fun render(): LinearLayout = when (model.screen) {
        Screen.SPLASH -> base().apply { addView(text("🧠\n\nSEQUENCE IQ\n\nFind the Pattern\nBoost Your Brain", 30f)); addView(ProgressBar(activity)) }
        Screen.HOME -> base().apply { addView(text("🧠\nSEQUENCE IQ\n\nFind the Pattern\nBoost Your Brain", 27f)); addView(button("▶  PLAY") { action(Screen.DIFFICULTY) }); addView(button("SHOP") { action(Screen.SHOP) }); addView(button("SETTINGS") { action(Screen.SETTINGS) }); addView(button("ACHIEVEMENTS") { action(Screen.ACHIEVEMENTS) }); addView(button("STATS") { action(Screen.STATS) }); addView(button("COMING SOON") { action(Screen.COMING_SOON) }) }
        Screen.DIFFICULTY -> base().apply { addView(button("‹ HOME") { action(Screen.HOME) }); addView(text("Choose Difficulty", 26f)); Difficulty.values().forEach { d -> val open = model.open(d); addView(button(if (open) d.title else "🔒 ${d.title}", open) { model.difficulty = d; action(Screen.LEVELS) }) } }
        Screen.LEVELS -> ScrollView(activity).apply { addView(base().apply { addView(button("‹ DIFFICULTY") { action(Screen.DIFFICULTY) }); addView(text("${model.difficulty.title} Levels", 25f)); for (i in 1..20) { val playable = model.canPlay(model.difficulty, i); addView(button(if (model.completed(model.difficulty, i)) "$i  ★ ★ ★" else if (playable) "$i  CURRENT" else "$i  🔒", playable) { model.start(model.difficulty, i); action(Screen.GAME) }) } }) }
        Screen.GAME -> base().apply {
            val p = model.puzzle()
            addView(button("‹ LEVELS") { action(Screen.LEVELS) })
            addView(text("${p.difficulty.title} • Level ${p.level}\n♥ ${model.lives}     💡 ${model.hints}"))
            addView(text("Find the next number"))
            addView(text(p.sequence.joinToString("   ") { it?.toString() ?: "?" }, 22f))
            if (model.hintStage > 0) addView(text(if (model.hintStage >= 3) "Hint 3: Answer is ${p.answer}." else if (model.hintStage == 2) "Hint 2: Only the correct choice remains." else "Hint 1: One incorrect choice removed."))
            val options = when (model.hintStage) {
                0 -> p.options
                1 -> listOf(p.answer, p.options.firstOrNull { it != p.answer } ?: p.answer)
                else -> listOf(p.answer)
            }
            options.distinct().forEach { value -> addView(button(value.toString()) { answer(value) }) }
            addView(button("💡 HINT (${model.hints})", model.hints > 0 && model.hintStage < 3) { hint() })
            addView(button("↻ RESTART") { retry() })
        }
        Screen.COMPLETE -> base().apply { addView(text("🏆\nLEVEL COMPLETE\n\nExcellent!\n★ ★ ★", 29f)); if (model.level < 20) addView(button("NEXT LEVEL ›") { next() }); addView(button("LEVEL MAP") { action(Screen.LEVELS) }); addView(button("HOME") { action(Screen.HOME) }) }
        Screen.GAME_OVER -> base().apply { addView(text("💥\nGAME OVER\n\nTry Again!\n\nYou used all 3 lives.", 28f)); addView(button("↻ RETRY") { retry() }); addView(button("LEVEL MAP") { action(Screen.LEVELS) }); addView(button("HOME") { action(Screen.HOME) }) }
        Screen.SETTINGS -> base().apply { addView(button("‹ HOME") { action(Screen.HOME) }); addView(text("Settings", 27f)); val music = Switch(activity).apply { text = "Music"; isChecked = activity.getPreferences(0).getBoolean("music", true); setTextColor(Color.WHITE); setOnCheckedChangeListener { _, v -> activity.getPreferences(0).edit().putBoolean("music", v).apply() } }; val sound = Switch(activity).apply { text = "Sound"; isChecked = activity.getPreferences(0).getBoolean("sound", true); setTextColor(Color.WHITE); setOnCheckedChangeListener { _, v -> activity.getPreferences(0).edit().putBoolean("sound", v).apply() } }; addView(music); addView(sound) }
        Screen.SHOP -> base().apply { addView(button("‹ HOME") { action(Screen.HOME) }); addView(text("💡\nShop\n\nDaily Free Hint", 28f)); addView(text("One free hint can be claimed once per day while online.\nOnline/cloud reward service is not connected in V1 yet.")); addView(button("DAILY HINT — ONLINE SERVICE REQUIRED") {}, false) }
        Screen.ACHIEVEMENTS -> base().apply { addView(button("‹ HOME") { action(Screen.HOME) }); addView(text("Achievements", 27f)); addView(text("🏆 First Step: ${if (model.completedCount(Difficulty.EASY) > 0) "Unlocked" else "Locked"}")); addView(text("🏆 Easy Master: ${if (model.completedCount(Difficulty.EASY) == 20) "Unlocked" else "Locked"}")); addView(text("🏆 Hard Master: ${if (model.completedCount(Difficulty.HARD) == 20) "Unlocked" else "Locked"}")); addView(text("🏆 IQ Champion: ${if (model.completedCount(Difficulty.MASTER) == 20) "Unlocked" else "Locked"}")) }
        Screen.STATS -> base().apply { addView(button("‹ HOME") { action(Screen.HOME) }); addView(text("Stats", 27f)); addView(text("Easy: ${model.completedCount(Difficulty.EASY)} / 20\nHard: ${model.completedCount(Difficulty.HARD)} / 20\nMaster: ${model.completedCount(Difficulty.MASTER)} / 20\n\nCorrect: ${model.correctAnswers}\nAttempts: ${model.attempts}")) }
        Screen.COMING_SOON -> base().apply { addView(button("‹ HOME") { action(Screen.HOME) }); addView(text("🚀\nCOMING SOON\n\nMore challenges are coming.", 28f)) }
    }
}
