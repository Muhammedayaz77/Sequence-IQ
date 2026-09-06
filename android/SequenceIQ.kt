package com.hindtechgroup.sequenceiq

import android.os.Bundle
import android.os.Handler
import android.os.Looper
import android.view.Gravity
import android.widget.*
import androidx.appcompat.app.AppCompatActivity

class MainActivity:AppCompatActivity(){
 private var level=1;private var lives=3;private var hints=3;private var difficulty="Easy";private val completed=mutableSetOf<String>()
 override fun onCreate(b:Bundle?){super.onCreate(b);showSplash()}
 private fun base():LinearLayout=LinearLayout(this).apply{orientation=LinearLayout.VERTICAL;gravity=Gravity.CENTER;padding(28)}
 private fun btn(t:String,a:()->Unit)=Button(this).apply{text=t;setOnClickListener{a()}}
 private fun showSplash(){val v=base();v.addView(TextView(this).apply{text="🧠\n\nSEQUENCE IQ\n\nFind the Pattern\nBoost Your Brain";textSize=30f;gravity=Gravity.CENTER});v.addView(ProgressBar(this));setContentView(v);Handler(Looper.getMainLooper()).postDelayed({home()},1500)}
 private fun home(){val v=base();v.addView(TextView(this).apply{text="🧠\nSEQUENCE IQ\n\nFind the Pattern\nBoost Your Brain";textSize=26f;gravity=Gravity.CENTER});v.addView(btn("▶  PLAY"){levels()});val row=LinearLayout(this).apply{gravity=Gravity.CENTER};row.addView(btn("SHOP"){});row.addView(btn("PLAY"){levels()});row.addView(btn("SOON"){});v.addView(row);v.addView(TextView(this).apply{text="\n\"Small Steps\nMake a Sharper Mind\"";gravity=Gravity.CENTER;textSize=17f});setContentView(v)}
 private fun done(d:String)=completed.count{it.startsWith("$d-")}
 private fun open(d:String)=d=="Easy"||(d=="Hard"&&done("Easy")>=20)||(d=="Master"&&done("Hard")>=20)
 private fun canPlay(d:String,i:Int)=open(d)&&i in 1..20&&(i==1||completed.contains("$d-${i-1}")||completed.contains("$d-$i"))
 private fun levels(){val v=base();v.gravity=Gravity.TOP;v.addView(btn("‹ Home"){home()});v.addView(TextView(this).apply{text="$difficulty Levels";textSize=25f;gravity=Gravity.CENTER});listOf("Easy","Hard","Master").forEach{d->val openNow=open(d);v.addView(btn(if(openNow)d else "🔒 $d"){if(openNow){difficulty=d;level=1;levels()}});if(d==difficulty&&openNow){for(i in 1..20){val playable=canPlay(d,i);val b=btn(if(completed.contains("$d-$i"))"$i  ★ ★ ★" else if(playable)"$i  CURRENT" else "$i  🔒"){if(playable){level=i;lives=3;game()}};b.isEnabled=playable;v.addView(b)}}};setContentView(ScrollView(this).apply{addView(v)})}
 private fun game(){val v=base();v.gravity=Gravity.TOP;v.addView(btn("‹ Levels"){levels()});val a=level+1;val seq=when(difficulty){"Easy"->"$a, ${a+2}, ${a+4}, ${a+6}, ?, ${a+10}";"Hard"->"$a, ${a*2}, ${a*4}, ${a*8}, ?, ${a*32}";else->"$a, ${a+3}, ${a+8}, ${a+15}, ?, ${a+35}"};val answer=when(difficulty){"Easy"->a+8;"Hard"->a*16;else->a+24};v.addView(TextView(this).apply{text="$difficulty • Level $level\nLives: $lives\n\n$seq";textSize=21f;gravity=Gravity.CENTER});val choices=when(difficulty){"Easy"->listOf(answer,a+12,a+4,a+14);"Hard"->listOf(answer,a*12,a*24,a*32);else->listOf(answer,a+31,a+21,a+36)};choices.forEach{n->v.addView(btn(n.toString()){if(n==answer){completed.add("$difficulty-$level");complete()}else{lives--;if(lives<=0)gameOver() else game()}})};v.addView(btn("💡 Hint ($hints)"){if(hints>0)hints--});v.addView(btn("↻ Restart"){lives=3;game()});v.addView(btn("» Skip"){});setContentView(v)}
 private fun complete(){val v=base();v.addView(TextView(this).apply{text="🏆\nLEVEL COMPLETE\n\nExcellent!\n★ ★ ★";textSize=28f;gravity=Gravity.CENTER});if(level<20)v.addView(btn("NEXT LEVEL ›"){if(canPlay(difficulty,level+1)){level++;lives=3;game()}});v.addView(btn("LEVEL MAP"){levels()});v.addView(btn("HOME"){home()});setContentView(v)}
 private fun gameOver(){val v=base();v.addView(TextView(this).apply{text="💥\nGAME OVER\n\nTry Again!\n\nYou used all 3 lives.";textSize=27f;gravity=Gravity.CENTER});v.addView(btn("↻ RETRY"){lives=3;game()});v.addView(btn("LEVEL MAP"){levels()});v.addView(btn("HOME"){home()});setContentView(v)}
 private fun LinearLayout.padding(n:Int){setPadding(n,n,n,n)}
}