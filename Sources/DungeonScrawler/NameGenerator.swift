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
    
    convenience init(seed: Int, basedOnSampleNames sampleNames: [String]) {
        self.init(seed: seed, usingTable: NameGenerator.createTable(fromSampleNames: sampleNames))
    }
    
    static func createTable(fromSampleNames sampleNames: [String]) -> [String: [String]] {
        var table = [String: [String]]()
        
        let cleanNames = Array(Set(sampleNames)).map({ $0
            .replacingOccurrences(of: " ", with: "")
            .replacingOccurrences(of: "-", with: "")
            .lowercased()
        })
        
        for name in cleanNames {
            
            var prefixes = [String]()
            for index in 0 ..< name.count {
                guard let suffixes = name.accumulate(from: index, length: 3), !suffixes.isEmpty else { continue }
                
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
                prefixes = prefixes.filter({ $0.count <= 3 })
            }

        }
        
        return table
    }
    
    func generate() -> String {
        // TODO randomly pick 1, 2 or 3 words and only put separators between them, rather than generating
        
        let length = 🎲.randomInt(max: 7) + 3
        
        var separator = ""
        var next: String? = table.filter({ $0.value.count > 0 }).randomKey(withGenerator: &🎲)
        var name = ""
        while(name.count < length && next != nil) {
            name = "\(name)\(separator)\(next!)"
            next = nextPart(next)

            if separator.isEmpty && 🎲.randomInt(max: 50) == 0 {
                switch (🎲.randomClosed()) {
                case 0 ..< 0.3: separator = "'"
                case 0.3 ..< 0.7: separator = "-"
                default: separator = " "
                }
            } else {
                separator = ""
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

extension String {
    
    func accumulate(from start: Int, length: Int) -> [String]? {
        var parts = [String]()
        
        var part = ""
        for offset in 1 ..< length {
            let index = start + offset
            guard index < count else { return parts }
            
            let char = self[index]
            part += String(char)
            
            parts.append(part)
        }
        
        return parts.isEmpty ? nil : parts
    }
    
}
