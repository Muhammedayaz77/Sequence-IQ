namespace SequenceIQ.Model;

public enum Difficulty { Easy, Hard, Master }
public enum Screen { Splash, Home, Difficulty, Levels, Game, Complete, GameOver, Settings, Shop, Achievements, Stats, ComingSoon }
public sealed record Puzzle(Difficulty Difficulty, int Level, int?[] Sequence, int Answer, int[] Options);

public sealed class GameModel {
    public Screen Screen { get; set; } = Screen.Splash;
    public Difficulty Difficulty { get; set; } = Difficulty.Easy;
    public int Level { get; set; } = 1;
    public int Lives { get; set; } = 3;
    public int Hints { get; set; } = 3;
    public int HintStage { get; set; }
    public string Message { get; set; } = "";
    public HashSet<string> Completed { get; } = [];
    public int Attempts { get; private set; }
    public int CorrectAnswers { get; private set; }

    public bool Open(Difficulty d) => d == Difficulty.Easy || (d == Difficulty.Hard && CompletedCount(Difficulty.Easy) == 20) || (d == Difficulty.Master && CompletedCount(Difficulty.Hard) == 20);
    public bool CanPlay(Difficulty d, int l) => Open(d) && l is >= 1 and <= 20 && (l == 1 || Completed.Contains(Key(d, l - 1)));
    public int CompletedCount(Difficulty d) => Completed.Count(x => x.StartsWith($"{d}-", StringComparison.Ordinal));
    public bool IsCompleted(Difficulty d, int l) => Completed.Contains(Key(d,l));
    private static string Key(Difficulty d, int l) => $"{d}-{l}";

    public Puzzle GetPuzzle() => PuzzleRepository.Get(Difficulty, Level);
    public void Start(Difficulty d, int l) { if (!CanPlay(d,l)) return; Difficulty=d; Level=l; Lives=3; HintStage=0; Message=""; Screen=Screen.Game; }
    public void Answer(int value) { if (Screen != Screen.Game) return; Attempts++; if (value == GetPuzzle().Answer) { CorrectAnswers++; Completed.Add(Key(Difficulty,Level)); Screen=Screen.Complete; } else { Lives--; Message=Lives==0 ? "Game Over" : "Try again."; if (Lives==0) Screen=Screen.GameOver; } }
    public void UseHint() { if (Hints>0 && HintStage<3) { Hints--; HintStage++; } }
    public void Retry() => Start(Difficulty,Level);
    public void Next() { if (Level<20 && IsCompleted(Difficulty,Level)) Start(Difficulty,Level+1); }
}
