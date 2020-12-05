import UIKit

extension String {
    func char(at i: Int) -> Character {
        return self[index(startIndex, offsetBy: i)]
    }
}

var rows = Array(repeating: 0, count: 128)
for i in rows { rows[i] = i }
var columns = Array(repeating: 0, count: 8)
for i in columns { columns[i] = i }

var seats = Array(repeating: Array(repeating: false, count: 8), count: 128)


func getRowOrColumnNumber(_ input: String, fromInput: Int, toInput: Int, arr: [Int]) -> Int {
    var from = 0
    var to = arr.count - 1

    for i in fromInput...toInput {
        let c = input.char(at: i)
        let mid = from + (to - from) / 2
        switch c {
        case "F", "L": to = mid       // left half
        case "B", "R": from = mid + 1 // right half
            
        default: fatalError("unexpected row/column input \(c)")
        }
    }
    return from
}

// Main
guard let url = Bundle.main.url(forResource: "input", withExtension: "txt"),
      let content = try? String(contentsOf: url, encoding: .utf8) else {
    fatalError("Can't open file with url")
}

var maxId = Int.min
content.enumerateLines { line, _ in
    let R = getRowOrColumnNumber(line, fromInput: 0, toInput: 6, arr: rows) // first 7 chars
    let C = getRowOrColumnNumber(line, fromInput: 7, toInput: 9, arr: columns) // last 3 chars
    let ID = R * 8 + C
    seats[R][C] = true // taken seat
    maxId = max(maxId, ID)
}

print("Max ID is \(maxId)")

for r in 1..<(seats.count - 1) {
    for c in 0..<seats[0].count {
        // Get a missing seat (false) that doesn't have a missing seat above or below.
        if seats[r][c] == false && seats[r - 1][c] && seats[r + 1][c] {
            print("Seat with row \(r) and column \(c) is missing. ID: \(r * 8 + c)")
        }
    }
}
