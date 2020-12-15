import UIKit

extension Int {
    func binary(maxLen: Int) -> String {
        let bin = String(self, radix: 2)
        var str = bin
        for _ in 0..<(maxLen - bin.count) {
            str = "0" + str
        }
        return str
    }
}

extension String {
    func apply(mask: [Character]) -> String {
        var chars = Array(self)
        for i in (0..<count).reversed() {
            chars[i] = mask[i] == "X" ? chars[i] : mask[i]
        }
        return String(chars)
    }
    
    func apply2(mask: [Character]) -> String {
        var chars = Array(self)
        for i in (0..<count).reversed() {
            chars[i] = mask[i] == "0" ? chars[i] : mask[i]
        }
        return String(chars)
    }
}

func solve1(input: String) -> Int{
    let lines = input.split(separator: "\n")
    var mask = [Character]()
    var memory = [Int: Int]()
    for line in lines {
        if line.contains("mask") {
            mask = Array(line.components(separatedBy: "= ")[1])
            continue
        }
        let numbers = line.components(separatedBy: CharacterSet.decimalDigits.inverted).filter { $0 != "" }
        let address = Int(numbers.first!)!
        let value = Int(numbers.last!)!
        let valueInBin = value.binary(maxLen: 36)
        let newValue = valueInBin.apply(mask: mask)
        memory[address] = Int(newValue, radix: 2)
    }
    return memory.values.reduce(0, +)
}

func solve2(input: String) -> Int{
    let lines = input.split(separator: "\n")
    var mask = [Character]()
    var memory = [Int: Int]()
    for line in lines {
        if line.contains("mask") {
            mask = Array(line.components(separatedBy: "= ")[1])
            continue
        }
        let numbers = line.components(separatedBy: CharacterSet.decimalDigits.inverted).filter { $0 != "" }
        let address = Int(numbers.first!)!
        let value = Int(numbers.last!)!
        let addressInBin = address.binary(maxLen: 36)
        let newAddress = addressInBin.apply2(mask: mask) // has X's
        let newAddressChars = Array(newAddress)
        var fIndexs = [Int]()
        for i in 0..<newAddressChars.count { if newAddressChars[i] == "X" { fIndexs.append(i) } }
        let combinations = NSNumber(value: pow(2, Double(fIndexs.count))).intValue
        for i in 0..<combinations {
            let comChars = Array(i.binary(maxLen: fIndexs.count))
            var comAddress = newAddressChars
            var j = 0
            for index in fIndexs {
                comAddress[index] = comChars[j]
                j += 1
            }
            let address = String(comAddress)
            memory[Int(address, radix: 2)!] = value
        }
        
    }
    return memory.values.reduce(0, +)
}

/// main
guard let url = Bundle.main.url(forResource: "input", withExtension: "txt"),
      let content = try? String(contentsOf: url, encoding: .utf8) else {
    fatalError("Can't open file with url")
}


print(solve2(input: content))
