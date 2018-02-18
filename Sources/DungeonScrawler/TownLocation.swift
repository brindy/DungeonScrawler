

class TownLocation: Location {

    func handle(command: String, args: [String], context: DungeonScrawler) -> Bool {

        if command == "visit" {
            handleVisit(args: args, context: context)
            return true
        }

        return false
    }

    func describe() {
        cprint("You are in the town.")
    }

    func look() {
        cprint("You can:")
        cprint("visit merchant (wip)")
        cprint("visit smithy (todo)")
        cprint("visit alchemist (todo)")
        cprint("visit dungeon (todo)")
    }

    var hint: String? {
        return "Try looking around."
    }

    private func handleVisit(args: [String], context: DungeonScrawler) {
        if args.count > 0 && args[0] == "merchant" {
            cprint("You head towards the ", 🎨.bold, args[0], ".")
            context.location = MerchantLocation()
        }
    }

}

class MerchantLocation: Location {

    var merchantInterest = 0

    var hint: String? {
        return "Try buying from the merchant's list, selling from your inventory or you could just leave."
    }

    func describe() {

        if merchantInterest < 1 {
            cprint("The merchant greets you excitedly, while glancing hopefully towards your coin purse.")
        } else if merchantInterest < 5 {
            cprint("You are visiting the merchant, who seems eager to serve.")
        } else if merchantInterest < 10 {
            cprint("You are visiting the merchant, who is starting to look bored.")
        } else {
            cprint("You are visiting the merchant, who is idly counting their money.")
        }
        merchantInterest += 1

    }

    func look() {
        cprint("You can buy and sell things here, eventually.")
    }

    func handle(command: String, args: [String], context: DungeonScrawler) -> Bool {
        if command == "leave" {
            cprint("You head towards the door. ", 🎨.italic, "\"Come back soon!\",", 🎨.reset, " the merchant says.")
            context.location = TownLocation()
            return true
        }
        return false
    }

}
