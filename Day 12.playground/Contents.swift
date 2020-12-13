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
    var waypointX = 10
    var waypointY = 1
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
                x += value * waypointX
                y += value * waypointY
            case "N":
                moveWayPoint(value, direction: .north)
            case "S":
                moveWayPoint(value, direction: .south)
            case "E":
                moveWayPoint(value, direction: .east)
            case "W":
                moveWayPoint(value, direction: .west)
            case "R":
                let count = value / 90
                for _ in 1...count {
                    let x = waypointX
                    let y = waypointY
                    waypointX = y
                    waypointY = -x
                }
//                currentD = (currentD + count) % directions.count
            case "L":
                let count = value / 90
                for _ in 1...count {
                    let x = waypointX
                    let y = waypointY
                    waypointX = -y
                    waypointY = x
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
    
    func moveWayPoint(_ v: Int, direction: Direction) {
        switch direction {
        case .east: waypointX += v
        case .west: waypointX -= v
        case .north: waypointY += v
        case .south: waypointY -= v
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
