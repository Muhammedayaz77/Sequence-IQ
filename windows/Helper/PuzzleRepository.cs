using System.Globalization;
using SequenceIQ.Model;

namespace SequenceIQ.Helper;

public static class PuzzleRepository {
    private static readonly Lazy<Dictionary<(Difficulty,int),Puzzle>> Data = new(Load);
    public static Puzzle Get(Difficulty difficulty, int level) => Data.Value.TryGetValue((difficulty,level), out var puzzle) ? puzzle : throw new InvalidOperationException($"Puzzle not found: {difficulty} {level}");
    private static Dictionary<(Difficulty,int),Puzzle> Load() {
        var path = Path.Combine(AppContext.BaseDirectory, "Puzzles.txt");
        var result = new Dictionary<(Difficulty,int),Puzzle>();
        foreach (var line in File.ReadLines(path)) {
            if (string.IsNullOrWhiteSpace(line) || line.StartsWith('#')) continue;
            var p=line.Split('|'); if(p.Length!=5) continue;
            var difficulty=Enum.Parse<Difficulty>(p[1], true);
            var level=int.Parse(p[0][1..], CultureInfo.InvariantCulture);
            var sequence=p[2].Split(',').Select(x => x.Trim()=="?" ? (int?)null : int.Parse(x,CultureInfo.InvariantCulture)).ToArray();
            var options=p[3].Split(',').Select(x=>int.Parse(x,CultureInfo.InvariantCulture)).ToArray();
            var answer=int.Parse(p[4],CultureInfo.InvariantCulture);
            result[(difficulty,level)]=new Puzzle(difficulty,level,sequence,answer,options);
        }
        if(result.Count!=60) throw new InvalidDataException($"Expected 60 puzzles, found {result.Count}.");
        return result;
    }
}
