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
    
    func occupiedDirectionalCount(i: Int, j: Int) -> Int {
        var count = 0
        let C = self[0].count
        func check(c: Character) -> Bool {
            if c == "." { return false }
            else {
                if c == "#" { count += 1 }
                return true
            }
        }
        for u in (0...i - 1).reversed() { if check(c: self[u][j]) { break } }
        for d in (i + 1..<self.count) { if check(c: self[d][j]) { break } }
        for l in (0...j - 1).reversed() { if check(c: self[i][l]) { break } }
        for r in (j + 1..<C) { if check(c: self[i][r]) { break } }
        
        var r = i - 1
        var c = j - 1
        while r >= 0 && c >= 0 {
            if check(c: self[r][c]) { break }
            r -= 1
            c -= 1
        }
        
        r = i - 1
        c = j + 1
        while r >= 0 && c < C {
            if check(c: self[r][c]) { break }
            r -= 1
            c += 1
        }
        
        r = i + 1
        c = j - 1
        while r < self.count && c >= 0 {
            if check(c: self[r][c]) { break }
            r += 1
            c -= 1
        }
        
        r = i + 1
        c = j + 1
        while r < self.count && c < C {
            if check(c: self[r][c]) { break }
            r += 1
            c += 1
        }
        
        return count
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
    var copy = grid
    var changed = false
    for r in 1..<(grid.count - 1) {
        for c in 1..<(grid[0].count - 1)  {
            guard grid.isFloor(i: r, j: c) == false else { continue }
            if grid.isEmpty(i: r, j: c) && grid.occupiedAdjacentCount(i: r, j: c) == 0 {
                changed = true
                copy[r][c] = "#"
            }
        }
    }
//    copy.log()
    grid = copy
    return changed
}

func round2(grid: inout [[Character]]) -> Bool {
    var copy = grid
    var changed = false
    for r in 1..<(grid.count - 1)  {
        for c in 1..<(grid[0].count - 1)  {
            guard grid.isFloor(i: r, j: c) == false else { continue }
            if grid.isOccupied(i: r, j: c) && grid.occupiedAdjacentCount(i: r, j: c) >= 4 {
                changed = true
                copy[r][c] = "L"
            }
        }
    }
//    copy.log()
    grid = copy
    return changed
}

func round1_2(grid: inout [[Character]]) -> Bool {
    var copy = grid
    var changed = false
    for r in 1..<(grid.count - 1) {
        for c in 1..<(grid[0].count - 1)  {
            guard grid.isFloor(i: r, j: c) == false else { continue }
            if grid.isEmpty(i: r, j: c) && grid.occupiedDirectionalCount(i: r, j: c) == 0 {
                changed = true
                copy[r][c] = "#"
            }
        }
    }
//    copy.log()
    grid = copy
    return changed
}

func round2_2(grid: inout [[Character]]) -> Bool {
    var copy = grid
    var changed = false
    for r in 1..<(grid.count - 1)  {
        for c in 1..<(grid[0].count - 1)  {
            guard grid.isFloor(i: r, j: c) == false else { continue }
            if grid.isOccupied(i: r, j: c) && grid.occupiedDirectionalCount(i: r, j: c) >= 5 {
                changed = true
                copy[r][c] = "L"
            }
        }
    }
//    copy.log()
    grid = copy
    return changed
}


//round1(grid: &grid)
//round2(grid: &grid)

while round1_2(grid: &grid) && round2_2(grid: &grid) {
    print("Apply!")
}

print("Done")

var ocCount = 0
for r in 1..<(grid.count - 1)  {
    for c in 1..<(grid[0].count - 1)  {
        if grid.isOccupied(i: r, j: c) { ocCount += 1 }
    }
}

print(ocCount)
