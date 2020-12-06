import Foundation

var str = "Hello, playground"

// Main
guard let url = Bundle.main.url(forResource: "input", withExtension: "txt"),
      let content = try? String(contentsOf: url, encoding: .utf8) else {
    fatalError("Can't open file with url")
}

var set = Set<Character>("abcdefghijklmnopqrstuvwxyz")
var sum = 0
content.enumerateLines { line, _ in
    if line == "" {
        // end of a group
        sum += set.count
        set = Set<Character>("abcdefghijklmnopqrstuvwxyz")
    } else {
        var tempSet = Set<Character>()
        line.forEach { tempSet.insert($0) }
        set = set.intersection(tempSet)
    }
}

// last group :D
sum += set.count

print(sum)
