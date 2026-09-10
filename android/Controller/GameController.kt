package com.hindtechgroup.sequenceiq.Controller

import com.hindtechgroup.sequenceiq.Model.*

class GameController(private val model: GameModel, private val render: () -> Unit) {
    fun home(){model.screen=Screen.HOME;render()}
    fun difficulty(){model.screen=Screen.DIFFICULTY;render()}
    fun levels(){model.screen=Screen.LEVELS;render()}
    fun selectDifficulty(d:Difficulty){if(model.open(d)){model.difficulty=d;model.screen=Screen.LEVELS;render()}}
    fun start(l:Int){model.start(model.difficulty,l);render()}
    fun answer(v:Int){model.answer(v);render()}
    fun hint(){model.useHint();render()}
    fun retry(){model.retry();render()}
    fun next(){model.next();render()}
    fun navigate(s:Screen){model.screen=s;render()}
}
