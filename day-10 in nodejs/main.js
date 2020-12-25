var fs = require('fs')
var path = require('path')

file = fs.readFileSync(path.join(__dirname, './input'), {encoding: 'utf-8'})
adapters = file.split('\n')
    .map(x => parseInt(x))
    .sort((x, y) => x - y)

function part1(adapters) {
    var oneCount = 0
    var threeCount = 1 // your device's built-in adapter is always 3 higher than the highest adapter
    var currentAdapter = 0
    for (let i = 0; i < adapters.length; i++) {
        const element = adapters[i]
        if (element - currentAdapter == 1) {
            oneCount++
        } else if (element - currentAdapter == 3) {
            threeCount++
        }
        currentAdapter = element
    }

    return oneCount * threeCount
}

var cache = {}

function memoize(func) {     
    return function() {
        var key = JSON.stringify(arguments);
        if (cache[key]){
            return cache[key];
        } else {
            val = func.apply(this, arguments);
            cache[key] = val;
            return val;
        }
    }
}

var part2 = memoize(function (adapters, index = 0) {
    if (index >= adapters.length-1) {
        return 1
    }

    var count = 0
    for (let i = 3; i > 0; i--) {
        if (adapters[index+i] - 3 <= adapters[index]) {
            count += part2(adapters, index+i)
        }
    }
    return count
})

var answer1 = part1(adapters)
var answer2 = part2([0].concat(adapters))

console.log('Part 1: ' + answer1)
console.log('Part 2: ' + answer2)