using System.Windows;
using System.Windows.Controls;
using System.Windows.Media;
using System.Windows.Threading;
using SequenceIQ.Controller;
using SequenceIQ.Model;

namespace SequenceIQ;

public partial class MainWindow : Window {
    private readonly GameController controller;
    private readonly DispatcherTimer splashTimer = new() { Interval = TimeSpan.FromSeconds(1.5) };
    public MainWindow() { InitializeComponent(); controller=new GameController(new GameModel()); Render(); splashTimer.Tick += (_,_) => { splashTimer.Stop(); if(controller.Model.Screen==Screen.Splash){controller.Home();Render();} }; splashTimer.Start(); }
    private void Render() { ContentFrame.Content = Build(); }
    private Button Btn(string text, Action action, bool enabled=true) { var b=new Button { Content=text, Margin=new Thickness(8), Padding=new Thickness(18,12,18,12), FontSize=18, FontWeight=FontWeights.Bold, Foreground=Brushes.White, Background=new SolidColorBrush(Color.FromRgb(24,93,180)), BorderThickness=new Thickness(0), IsEnabled=enabled }; b.Click += (_,_)=>{action();Render();}; return b; }
    private StackPanel Panel() => new() { VerticalAlignment=VerticalAlignment.Center, HorizontalAlignment=HorizontalAlignment.Center, Width=650 };
    private TextBlock Title(string text,double size=38) => new(){Text=text,FontSize=size,FontWeight=FontWeights.Black,Foreground=Brushes.White,TextAlignment=TextAlignment.Center,Margin=new Thickness(10)};
    private FrameworkElement Build() {
        var p=Panel(); var m=controller.Model;
        switch(m.Screen) {
            case Screen.Splash: p.Children.Add(Title("🧠\nSEQUENCE IQ",46)); p.Children.Add(new TextBlock{Text="Find the Pattern\nBoost Your Brain",Foreground=Brushes.White,FontSize=22,TextAlignment=TextAlignment.Center}); p.Children.Add(new ProgressBar{IsIndeterminate=true,Height=8,Margin=new Thickness(30)}); break;
            case Screen.Home: p.Children.Add(Title("🧠\nSEQUENCE IQ",46)); p.Children.Add(new TextBlock{Text="Find the Pattern\nBoost Your Brain",Foreground=Brushes.White,FontSize=22,TextAlignment=TextAlignment.Center}); p.Children.Add(Btn("▶  PLAY",controller.DifficultySelect)); p.Children.Add(Btn("SHOP",()=>controller.Navigate(Screen.Shop))); p.Children.Add(Btn("SETTINGS",()=>controller.Navigate(Screen.Settings))); p.Children.Add(Btn("SOON",()=>controller.Navigate(Screen.ComingSoon))); break;
            case Screen.Difficulty: p.Children.Add(Title("Choose Difficulty")); p.Children.Add(Btn("Easy",()=>controller.SelectDifficulty(Difficulty.Easy))); p.Children.Add(Btn("Hard",()=>controller.SelectDifficulty(Difficulty.Hard),m.Open(Difficulty.Hard))); p.Children.Add(Btn("Master",()=>controller.SelectDifficulty(Difficulty.Master),m.Open(Difficulty.Master))); p.Children.Add(Btn("‹ Home",controller.Home)); break;
            case Screen.Levels: p.Children.Add(Title($"{m.Difficulty} Levels")); for(int i=1;i<=20;i++){int n=i; bool play=m.CanPlay(m.Difficulty,n); p.Children.Add(Btn(m.IsCompleted(m.Difficulty,n)?$"{n}   ★ ★ ★":play?$"{n}   CURRENT":$"{n}   🔒",()=>controller.Start(n),play));} p.Children.Add(Btn("‹ Difficulty",controller.DifficultySelect)); break;
            case Screen.Game: var q=m.GetPuzzle(); p.Children.Add(Title($"{m.Difficulty} • Level {m.Level}")); p.Children.Add(new TextBlock{Text=$"Lives: {new string('♥',m.Lives)}\n\n{string.Join("   ",q.Sequence.Select(x=>x?.ToString()??"?"))}",Foreground=Brushes.White,FontSize=28,TextAlignment=TextAlignment.Center,Margin=new Thickness(10)}); foreach(var o in q.Options){int v=o;p.Children.Add(Btn(v.ToString(),()=>controller.Answer(v)));} p.Children.Add(Btn($"💡 Hint ({m.Hints})",controller.Hint,m.Hints>0)); p.Children.Add(Btn("↻ Restart",controller.Retry)); p.Children.Add(Btn("‹ Levels",controller.Levels)); break;
            case Screen.Complete: p.Children.Add(Title("🏆\nLEVEL COMPLETE")); p.Children.Add(Title("Excellent!\n★ ★ ★",30)); if(m.Level<20)p.Children.Add(Btn("NEXT LEVEL ›",controller.Next)); p.Children.Add(Btn("LEVEL MAP",controller.Levels)); p.Children.Add(Btn("HOME",controller.Home)); break;
            case Screen.GameOver: p.Children.Add(Title("💥\nGAME OVER")); p.Children.Add(new TextBlock{Text="You used all 3 lives.",Foreground=Brushes.White,FontSize=22,TextAlignment=TextAlignment.Center}); p.Children.Add(Btn("↻ RETRY",controller.Retry)); p.Children.Add(Btn("LEVEL MAP",controller.Levels)); p.Children.Add(Btn("HOME",controller.Home)); break;
            default: p.Children.Add(Title(m.Screen switch{Screen.Shop=>"SHOP",Screen.Settings=>"SETTINGS",Screen.Achievements=>"ACHIEVEMENTS",Screen.Stats=>"STATS",_=>"COMING SOON"})); p.Children.Add(new TextBlock{Text=m.Screen==Screen.Shop?$"💡 Hints: {m.Hints}\nDaily free hint: Online only":m.Screen==Screen.Settings?"Music  ON\nSound  ON":m.Screen==Screen.Achievements?$"Levels completed: {m.Completed.Count}":m.Screen==Screen.Stats?$"Attempts: {m.Attempts}\nCorrect: {m.CorrectAnswers}":"More content is coming soon.",Foreground=Brushes.White,FontSize=22,TextAlignment=TextAlignment.Center,Margin=new Thickness(20)}); p.Children.Add(Btn("‹ HOME",controller.Home)); break;
        } return new Border{Background=new LinearGradientBrush(Color.FromRgb(8,40,88),Color.FromRgb(3,9,25),90),Padding=new Thickness(35),Child=new ScrollViewer{Content=p,VerticalScrollBarVisibility=ScrollBarVisibility.Auto}};
    }
}
