import Foundation

guard let url = Bundle.main.url(forResource: "temp", withExtension: "txt"),
      let content = try? String(contentsOf: url, encoding: .utf8) else {
    fatalError("Can't open file with url")
}

let lines = content.split(separator: "\n")
let arrive = Int(lines[0])!
let ids = lines[1].split(separator: ",").filter { $0 != "x" }.map { Int($0)! }
let ids2 = lines[1].split(separator: ",").map { Int($0) ?? 0 }

func solve2(_ ids: [Int]) -> Int {
    let x = ids[0]
    var sum = x
    while true {
        sum += x
//        print(x)
        var found = true
        for i in 1..<ids.count {
            if ids[i] == 0 { continue }
            if (sum + i) % ids[i] != 0 {
                found = false
                break
            }
        }
        if found { return sum }
    }
    
}
func solve1(_ arrive: Int, _ ids: [Int]) -> Int {
//    939/7 = 134.x
//    135 * 7 = 945
//
//    939/13 = 72.x
//    73 * 13 = 949
//
//    939 / 59 = 15.9
//    16 * 59 = 944
    
    var minTime = Int.max
    var minId = 0
    
    for id in ids {
        let units = Int(ceil(Double(arrive) / Double(id)))
        let time = units * id
        if time < minTime {
            minTime = time
            minId = id
        }
    }
    return (minTime - arrive) * minId
}

let d = Date()
print(solve2(ids2))

print(Calendar.current.dateComponents([.second], from: d, to: Date()))
