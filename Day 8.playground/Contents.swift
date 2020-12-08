import Foundation

enum Operation {
    case noop(Int)
    case jump(Int)
    case acc(Int)

    init(instruction: String) {
        let parts = instruction.split(separator: " ")
        guard let num = Int(parts[1]) else { fatalError("Can't parse") }
        switch parts[0] {
        case "nop": self = .noop(num)
        case "jmp": self = .jump(num)
        case "acc": self = .acc(num)
        default: fatalError("unexpected instruction")
        }
    }
}

class Program {
    var accumelator: Int = 0
    let operations: [Operation]
    var visited: [Bool]

    init(operations: [Operation]) {
        self.operations = operations
        visited = [Bool](repeating: false, count: operations.count)
    }

    func run(operations: [Operation]) -> Bool {
        accumelator = 0
        visited = [Bool](repeating: false, count: operations.count)
        var i = 0
        while i < operations.count {
            if visited[i] { return false }
            visited[i] = true
            switch operations[i] {
            case .noop: i += 1
            case .acc(let x):
                accumelator += x
                i += 1
            case .jump(let x):  i += x
            }
        }
        return true
    }
}


// Main

guard let url = Bundle.main.url(forResource: "input", withExtension: "txt"),
      let content = try? String(contentsOf: url, encoding: .utf8) else {
    fatalError("Can't open file with url")
}

let operations = content.split(separator: "\n").map { Operation(instruction: String($0)) }
let p = Program(operations: operations)
p.run(operations: p.operations)
// Part 1
// print(p.accumelator)


// Part 2
var tofix = [Int]()
for i in 0..<p.visited.count {
    if p.visited[i] { tofix.append(i) }
}

for j in tofix {
    switch p.operations[j] {
    case .acc: continue
    case .jump(let x):
        if x == 1 { continue } // useless fix
        var tempP = p.operations
        tempP[j] = .noop(x)
        if p.run(operations: tempP) {
            print("Found it! \(p.accumelator)")
            abort()
        }
    case .noop(let x):
        if x == 0 || x == 1 { continue } // useless fix
        var tempP = p.operations
        tempP[j] = .jump(x)
        if p.run(operations: tempP) {
            print("Found it! \(p.accumelator)")
            abort()
        }
    }
}

