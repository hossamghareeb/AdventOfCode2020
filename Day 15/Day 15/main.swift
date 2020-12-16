//
//  main.swift
//  Day 15
//
//  Created by Hossam Ghareeb on 15/12/2020.
//

import Foundation

func solve(_ input: [Int]) -> Int {
    var turn = 1
    var dict = [Int: (Int, Int)]()
    for n in input {
        dict[n] = (-1, turn)
        turn += 1
    }
    var lastSpoken = input.last!
    while turn <= 30000000 {
        let prevTurns = dict[lastSpoken]!
        if prevTurns.0 == -1 {
            lastSpoken = 0
        } else {
            lastSpoken = prevTurns.1 - prevTurns.0
        }
        let turns = dict[lastSpoken, default: (-1, -1)]
        dict[lastSpoken] = (turns.1, turn)
        
        turn += 1
    }
    return lastSpoken
}

let input = [13,0,10,12,1,5,8]
let date = Date()
let result = solve(input)
print(result)
print("it takes \(Calendar.current.dateComponents([.second], from: date, to: Date()).second) seconds")
