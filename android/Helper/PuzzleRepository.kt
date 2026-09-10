package com.hindtechgroup.sequenceiq.Helper

import android.content.Context
import com.hindtechgroup.sequenceiq.Model.Difficulty
import com.hindtechgroup.sequenceiq.Model.Puzzle

object PuzzleRepository {
    fun load(context: Context): List<Puzzle> = context.assets.open("Puzzles.txt").bufferedReader().useLines { lines ->
        lines.mapNotNull { line ->
            if (line.isBlank() || line.startsWith("#")) return@mapNotNull null
            val p=line.split('|'); if(p.size!=5) return@mapNotNull null
            val difficulty=runCatching { Difficulty.valueOf(p[1].uppercase()) }.getOrNull() ?: return@mapNotNull null
            val level=p[0].drop(1).toIntOrNull() ?: return@mapNotNull null
            val sequence=p[2].split(',').map { it.trim().let { v -> if(v=="?") null else v.toIntOrNull() } }
            val options=p[3].split(',').mapNotNull { it.trim().toIntOrNull() }
            val answer=p[4].toIntOrNull() ?: return@mapNotNull null
            if(sequence.size!=6 || options.size!=4) null else Puzzle(difficulty,level,sequence,answer,options)
        }.toList()
    }
}
