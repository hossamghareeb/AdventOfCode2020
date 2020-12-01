import UIKit

func reportRepairP1(nums: [Int]) -> Int {

    let set = Set(numbers)
    for n in numbers {
        let target = 2020 - n
        if set.contains(target) {
            return n * target
        }
    }
    fatalError("Not Found!")
}

func reportRepairP2(nums: [Int]) -> Int {
    let set = Set(nums)
    for i in 0..<nums.count {
        for j in (i + 1)..<nums.count {
            let target = 2020 - nums[i] - nums[j]
            if set.contains(target) {
                print(nums[i])
                print(nums[j])
                print(target)
                return nums[i] * nums[j] * target
            }
        }

    }
    fatalError("Not Found!")
}

guard let url = Bundle.main.url(forResource: "input1", withExtension: "txt"),
      let content = try? String(contentsOf: url, encoding: .utf8) else {
    fatalError("Can't open file with url")
}

let numbers = content.split(separator: "\n").map { Int($0)! }

print(reportRepairP2(nums: numbers))
