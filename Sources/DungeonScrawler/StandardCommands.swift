
import Foundation

struct StandardCommands {

    static let look = LookCommand()
    static let help = HelpCommand()
    static let quit = QuitCommand()
    static let seed = SeedCommand()
    static let stats = StatsCommand()
    
}

protocol Command {

    func execute(args: [String], context: DungeonScrawler) -> Bool
    func help() -> String

}

class StatsCommand: Command {
    
    func execute(args: [String], context: DungeonScrawler) -> Bool {
        cprint("You are: ", 🎨.green, context.pc.name)
        cprint()
        
        with(context.pc) {
            
            cprint(🎨.bold, "Stats:")
            with($0.stats) {
                cprint("Strength: ", 🎨.blue, $0.strength)
                cprint("Dexterity: ", 🎨.blue, $0.dexterity)
                cprint("Power: ", 🎨.blue, $0.power)
                cprint("Constitution: ", 🎨.blue, $0.constitution)
            }

            with($0.points) {
                cprint()
                cprint(🎨.bold, "Hit Points: ", 🎨.blue, $0.hitPoints)
                
                cprint()
                cprint(🎨.bold, "Magic Points: ", 🎨.blue, $0.magicPoints)
                
                cprint()
                cprint(🎨.bold, "Experience Points: ", 🎨.blue, $0.experience)
            }
            
        }
        
        return true
    }
    
    func help() -> String {
        return "Shows your character's stats."
    }
    
}

class SeedCommand: Command {
    
    func execute(args: [String], context: DungeonScrawler) -> Bool {
        cprint(context.seed)
        cprint()
        return true
    }
    
    func help() -> String {
        return "Shows the seed used for this game."
    }
    
}

class QuitCommand: Command {

    func execute(args: [String], context: DungeonScrawler) -> Bool {
        cprint("👋")
        exit(0)
    }

    func help() -> String {
        return "Quit the game."
    }

}

class LookCommand: Command {

    func execute(args: [String], context: DungeonScrawler) -> Bool {
        context.location.describe()
        print()
        context.location.look()
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

        cprint("Standard commands:")
        cprint()
        for (help, keys) in commands.sorted(by: { $0.key < $1.key }) {
            cprint(keys.sorted(by: { $0.count > $1.count }).joined(separator: ", "), " ➡ ", help)
        }

        if let hint = context.location.hint {
            cprint()
            cprint(🎨.italic, "Hint: ", hint)
        }

        return true
    }

    func help() -> String {
        return "Get help."
    }

}
