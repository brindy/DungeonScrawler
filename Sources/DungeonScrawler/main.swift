
import Foundation

extension CommandLine {

    static func argNamed(_ name: String) -> String? {
        for index in 0 ..< arguments.count - 1 {
            let arg = arguments[index]
            if "--\(name)" == arg {
                return arguments[index + 1]
            }
        }
        return nil
    }

}

let seed = Int(CommandLine.argNamed("seed") ?? "") ?? Int(Date().timeIntervalSince1970 * 1000)
🎨.isEnabled = "true" != CommandLine.argNamed("disable-colours")

cprint(🎨.bold, #function, 🎨.reset, 🎨.green, " v1.0")
cprint("Seed: ", seed)
cprint()

if let maps = Int(CommandLine.argNamed("maps") ?? "") {

    // Generate maps
    for level in 1 ... maps {
        let generator = DungeonGenerator(seed: seed, level: level)
        let dungeon = generator.buildDungeon()

        cprint("Level ", level, ". ", dungeon.rooms.count, " rooms.")
        dungeon.printMap()
        cprint()
    }

} else if let names = Int(CommandLine.argNamed("names") ?? ""),
        let file = CommandLine.argNamed("file") {

    guard let sampleNames = file.readTextFile()?.components(separatedBy: "\n").filter({ !$0.isEmpty }) else {
        cprint("Unable to read \(file)")
        exit(1)
    }

    let table = NameGenerator.createTable(fromSampleNames: sampleNames)
    if let jsonData = try? JSONSerialization.data(withJSONObject: table, options: .prettyPrinted), let json = String(data: jsonData, encoding: .utf8) {
        print(json)
    }

    let generator = NameGenerator(seed: seed, usingTable: table)
    for _ in 0 ..< names {
        cprint(generator.generate().capitalized)
    }

} else {

    // Play the game!
    guard let pc = PCGenerator().start() else { exit(1) }
    DungeonScrawler(withSeed: seed, andPC: pc).start()

}

