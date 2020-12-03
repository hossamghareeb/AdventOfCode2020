import UIKit

extension String {
    func char(at i: Int) -> Character {
        return self[index(startIndex, offsetBy: i)]
    }
}

func countTrees(map: [String], x: Int, y: Int, right: Int, down: Int, count: inout Int) {
    if y >= map.count { return } // reached the bottom
    let row = map[y]
    if row.char(at: x) == "#" { count += 1 } // found a tree
    let newX = (x + right) % row.count
    countTrees(map: map, x: newX, y: y + down, right: right, down: down, count: &count)
}


guard let url = Bundle.main.url(forResource: "input", withExtension: "txt"),
      let content = try? String(contentsOf: url, encoding: .utf8) else {
    fatalError("Can't open file with url")
}

let map = content.split(separator: "\n").map { String($0) }

var count1 = 0
var count2 = 0
var count3 = 0
var count4 = 0
var count5 = 0

countTrees(map: map, x: 0, y: 0, right: 1, down: 1, count: &count1)

countTrees(map: map, x: 0, y: 0, right: 3, down: 1, count: &count2)

countTrees(map: map, x: 0, y: 0, right: 5, down: 1, count: &count3)

countTrees(map: map, x: 0, y: 0, right: 7, down: 1, count: &count4)

countTrees(map: map, x: 0, y: 0, right: 1, down: 2, count: &count5)

print(count1 * count2 * count3 * count4 * count5)
