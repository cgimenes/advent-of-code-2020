import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.Collections;
import java.util.List;
import java.util.stream.Collectors;

public class Main {

    public static void main(String[] args) throws IOException {
        List<String> lines = Files.readAllLines(Paths.get("day-9 in java/input"));

        int preamble = 25;

        long answer1 = part1(lines, preamble);
        long answer2 = part2(lines, answer1);

        System.out.println("Part 1: " + answer1);
        System.out.println("Part 2: " + answer2);
    }

    private static long part1(List<String> lines, int preamble) {
        for (int i = preamble; i < lines.size(); i++) {
            if (!check(lines, preamble, i)) {
                return Long.parseLong(lines.get(i));
            }
        }
        return 0;
    }

    private static boolean check(List<String> lines, int preamble, int index) {
        for (int i = index - preamble; i < (index - 1); i++) {
            for (int j = i + 1; j < index; j++) {
                if (Long.parseLong(lines.get(i)) + Long.parseLong(lines.get(j)) == Long.parseLong(lines.get(index))) {
                    return true;
                }
            }
        }
        return false;
    }

    private static long part2(List<String> lines, long objective) {
        int i = 0; 
        int j = 0; 

        search: {
            for (i = 0; i < (lines.size() - 1); i++) {
                long sum = Long.parseLong(lines.get(i));
                for (j = i + 1; j < lines.size(); j++) {
                    sum += Long.parseLong(lines.get(j));
    
                    if (sum == objective) {
                        break search;
                    }
                }
            }
        }

        List<Long> contiguous = lines.subList(i, j+1)
            .stream()
            .map(Long::parseLong)
            .collect(Collectors.toList());

        long min = Collections.min(contiguous);
        long max = Collections.max(contiguous);

        return min + max;
    }
}
