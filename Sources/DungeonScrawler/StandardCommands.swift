
import Foundation

struct StandardCommands {

    static let look = LookCommand()
    static let help = HelpCommand()
    static let quit = QuitCommand()

}

protocol Command {

    func execute(args: [String], context: DungeonScrawler) -> Bool
    func help() -> String

}

class QuitCommand: Command {

    func execute(args: [String], context: DungeonScrawler) -> Bool {
        print("👋")
        exit(0)
    }

    func help() -> String {
        return "Quit the game."
    }

}

class LookCommand: Command {

    func execute(args: [String], context: DungeonScrawler) -> Bool {
        context.location.print()
        return true
    }

    func help() -> String {
        return "Show information about your current location."
    }

}

class HelpCommand: Command {

    func execute(args: [String], context: DungeonScrawler) -> Bool {

        var commands:[String: [String]] = [: ]
        for (key, command) in context.commands {
            let help = command.help()
            if commands[help] == nil {
                commands[help] = [key]
            } else {
                var keys = commands[help]
                keys?.append(key)
                commands[help] = keys
            }
        }

        print("Standard commands:")
        print()
        for (help, keys) in commands {
            print(keys.sorted().joined(separator: ", "), "➡", help)
        }

        return true
    }

    func help() -> String {
        return "Get help."
    }

}
