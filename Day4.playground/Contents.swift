import UIKit

typealias Passport = [String: String]
typealias Validator = (String) -> Bool

extension NSRegularExpression {
    func matches(_ string: String) -> Bool {
        let range = NSRange(location: 0, length: string.utf16.count)
        return firstMatch(in: string, options: [], range: range) != nil
    }
}

let requiredFieldsKeys = Set(arrayLiteral: "byr", "iyr", "eyr", "hgt", "hcl", "ecl", "pid")

let requiredFields: [String: Validator] = [
    "byr": { $0.count == 4 && Int($0)! >= 1920 && Int($0)! <= 2002 },
    
    "iyr": { $0.count == 4 && Int($0)! >= 2010 && Int($0)! <= 2020 },

    "eyr": { $0.count == 4 && Int($0)! >= 2020 && Int($0)! <= 2030 },

    "hgt": { s in
        /**
         If cm, the number must be at least 150 and at most 193.
         If in, the number must be at least 59 and at most 76.
         */
        // \\b to match a full word not contains
        let regex = try! NSRegularExpression(pattern:
            "\\b(1[5-8][0-9]cm)|" + // 150-189cm
            "\\b(19[0-3]cm)|" +     // 190-193cm
            "\\b(59in)|" +          // exactly 59in
            "\\b(6[0-9]in)|" +      // 60-69in
            "\\b(7[0-6]in)")        // 70-76in
        return regex.matches(s)
    },

    "hcl": { s in
        let chars = Array(s)
        guard s.count == 7, chars[0] == "#" else { return false } // count is 7, first is #
        return chars[1..<chars.count].map { c -> Bool in
            // all 6 chars ascii is between 0 to 9 OR a to f
            let asc = c.asciiValue ?? 0
            return (asc >= Character("0").asciiValue! && asc <= Character("9").asciiValue!) ||
                   (asc >= Character("a").asciiValue! && asc <= Character("f").asciiValue!)
        }.reduce(true) { $0 && $1 }
    },

    "ecl": { Set(arrayLiteral: "amb", "blu", "brn", "gry", "grn", "hzl", "oth").contains($0) },

    "pid": { $0.count == 9 && Int($0) != nil },

    "cid": { s in return true } // Always true
]

func isPassportValid(_ p: Passport) -> Bool {
    let keysSet = Set(passport.keys)
    guard requiredFieldsKeys.isSubset(of: keysSet) else { return false }
    return p.map { requiredFields[$0]!($1) }.reduce(true) { $0 && $1 }
}

guard let url = Bundle.main.url(forResource: "input", withExtension: "txt"),
      let content = try? String(contentsOf: url, encoding: .utf8) else {
    fatalError("Can't open file with url")
}

var passport: Passport = [:]
var validPassportsCount = 0

content.enumerateLines { line, _ in
    guard line != "" else {
        // reached an end of passport
        if isPassportValid(passport) { validPassportsCount += 1 }

        passport.removeAll()
        return
    }
    line.split(separator: " ").forEach { field in
        let items = field.split(separator: ":")
        passport[String(items.first!)] = String(items.last!)
    }
}

// Bug: I forgot last passport :D
if isPassportValid(passport) {
    validPassportsCount += 1
}

print(validPassportsCount)
