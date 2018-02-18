

class TownLocation: Location {

    func handle(command: String, args: [String], context: DungeonScrawler) -> Bool {

        if command == "visit" {
            handleVisit(args: args, context: context)
            return true
        }

        return false
    }

    func describe() {
        print("You are in the town.")
    }

    func look() {
        print("You can:")
        print("visit merchant (wip)")
        print("visit smithy (todo)")
        print("visit alchemist (todo)")
        print("leave town (todo)")
    }

    var hint: String? {
        return "Try looking around."
    }

    private func handleVisit(args: [String], context: DungeonScrawler) {
        if args.count > 0 && args[0] == "merchant" {
            print("You head towards the", args[0], terminator: ".\n")
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
            print("The merchant greets you excitedly, while glancing hopefully towards your coin purse.")
        } else if merchantInterest < 5 {
            print("You are visiting the merchant, who seems eager to serve.")
        } else if merchantInterest < 10 {
            print("You are visiting the merchant, who is starting to look bored.")
        } else {
            print("You are visiting the merchant, who is idly counting their money.")
        }
        merchantInterest += 1

    }

    func look() {
        print("You can buy and sell things here, eventually.")
    }

    func handle(command: String, args: [String], context: DungeonScrawler) -> Bool {
        if command == "leave" {
            print("You head towards the door. \"Come back soon!\", the merchant says.")
            context.location = TownLocation()
            return true
        }
        return false
    }

}
