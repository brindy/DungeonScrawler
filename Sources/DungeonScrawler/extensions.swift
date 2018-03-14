
import Foundation

// from: https://stackoverflow.com/questions/24026510/how-do-i-shuffle-an-array-in-swift#24029847
extension MutableCollection {
    /// Shuffles the contents of this collection.
    mutating func shuffle() {
        let c = count
        guard c > 1 else { return }

        for (firstUnshuffled, unshuffledCount) in zip(indices, stride(from: c, to: 1, by: -1)) {
            let d: IndexDistance = numericCast(arc4random_uniform(numericCast(unshuffledCount)))
            let i = index(firstUnshuffled, offsetBy: d)
            swapAt(firstUnshuffled, i)
        }
    }
}

// from: https://stackoverflow.com/questions/24026510/how-do-i-shuffle-an-array-in-swift#24029847
extension Sequence {
    /// Returns an array with the contents of this sequence, shuffled.
    func shuffled() -> [Element] {
        var result = Array(self)
        result.shuffle()
        return result
    }
}

extension Array {
    
    func random( withGenerator 🎲: inout RandomGenerator) -> Element {
        let index = 🎲.randomInt(max: count)
        return self[index]
    }
    
}

extension Dictionary {
    
    func randomKey( withGenerator 🎲: inout RandomGenerator) -> Key {
        let index = 🎲.randomInt(max: count)
        let key = Array(keys)[index]
        return key
    }
    
}

extension String {
    
    func readTextFile() -> String? {
        let url = URL(fileURLWithPath: self.starts(with: "/") ? self : "./\(self)")
        print("reading \(url)")
        return try? String(contentsOf: url)
    }
    
    subscript (i: Int) -> Character {
        return self[index(startIndex, offsetBy: i)]
    }

}
