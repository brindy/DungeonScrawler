
import Foundation

protocol Location {

    var hint: String? { get }
    func describe()
    func look()
    func handle(command: String, args: [String], context: DungeonScrawler) -> Bool

}

class DungeonScrawler {

    let seed: Int
    let pc: PC

    let commands: [String: Command] = [
        "help": StandardCommands.help,
        "?": StandardCommands.help,
        "look": StandardCommands.look,
        "l": StandardCommands.look,
        "quit": StandardCommands.quit,
        "seed": StandardCommands.seed,
        "stats": StandardCommands.stats
    ]

    var location: Location = TownLocation() {
        didSet {
            print()
            location.describe()
        }
    }

    init(withSeed seed: Int, andPC pc: PC) {
        self.seed = seed
        self.pc = pc
    }

    func start() {
        location.describe()
        print()

        inputLoop { command, args in
            if commands[command]?.execute(args: args, context: self) ?? false {
                return true
            }

            return location.handle(command: command, args: args, context: self)
        }

    }

    func unknownCommand() -> String {
        return ["🤷‍♂️", "🤷‍♀️"].shuffled().first!
    }

    func inputLoop(handler: (String, [String]) -> Bool) {
        while(true) {
            print("> ", terminator: "")
            guard let command = readLine()?.trimmingCharacters(in: .whitespaces) else {
                exit(1)
            }

            guard command.count > 0 else {
                continue
            }

            let components = command.components(separatedBy: .whitespaces)
            if !handler(components.first!, Array<String>(components.dropFirst())) {
                print(unknownCommand())
            }

            print()
        }
    }

}

