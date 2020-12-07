import UIKit

final class Node {
    let colorName: String
    var adjacencyList: [(Node, Int)] = []
    init(colorName: String) {
        self.colorName = colorName
    }

    var count: Int { return 1 + adjacencyList.reduce(0) { $0 + $1.1 * $1.0.count } }
}

extension Node: Equatable {
    static func == (lhs: Node, rhs: Node) -> Bool {
        return lhs.colorName == rhs.colorName
    }
}

func dfs(source: Node, destination:  Node) -> Bool {

    if source === destination { return true }
    for s in source.adjacencyList {
        if dfs(source: s.0, destination: destination) { return true }
    }
    return false
}

// Main

var dict: [String: Node] = [:]

guard let url = Bundle.main.url(forResource: "input", withExtension: "txt"),
      let content = try? String(contentsOf: url, encoding: .utf8) else {
    fatalError("Can't open file with url")
}

/// Creating the graph
content.enumerateLines { line, _ in
    let parts = line.components(separatedBy: " bags contain ")
    let bagColorName = parts[0]
    let bag = dict[bagColorName, default: Node(colorName: bagColorName)]
    dict[bagColorName] = bag
    if parts[1] == "no other bags." { return }
    let bagContent = parts[1].components(separatedBy: ", ")
    for c in bagContent {
        let scanner = Scanner(string: c)
        let num = scanner.scanInt()!
        let color = scanner.scanUpToString(" bag")!
        let subBag = dict[color, default: Node(colorName: color)]
        dict[color] = subBag

        bag.adjacencyList.append((subBag, num))
    }
}

func solvePart1() {
    var count = 0
    let myBag = dict["shiny gold"]!

    for n in dict.values {
        if n == myBag { continue } // Ignore my bag
        if dfs(source: n, destination: myBag)  {
            count += 1
        }
    }
    print(count)
}

func solvePart2() {
    let myBag = dict["shiny gold"]!
    print(myBag.count - 1) // - 1 exclude my shiny bag
}

solvePart2()

