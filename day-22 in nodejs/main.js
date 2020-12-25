const { Console } = require('console')
var fs = require('fs')
var path = require('path')

function calcScore(player) {
    var cardCount = player.length
    return player
        .map((c, i) => c * (cardCount - i))
        .reduce((a,b) => a + b)
}

function part1(p0, p1) {
    while (true) {
        p0card = p0.shift()
        p1card = p1.shift()

        if (p0card > p1card) {
            p0.push(p0card, p1card)
        } else {
            p1.push(p1card, p0card)
        }

        if (p0.length == 0) {
            return p1
        } else if (p1.length == 0) {
            return p0
        }
    }
}

function part2(p0, p1) {
    var rounds = []

    while (true) {
        var cards = [...p0, 'X', ...p1].map(x => x.toString()).reduce((x, acc) => acc + x)
        if (rounds.includes(cards)) {
            return [0, p0];
        }
        rounds.push(cards)

        var p0card = p0.shift()
        var p1card = p1.shift()

        if (p0.length >= p0card && p1.length >= p1card) {
            var winner = part2(p0.slice(0, p0card), p1.slice(0, p1card))
        } else {
            if (p0card > p1card) {
                var winner = [0, p0]
            } else {
                var winner = [1, p1]
            }
        }

        if (winner[0] == 0) {
            p0.push(p0card, p1card)
        } else {
            p1.push(p1card, p0card)
        }

        if (p0.length == 0) {
            return [1, p1]
        } else if (p1.length == 0) {
            return [0, p0]
        }
    }
}

file = fs.readFileSync(path.join(__dirname, './input'), {encoding: 'utf-8'})

players = file.split('\n\n')
    .map(x => x.split('\n').slice(1))
    .map(x => x.map(y => parseInt(y)))

console.log('Part 1:' + calcScore(part1([...players[0]], [...players[1]])))
console.log('Part 2:' + calcScore(part2([...players[0]], [...players[1]])[1]))