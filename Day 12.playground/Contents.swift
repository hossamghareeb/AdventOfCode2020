import UIKit
enum Direction {
    case east
    case west
    case north
    case south
}

final class Ship {
    var x = 0
    var y = 0
    var manhattanDistance: Int { abs(x) + abs(y) }
    let directions: [Direction] = [.east, .south, .west, .north]
    
    var currentD = 0
    
    func apply(_ ins: [String]) {
        for s in ins {
            var s = s
            let action = s.removeFirst()
            let value = Int(s)!
            switch action {
            case "F":
                move(value, direction: directions[currentD])
            case "N":
                move(value, direction: .north)
            case "S":
                move(value, direction: .south)
            case "E":
                move(value, direction: .east)
            case "W":
                move(value, direction: .west)
            case "R":
                let count = value / 90
                currentD = (currentD + count) % directions.count
            case "L":
                let count = value / 90
                currentD -= count
                if currentD < 0 {
                    currentD += directions.count
                }
            default:
                assertionFailure("unexpected input")
            }
        }
    }
    func move(_ v: Int, direction: Direction) {
        switch direction {
        case .east: x += v
        case .west: x -= v
        case .north: y += v
        case .south: y -= v
        }
    }
}


guard let url = Bundle.main.url(forResource: "input1", withExtension: "txt"),
      let content = try? String(contentsOf: url, encoding: .utf8) else {
    fatalError("Can't open file with url")
}

let lines = content.split(separator: "\n").map { String($0) }

let ship = Ship()
ship.apply(lines)

print(ship.manhattanDistance)
