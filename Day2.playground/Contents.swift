import UIKit

extension String {
    func char(at i: Int) -> Character {
        return self[index(startIndex, offsetBy: i)]
    }
}

struct PasswordPolicy {
    let range: ClosedRange<Int>
    let char: Character

    func validateP1(password p: String) -> Bool {
        var dict = [Character: Int]()
        for c in p { dict[c, default: 0] += 1 }
        guard let count = dict[char] else { return false } // char policy not found
        return range.contains(count)
    }

    func validateP2(password p: String) -> Bool {
        let c1 = p.char(at: range.lowerBound - 1)
        let c2 = p.char(at: range.upperBound - 1)
        if c1 == char && c2 == char { return false } // both are equal
        if c1 == char || c2 == char { return true } // Only one
        return false
    }
}

extension PasswordPolicy {
    init(policy: String) {
        char = policy.last!
        let rangeArr = policy.components(separatedBy: " ").first!.split(separator: "-")
        range = Int(rangeArr[0])!...Int(rangeArr[1])!
    }
}

guard let url = Bundle.main.url(forResource: "input", withExtension: "txt"),
      let content = try? String(contentsOf: url, encoding: .utf8) else {
    fatalError("Can't open file with url")
}

let lines = content.split(separator: "\n")
var validCount = 0
for line in lines {
    let parts = line.components(separatedBy: ": ")
    let password = parts[1]
    let policy = PasswordPolicy(policy: parts[0])
    if policy.validateP2(password: password) {
        validCount += 1
    }
}

print(validCount)
