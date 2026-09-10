package com.hindtechgroup.sequenceiq.Helper

import android.content.Context
import com.hindtechgroup.sequenceiq.Model.Difficulty
import com.hindtechgroup.sequenceiq.Model.Puzzle

object PuzzleRepository {
    fun load(context: Context): List<Puzzle> {
        val puzzles = context.assets.open("Puzzles.txt").bufferedReader().useLines { lines ->
            lines.mapNotNull { line ->
                if (line.isBlank() || line.trimStart().startsWith("#")) return@mapNotNull null
                val parts = line.split('|')
                if (parts.size != 5) return@mapNotNull null
                val difficulty = runCatching { Difficulty.valueOf(parts[1].trim().uppercase()) }.getOrNull() ?: return@mapNotNull null
                val level = parts[0].trim().drop(1).toIntOrNull() ?: return@mapNotNull null
                val sequence = parts[2].split(',').map { value -> value.trim().let { if (it == "?") null else it.toIntOrNull() } }
                val options = parts[3].split(',').mapNotNull { it.trim().toIntOrNull() }
                val answer = parts[4].trim().toIntOrNull() ?: return@mapNotNull null
                if (sequence.size != 6 || sequence.count { it == null } != 1 || options.size != 4 || options.distinct().size != 4 || answer !in options) null
                else Puzzle(difficulty, level, sequence, answer, options)
            }.toList()
        }
        require(puzzles.size == 60) { "Expected 60 valid puzzles, found ${puzzles.size}" }
        require(puzzles.map { it.difficulty to it.level }.toSet().size == 60) { "Duplicate puzzle levels detected" }
        return puzzles.sortedWith(compareBy({ it.difficulty.ordinal }, { it.level }))
    }
}
