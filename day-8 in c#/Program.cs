using System;
using System.Collections;
using System.Collections.Generic;
using System.IO;
using System.Linq;

namespace day_8
{
    internal static class Program
    {
        private static void Main()
        {
            var lines = File.ReadAllLines("input");
            var cmds = lines.Select(line =>
            {
                var parsed = line.Split(' ');
                var op = parsed[0];
                var value = int.Parse(parsed[1]);
                return (op, value);
            }).ToList();
            
            var (_, answer1) = Part1(cmds); 
            var answer2 = Part2(cmds); 
            
            Console.WriteLine("Part 1: " + answer1);
            Console.WriteLine("Part 2: " + answer2);
        }

        private static (bool ok, int acc) Part1(IReadOnlyList<(string op, int value)> cmds)
        {
            var pc = 0;
            var acc = 0;
            var executedOps = new ArrayList();

            while (pc < cmds.Count)
            {
                if (executedOps.Contains(pc))
                {
                    return (false, acc);
                }

                executedOps.Add(pc);

                var cmd = cmds[pc];

                switch (cmd.op)
                {
                    case "nop":
                        break;
                    case "jmp":
                        pc--;
                        pc += cmd.value;
                        break;
                    case "acc":
                        acc += cmd.value;
                        break;
                    default:
                        Console.WriteLine(cmd);
                        return (false, acc);
                }

                pc++;
            }

            return (true, acc);
        }
        
        private static int Part2(List<(string op, int value)> cmds)
        {
            var result = false;
            var acc = 0;
            var i = 0;
            
            while (!result)
            {
                var oldOp = cmds[i].op;
                switch (cmds[i].op)
                {
                    case "jmp":
                        cmds[i] = ("nop", cmds[i].value);
                        break;
                    case "nop":
                        cmds[i] = ("jmp", cmds[i].value);
                        break;
                    default:
                        i++;
                        continue;
                }
                    
                (result, acc) = Part1(cmds);
                
                cmds[i] = (oldOp, cmds[i].value);
                
                i++;
            }
            
            return acc;
        }
    }
}
