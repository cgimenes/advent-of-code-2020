package main

import (
	"fmt"
	"io/ioutil"
	"path/filepath"
	"strconv"
	"strings"
)

func check(e error) {
	if e != nil {
		panic(e)
	}
}

func main() {
	path, _ := filepath.Abs("input")
	input, err := ioutil.ReadFile(path)
	check(err)
	lines := strings.Split(string(input), "\n")

	fmt.Printf("Part 1: %d\n", part1(lines))
	fmt.Printf("Part 2: %d\n", part2(lines))
}

func part1(lines []string) int {
	for i := 0; i < (len(lines) - 1); i++ {
		x, _ := strconv.Atoi(lines[i])
		for j := i + 1; j < len(lines); j++ {
			y, _ := strconv.Atoi(lines[j])
			if x + y == 2020 {
				return x * y
			}
		}
	}
	return 0
}

func part2(lines []string) int {
	for i := 0; i < (len(lines) - 2); i++ {
		x, _ := strconv.Atoi(lines[i])
		for j := i + 1; j < (len(lines) - 1); j++ {
			y, _ := strconv.Atoi(lines[j])
			for k := j + 1; k < len(lines); k++ {
				z, _ := strconv.Atoi(lines[k])
				if x + y + z == 2020 {
					return x * y * z
				}
			}
		}
	}
	return 0
}
