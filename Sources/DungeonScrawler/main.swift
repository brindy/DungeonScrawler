
import Foundation

print(#function, "v1.0")

var seed = Int(Date().timeIntervalSince1970 * 1000)
if CommandLine.arguments.count > 1 {
    guard let providedSeed = Int(CommandLine.arguments[1]) else {
        print("USAGE: ", #function, "[seed]")
        exit(1)
    }
    seed = providedSeed
}
print("Seed:", seed)
print()

DungeonScrawler(seed: seed).start()
