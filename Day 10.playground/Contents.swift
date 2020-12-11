import UIKit

guard let url = Bundle.main.url(forResource: "input", withExtension: "txt"),
      let content = try? String(contentsOf: url, encoding: .utf8) else {
    fatalError("Can't open file with url")
}

var numbers = content.split(separator: "\n").map { Int($0)! }

numbers.sort()

func p2(numbers: [Int]) {
    var numbers = numbers
    numbers.insert(0, at: 0)
    var dict = [Int: Int]()
    dict[numbers.last! + 3] = 1
    var i = numbers.count - 1
    var result = 0
    while i >= 0 {
        let x = numbers[i]
        dict[x] = dict[x + 1, default: 0] + dict[x + 2, default: 0] + dict[x + 3, default: 0]
        result = dict[x]!
        i -= 1
    }
    
    print(result)
    print(dict.values.sorted())
}

func p1(numbers: [Int]) {
    var numbers = numbers
    numbers.append(numbers.last! + 3)
    var d1 = 0
    var d3 = 0
    var prev = 0
    for ad in numbers {
        let d = ad - prev
        switch d {
        case 1:d1 += 1
        case 2: break
        case 3: d3 += 1
        default: print("Error")
        }
        prev = ad
    }

    print(d1)
    print(d3)

    print(d1 * d3)
}

p2(numbers: numbers)
// 863547424768
