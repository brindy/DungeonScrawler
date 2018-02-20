
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
        
} else {
    
    // Play the game!
    DungeonScrawler(seed: seed).start()
}
