
import Foundation

protocol Location {

    func print()
    func handle(command: String, args: [String]) -> Bool

}

protocol Command {

    func execute(args: [String], context: DungeonScrawler) -> Bool

}

class DungeonScrawler {

    let seed: Int

    let commands: [String: Command] = [
        "help": HelpCommand(),
        "?": HelpCommand(),
        "look": LookCommand(),
        "l": LookCommand(),
        "quit": QuitCommand()
    ]

    var location: Location = TownLocation()

    init(seed: Int) {
        self.seed = seed
    }

    func start() {
        _ = LookCommand().execute(args: [], context: self)

        inputLoop { command, args in

            if commands[command]?.execute(args: args, context: self) ?? false {
                return
            }

            if location.handle(command: command, args: args) {
                return
            }

            print(unknownCommand())
        }

    }

    func unknownCommand() -> String {
        return ["🤷‍♂️", "🤷‍♀️"].shuffled().first!
    }

    func inputLoop(handler: (String, [String]) -> Void) {
        while(true) {
            print("> ", terminator: "")
            guard let command = readLine() else {
                exit(1)
            }

            guard command.trimmingCharacters(in: .whitespaces).count > 0 else {
                continue
            }

            let components = command.components(separatedBy: .whitespaces)
            handler(components.first!, Array<String>(components.dropFirst()))
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

}
