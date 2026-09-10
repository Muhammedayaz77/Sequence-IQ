using SequenceIQ.Model;

namespace SequenceIQ.Controller;

public sealed class GameController(GameModel model) {
    public GameModel Model => model;
    public void Home() => model.Screen = Screen.Home;
    public void DifficultySelect() => model.Screen = Screen.Difficulty;
    public void Levels() => model.Screen = Screen.Levels;
    public void SelectDifficulty(Difficulty d) { if (model.Open(d)) { model.Difficulty=d; model.Screen=Screen.Levels; } }
    public void Start(int level) => model.Start(model.Difficulty, level);
    public void Answer(int value) => model.Answer(value);
    public void Hint() => model.UseHint();
    public void Retry() => model.Retry();
    public void Next() => model.Next();
    public void Navigate(Screen screen) => model.Screen=screen;
}
