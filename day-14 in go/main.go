package main

import (
	"io/ioutil"
	"log"
	"path/filepath"
	"regexp"
	"strconv"
	"strings"
)

type Memory = map[int64]int64

type Write struct {
	Address int64
	Value   int64
}

type Operation struct {
	Mask  string
	Writes []Write
}

func (op *Operation) Append(write Write) {
	op.Writes = append(op.Writes, write)
}

func (op Operation) Execute(memory *Memory) {
	for _, write := range op.Writes {
		(*memory)[write.Address] = (write.Value &^ op.Mask0()) | op.Mask1()
	}
}

func (op Operation) ExecuteFloating(memory *Memory) {
	for _, write := range op.Writes {
		commonMask, _ := strconv.ParseInt(strings.ReplaceAll(op.Mask, "X", "0"), 2, 64)
		masks0 := op.floatingMasks(strings.ReplaceAll(op.Mask, "1", "0"))
		masks1 := op.floatingMasks(strings.ReplaceAll(op.Mask, "1", "0"))
		for i := range masks0 {
			address := ((write.Address | commonMask) &^ masks0[len(masks0) - 1 - i]) | masks1[i]
			(*memory)[address] = write.Value
		}
	}
}

func(op Operation) floatingMasks(mask string) []int64 {
	if !strings.Contains(mask, "X") {
		mask, _ := strconv.ParseInt(mask, 2, 64)
		return []int64{mask}
	}
	var masks []int64
	masks = append(masks, op.floatingMasks(strings.Replace(mask, "X", "0", 1))[:]...)
	masks = append(masks, op.floatingMasks(strings.Replace(mask, "X", "1", 1))[:]...)
	return masks
}

func (op Operation) Mask0() int64 {
	mask := strings.ReplaceAll(op.Mask, "1", "X")
	mask = strings.ReplaceAll(mask, "0", "1")
	mask = strings.ReplaceAll(mask, "X", "0")
	result, _ := strconv.ParseInt(mask, 2, 64)
	return result
}

func (op Operation) Mask1() int64 {
	mask := strings.ReplaceAll(op.Mask, "0", "X")
	mask = strings.ReplaceAll(mask, "X", "0")
	result, _ := strconv.ParseInt(mask, 2, 64)
	return result
}

func main() {
	path, _ := filepath.Abs("input")
	input, err := ioutil.ReadFile(path)
	check(err)
	lines := strings.Split(string(input), "\n")
	operations := parseOperations(lines)

	answer1 := part1(operations)
	answer2 := part2(operations)

	log.Printf("Part 1: %d\n", answer1)
	log.Printf("Part 2: %d\n", answer2)
}

func part1(operations []Operation) int64 {
	memory := make(Memory)
	for _, operation := range operations {
		operation.Execute(&memory)
	}
	return sumMemory(memory)
}

func part2(operations []Operation) int64 {
	memory := make(Memory)
	for _, operation := range operations {
		operation.ExecuteFloating(&memory)
	}
	return sumMemory(memory)
}

func sumMemory(memory Memory) int64 {
	var sum int64 = 0
	for _, data := range memory {
		sum += data
	}
	return sum
}

func parseOperations(lines []string) []Operation {
	operations := make([]Operation, 0)
	for i := 0; i < len(lines); i++ {
		parsed := strings.Split(lines[i], " = ")

		if parsed[0] == "mask" {
			operations = append(operations, Operation{
				Mask:  parsed[1],
				Writes: []Write{},
			})
		} else {
			re := regexp.MustCompile(`mem\[(\d+)]`)
			matches := re.FindStringSubmatch(parsed[0])

			address, _ := strconv.ParseInt(matches[1], 10, 64)
			value, _ := strconv.ParseInt(parsed[1], 10, 64)

			lastMask := &operations[len(operations)-1]
			lastMask.Append(Write{
				Address: address,
				Value:   value,
			})
		}
	}
	return operations
}

func check(e error) {
	if e != nil {
		panic(e)
	}
}
