using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text.RegularExpressions;

namespace day_16
{
    internal static class Program
    {
        private static void Main()
        {
            var text = File.ReadAllText("input")
                .Replace("your ticket:\n", "")
                .Replace("nearby tickets:\n", "");
            var sections = text.Split("\n\n");
            var rules = sections[0]
                .Split("\n")
                .Select(line =>
                {
                    var find = new Regex(@"(.*): (\d+)-(\d+) or (\d+)-(\d+)");
                    var groups = find.Match(line).Groups;
                    var name = groups[1].Value;
                    var rule1Start = int.Parse(groups[2].Value);
                    var rule1End = int.Parse(groups[3].Value);
                    var rule2Start = int.Parse(groups[4].Value);
                    var rule2End = int.Parse(groups[5].Value);
                    return (name, rule1Start, rule1End, rule2Start, rule2End);
                }).ToList();
            var myTicket = sections[1].Split(',').Select(int.Parse).ToList();
            var nearbyTickets = sections[2]
                .Split("\n")
                .Select(line => line.Split(',').Select(int.Parse))
                .ToList();

            Console.WriteLine("Part 1: " + Part1(nearbyTickets, rules));
            Console.WriteLine("Part 1: " + Part2(nearbyTickets, rules, myTicket));
        }

        private static double Part2(
            IEnumerable<IEnumerable<int>> nearbyTickets, 
            List<(string name, int rule1Start, int rule1End, int rule2Start, int rule2End)> rules, 
            IReadOnlyList<int> myTicket)
        {
            var validNearbyTickets = nearbyTickets.Where(t => { return t.All(f => InAnyRule(f, rules)); }).ToList();

            var ruleCount = rules.Count;

            var ruleMatrix = Enumerable.Repeat(rules, ruleCount);

            var filtered = ruleMatrix.Select((rs, i) =>
            {
                return rs
                    .Where(r =>
                    {
                        return validNearbyTickets
                            .Select(t => t.ElementAt(i))
                            .All(f => ValidField(f, r));
                    }).ToList();
            }).ToList();

            var found = new Dictionary<string, int>();
            while (found.Count < ruleCount)
            {
                for (var i = 0; i < filtered.Count; i++)
                {
                    if (filtered[i].Count == 1)
                    {
                        found.Add(filtered[i].First().name, i);
                        filtered = filtered.Select(f => f.Where(r => !found.ContainsKey(r.name!)).ToList()).ToList();
                    }
                }
            }

            return found
                .Where(f => f.Key.StartsWith("departure"))
                .Select(f => f.Value)
                .Select(f => (double) myTicket[f])
                .Aggregate((f, acc) => f * acc);
        }

        private static int Part1(IEnumerable<IEnumerable<int>> nearbyTickets, IEnumerable<(string name, int rule1Start, int rule1End, int rule2Start, int rule2End)> rules)
        {
            return nearbyTickets.Select(t =>
            {
                return t
                    .Where(f => !InAnyRule(f, rules))
                    .Sum();
            })
            .Sum();
        }

        private static bool InAnyRule(int field,
            IEnumerable<(string name, int rule1Start, int rule1End, int rule2Start, int rule2End)> rules)
        {
            return rules.Any(r => ValidField(field, r));
        }

        private static bool ValidField(int field,
            (string name, int rule1Start, int rule1End, int rule2Start, int rule2End) rule)
        {
            return field >= rule.rule1Start && field <= rule.rule1End ||
                   field >= rule.rule2Start && field <= rule.rule2End;
        }
    }
}
