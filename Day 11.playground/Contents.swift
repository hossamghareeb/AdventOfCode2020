import UIKit
extension String {
    func char(at i: Int) -> Character {
        return self[index(startIndex, offsetBy: i)]
    }
}

extension Array where Element == [Character] {
    func emptyAdjacentCount(i: Int, j: Int) -> Int {
        return adjacentCount(char: "L", i: i, j: j)
    }
    
    func occupiedAdjacentCount(i: Int, j: Int) -> Int {
        return adjacentCount(char: "#", i: i, j: j)
    }
    
    private func adjacentCount(char: Character, i: Int, j: Int) -> Int {
        var count = 0
        if self[i - 1][j] == char { count += 1 } // up
        if self[i + 1][j] == char { count += 1 } // down
        if self[i][j - 1] == char { count += 1 } // left
        if self[i][j + 1] == char { count += 1 } // right
        
        if self[i - 1][j - 1] == char { count += 1 } // diagonal
        if self[i - 1][j + 1] == char { count += 1 } // diagonal
        if self[i + 1][j - 1] == char { count += 1 } // diagonal
        if self[i + 1][j + 1] == char { count += 1 } // diagonal
        return count
    }
    
    func isFloor(i: Int, j: Int) -> Bool {
        return self[i][j] == "."
    }
    
    func isOccupied(i: Int, j: Int) -> Bool {
        return self[i][j] == "#"
    }
    
    func isEmpty(i: Int, j: Int) -> Bool {
        return self[i][j] == "L"
    }
    
    func log() {
        for line in self {
            print(String(line))
        }
        print("===============")
    }
}

guard let url = Bundle.main.url(forResource: "input", withExtension: "txt"),
      let content = try? String(contentsOf: url, encoding: .utf8) else {
    fatalError("Can't open file with url")
}

let lines = content.split(separator: "\n")
var grid = Array(repeating: Array(repeating: Character("."), count: lines[0].count + 2), count: lines.count + 2)

for r in 0..<lines.count {
    let line = String(lines[r])
    for c in 0..<lines[0].count {
        grid[r + 1][c + 1] = line.char(at: c)
    }
}

func round1(grid: inout [[Character]]) -> Bool {
    var changed = false
    for r in 1..<(grid.count - 1) {
        for c in 1..<(grid[0].count - 1)  {
            guard grid.isFloor(i: r, j: c) == false else { continue }
            if grid.isEmpty(i: r, j: c) && grid.occupiedAdjacentCount(i: r, j: c) < 8 {
                changed = true
                grid[r][c] = "#"
            }
        }
    }
    grid.log()
    return changed
}

func round2(grid: inout [[Character]]) -> Bool {
    var changed = false
    for r in 1..<(grid.count - 1)  {
        for c in 1..<(grid[0].count - 1)  {
            guard grid.isFloor(i: r, j: c) == false else { continue }
            if grid.isOccupied(i: r, j: c) && grid.occupiedAdjacentCount(i: r, j: c) >= 4 {
                changed = true
                grid[r][c] = "L"
            }
        }
    }
    grid.log()
    return changed
}

round1(grid: &grid)
round2(grid: &grid)

//while round1(grid: &grid) && round2(grid: &grid) {
//    print("Apply!")
//}

print("Done")
