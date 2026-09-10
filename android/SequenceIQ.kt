package com.hindtechgroup.sequenceiq

import android.os.Bundle
import android.os.Handler
import android.os.Looper
import androidx.appcompat.app.AppCompatActivity
import com.hindtechgroup.sequenceiq.Controller.GameController
import com.hindtechgroup.sequenceiq.Model.GameModel
import com.hindtechgroup.sequenceiq.Model.Screen
import com.hindtechgroup.sequenceiq.View.GameViews

class MainActivity : AppCompatActivity() {
    private lateinit var model: GameModel
    private lateinit var controller: GameController
    private lateinit var views: GameViews

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        model = GameModel(this)
        controller = GameController(model) { render() }
        views = GameViews(this, model, { controller.navigate(it) }, controller::answer, controller::hint, controller::retry, controller::next)
        render()
        Handler(Looper.getMainLooper()).postDelayed({ if (model.screen == Screen.SPLASH) controller.home() }, 1500)
    }

    private fun render() { setContentView(views.render()) }
}
