using System.Globalization;
using SequenceIQ.Model;

namespace SequenceIQ.Helper;

public static class PuzzleRepository
{
    private static readonly Lazy<Dictionary<(Difficulty, int), Puzzle>> Data = new(Load);

    public static Puzzle Get(Difficulty difficulty, int level) =>
        Data.Value.TryGetValue((difficulty, level), out var puzzle)
            ? puzzle
            : throw new InvalidOperationException($"Puzzle not found: {difficulty} {level}");

    private static Dictionary<(Difficulty, int), Puzzle> Load()
    {
        var path = Path.Combine(AppContext.BaseDirectory, "Puzzles.txt");
        if (!File.Exists(path)) throw new FileNotFoundException("Puzzles.txt is missing.", path);

        var result = new Dictionary<(Difficulty, int), Puzzle>();
        foreach (var line in File.ReadLines(path))
        {
            if (string.IsNullOrWhiteSpace(line) || line.TrimStart().StartsWith('#')) continue;
            var parts = line.Split('|');
            if (parts.Length != 5) throw new InvalidDataException($"Invalid puzzle line: {line}");

            var difficulty = Enum.Parse<Difficulty>(parts[1].Trim(), true);
            var level = int.Parse(parts[0].Trim()[1..], CultureInfo.InvariantCulture);
            var sequence = parts[2].Split(',').Select(ParseNullableNumber).ToArray();
            var options = parts[3].Split(',').Select(x => int.Parse(x.Trim(), CultureInfo.InvariantCulture)).ToArray();
            var answer = int.Parse(parts[4].Trim(), CultureInfo.InvariantCulture);

            if (sequence.Length != 6 || sequence.Count(x => x is null) != 1)
                throw new InvalidDataException($"Puzzle {parts[0]} must contain exactly 6 sequence values and one '?'.");
            if (options.Length != 4 || options.Distinct().Count() != 4 || !options.Contains(answer))
                throw new InvalidDataException($"Puzzle {parts[0]} must contain 4 unique options including the correct answer.");
            if (!result.TryAdd((difficulty, level), new Puzzle(difficulty, level, sequence, answer, options)))
                throw new InvalidDataException($"Duplicate puzzle: {difficulty} level {level}.");
        }

        foreach (var difficulty in Enum.GetValues<Difficulty>())
            for (var level = 1; level <= 20; level++)
                if (!result.ContainsKey((difficulty, level)))
                    throw new InvalidDataException($"Missing puzzle: {difficulty} level {level}.");

        return result;
    }

    private static int? ParseNullableNumber(string value) =>
        value.Trim() == "?" ? null : int.Parse(value.Trim(), CultureInfo.InvariantCulture);
}
