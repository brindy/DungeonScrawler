
import Foundation

protocol Location {

    func print()
    func handle(command: String, args: [String]) -> Bool
    func help()

}

class DungeonScrawler {

    let seed: Int

    let commands: [String: Command] = [
        "help": StandardCommands.help,
        "?": StandardCommands.help,
        "look": StandardCommands.look,
        "l": StandardCommands.look,
        "quit": StandardCommands.quit
    ]

    var location: Location = TownLocation()

    init(seed: Int) {
        self.seed = seed
    }

    func start() {
        _ = LookCommand().execute(args: [], context: self)
        print()

        inputLoop { command, args in

            if commands[command]?.execute(args: args, context: self) ?? false {
                return true
            }

            if location.handle(command: command, args: args) {
                return true
            }

            return false
        }

    }

    func unknownCommand() -> String {
        return ["🤷‍♂️", "🤷‍♀️"].shuffled().first!
    }

    func inputLoop(handler: (String, [String]) -> Bool) {
        while(true) {
            print("> ", terminator: "")
            guard let command = readLine() else {
                exit(1)
            }

            guard command.trimmingCharacters(in: .whitespaces).count > 0 else {
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

class TownLocation: Location {

    func handle(command: String, args: [String]) -> Bool {
        return false
    }

    func print() {
        Swift.print("You are in the town.")
    }

    func help() {
        Swift.print("Try looking around.")
    }

}
