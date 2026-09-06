package com.hindtechgroup.sequenceiq
import android.os.Bundle
import android.view.Gravity
import android.widget.*
import androidx.appcompat.app.AppCompatActivity

class MainActivity:AppCompatActivity(){
 private var level=1;private var lives=3;private var hints=3;private var difficulty="Easy"
 override fun onCreate(b:Bundle?){super.onCreate(b);home()}
 private fun base():LinearLayout=LinearLayout(this).apply{orientation=LinearLayout.VERTICAL;gravity=Gravity.CENTER;padding(28)}
 private fun Button(t:String,a:()->Unit)=Button(this).apply{text=t;setOnClickListener{a()}}
 private fun home(){val v=base();v.addView(TextView(this).apply{text="HIND TECH GROUP\n\nSequence IQ\n\nA Number Series & Logic Puzzle Game";textSize=25f;gravity=17});v.addView(Button("Open Play"){levels()});setContentView(v)}
 private fun levels(){val v=base();v.gravity=Gravity.TOP;v.addView(Button("← Home"){home()});listOf("Easy","Hard","Master").forEach{d->v.addView(TextView(this).apply{text=d;textSize=22f});for(i in 1..20){v.addView(Button("$i"){difficulty=d;level=i;lives=3;game()})}};setContentView(ScrollView(this).apply{addView(v)})}
 private fun game(){val v=base();v.gravity=Gravity.TOP;v.addView(Button("← Levels"){levels()});val a=level+1;val seq=when(difficulty){"Easy"->"$a, ${a+2}, ${a+4}, ${a+6}, ?, ${a+10}";"Hard"->"$a, ${a*2}, ${a*4}, ${a*8}, ?, ${a*32}";else->"$a, ${a+3}, ${a+8}, ${a+15}, ?, ${a+35}"};val answer=when(difficulty){"Easy"->a+8;"Hard"->a*16;else->a+24};v.addView(TextView(this).apply{text="$difficulty • Level $level\nLives: $lives\n\n$seq";textSize=22f;gravity=17});val choices=when(difficulty){"Easy"->listOf(answer,a+12,a+4,a+14);"Hard"->listOf(answer,a*12,a*24,a*32);else->listOf(answer,a+31,a+21,a+36)};choices.forEach{n->v.addView(Button(n.toString()){if(n==answer){Toast.makeText(this,"Correct!",Toast.LENGTH_SHORT).show()}else{lives--;Toast.makeText(this,if(lives==0)"Game Over" else "Try again",Toast.LENGTH_SHORT).show()};game()})};v.addView(Button("Use Hint ($hints)"){if(hints>0)hints--});setContentView(v)}
 private fun LinearLayout.padding(n:Int){setPadding(n,n,n,n)}
}
