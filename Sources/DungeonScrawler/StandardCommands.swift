
import Foundation

class QuitCommand: Command {

    func execute(args: [String], context: DungeonScrawler) -> Bool {
        print("👋")
        exit(0)
    }

}

class LookCommand: Command {

    func execute(args: [String], context: DungeonScrawler) -> Bool {
        context.location.print()
        return true
    }

}

class HelpCommand: Command {

    func execute(args: [String], context: DungeonScrawler) -> Bool {
        print("help!")
        return true
    }

}
