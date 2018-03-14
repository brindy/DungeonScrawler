//
//  NameGenerator.swift
//  DungeonScrawlerPackageDescription
//
//  Created by Chris Brind on 13/03/2018.
//

import Foundation

class NameGenerator {
    
    let table: [String: [String]]
    let seed:Int
    
    lazy var 🎲: RandomGenerator = {
        return MersenneTwister(seed: UInt64(seed))
    }()
    
    init(seed: Int, usingTable table: [String: [String]]) {
        guard !table.isEmpty else { fatalError("table is empty") }
        self.seed = seed
        self.table = table
    }
    
    static func createTable(fromSampleNames sampleNames: [String]) -> [String: [String]] {
        var table = [String: [String]]()
        
        let cleanNames = sampleNames.map({ $0
            .replacingOccurrences(of: " ", with: "")
            .replacingOccurrences(of: "-", with: "")
            .lowercased()
        })
        
        let maxFix = 3
        
        for name in Set(cleanNames) {
            
            var prefixes = [String]()
            for index in 0 ..< name.count {
                guard let suffixes = name.accumulate(from: index, length: maxFix), !suffixes.isEmpty else { continue }
                
                // each suffix is also a key in the table
                for suffix in suffixes {
                    guard table[suffix] == nil else { continue }
                    table[suffix] = []
                }
                
                // add each suffix to each current prefix
                for prefix in prefixes {
                    table[prefix]? += suffixes
                }

                // append the current character at index to each current prefix, e.g. go -> gob
                prefixes = prefixes.map({ $0 + suffixes[0] })

                // add the current character to the list of known prefixes
                prefixes.append(suffixes[0])
                
                // remove any that are no longer within the size constraints
                prefixes = prefixes.filter({ $0.count <= maxFix })
            }

        }
        
        return table
    }
    
    func generate() -> String {
        var name = shortName()
        var separators = ["'", "-", " "]
        for _ in 0 ..< separators.count {
            (name, separators) = append(name, separators)
        }
        return name
    }
    
    private func append(_ name: String, _ separators: [String]) -> (name: String, separator: [String]) {
        var newName = name
        var separator: String? = nil
        if 🎲.randomInt(max: 10) == 0 {
            separator = separators.random(withGenerator: &🎲)
            newName = "\(name)\(separator!)\(shortName())"
        }
        return (newName, separators.filter({ $0 != separator }))
    }
    
    private func shortName() -> String {
        
        var name = ""
        while !name.hasVowel() {
            let length = 🎲.randomInt(max: 5) + 3
            var next: String? = table.filter({ $0.value.count > 0 }).randomKey(withGenerator: &🎲)
            while(name.count < length && next != nil) {
                name = "\(name)\(next!)"
                next = nextPart(next)
            }
        }
        
        return name
    }
    
    private func nextPart(_ last: String?) -> String? {
        guard let last = last else {
            return nil
        }
        
        guard let possibleParts = table[last], !possibleParts.isEmpty else {
            return nil
        }

        return possibleParts.random(withGenerator: &🎲)
    }
    
}


fileprivate extension String {

    func hasVowel() -> Bool {
        let vowels = "aeiou"
        return contains(where: { vowels.contains($0) })
    }
    
    func accumulate(from start: Int, length: Int) -> [String]? {
        var parts = [String]()
        
        var part = ""
        for offset in 0 ..< length {
            let index = start + offset
            guard index < count else { return parts }
            
            let char = self[index]
            part += String(char)
            
            parts.append(part)
        }
        
        return parts.isEmpty ? nil : parts
    }
    
}
