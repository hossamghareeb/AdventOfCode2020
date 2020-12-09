import UIKit

// Main

guard let url = Bundle.main.url(forResource: "input", withExtension: "txt"),
      let content = try? String(contentsOf: url, encoding: .utf8) else {
    fatalError("Can't open file with url")
}

let input = content.split(separator: "\n").map { Int($0)! }

func solvePart1(len: Int = 25) -> Int {
    var previousNum = [Int]()

    for i in 0..<len {
        previousNum.append(input[i])
    }

    for i in len..<input.count  {
        let target = input[i] // new number in the stream
        var found = false
        var set = Set(previousNum) // O(1) lookup
        for p in previousNum {
            set.remove(p) // remove it as we need only two different numbers. For 26 we need 25 + 1, not 13 + 13
            if set.contains(target -  p) {
                found = true
                break
            } else {
                set.insert(p) // put it back
            }
        }
        if found == false {
            return target // not found (our solution)
        } else {
            previousNum.removeFirst()
            previousNum.append(target)
        }
    }
    return -1
}

let X = solvePart1()
// answer 23278925

func solvePart2(target: Int) -> ClosedRange<Int> {
    /**
     if  input is [7, 2, 4, 3, 3, 13]  and we need the continous sub array with sum 10, we use sum array
     sum arr      [7, 9, 13, 16, 19, 32]. Look for two numbers difference between them is 10, indexes is the range
     19 - 9 = 10. 
     */
    var sumArr = Array(repeating: 0, count: input.count)
    sumArr[0] = input[0]
    for i in 1..<input.count {
        sumArr[i] = input[i] + sumArr[i - 1]
    }

    for i in 0..<sumArr.count {
        for j in (i+1)..<sumArr.count  {
            if (sumArr[j] - sumArr[i]) == target {
                return (i + 1)...j
            }
        }
    }
    fatalError("Can't find contigous set")
}

let contRange = solvePart2(target: X)
let numInRange = input[contRange].sorted()
print(numInRange.first! + numInRange.last!)
