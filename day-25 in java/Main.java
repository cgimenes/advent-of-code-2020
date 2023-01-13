import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.List;
import java.util.stream.Collectors;

public class Main {

    public static void main(String[] args) throws IOException {
        List<Long> lines = Files.readAllLines(Paths.get("day-25 in java/input"))
            .stream()
            .map(Long::parseLong)
            .collect(Collectors.toList());

            long pubkey0LoopSize = bruteForceLoopSize(lines.get(0));
            long pubkey1LoopSize = bruteForceLoopSize(lines.get(1));

            long encKey = calculateEncKey(lines.get(1), pubkey0LoopSize);

        System.out.println("Part 1: " + encKey);
    }

    private static long calculateEncKey(long pubkey, long loopSize) {
        long value = 1;
        for (int i = 0; i < loopSize; i++) {
            value = (value * pubkey);
            value = value % 20201227;
        }
        return value;
    }

    private static long bruteForceLoopSize(long key) {
        int value = 1;
        long loopSize = 0;
        while (value != key) {
            value = (value * 7);
            value = value % 20201227;
            loopSize++;
        }
        return loopSize;
    }

}
