
import Foundation

// Number of rooms = ((level * 10) ^ 0.8) + 4
class DungeonLocation: Location {

    class Room {

        var north: Room?
        var east: Room?
        var south: Room?
        var west: Room?

        let x: Int
        let y: Int

        init(x: Int, y: Int) {
            self.x = x
            self.y = y
        }

    }

    var hint: String?

    let level: Int
    let seed: Int
    var room: Room

    init(seed: Int, level: Int) {
        self.seed = seed
        self.level = level
        self.room = DungeonGenerator(seed: seed, level: level).buildDungeon()
    }

    func describe() {
        cprint("You are in the dungeon at ", room.x, ", ", room.y)
        showExits()
    }

    func look() {
    }

    func handle(command: String, args: [String], context: DungeonScrawler) -> Bool {

        switch(command) {
        case "go": return handleGo(args: args, context: context)
        default: return false
        }
    }

    private func showExits() {
        var exits = [String]()
        if room.north != nil {
            exits.append("north")
        }

        if room.east != nil {
            exits.append("east")
        }

        if room.south != nil {
            exits.append("south")
        }

        if room.west != nil {
            exits.append("west")
        }

        cprint("Exits are: ", exits)
    }

    private func handleGo(args: [String], context: DungeonScrawler) -> Bool {
        guard args.count > 0 else { return false }

        let direction = args[0]
        switch(direction) {
        case "north": return go(room.north, direction: direction, context: context)
        case "east": return go(room.east, direction: direction, context: context)
        case "south": return go(room.south, direction: direction, context: context)
        case "west": return go(room.west, direction: direction, context: context)
        default: return false
        }

    }

    private func go(_ room: Room?, direction: String, context: DungeonScrawler) -> Bool {
        guard let room = room else { return false }
        cprint("Heading ", direction, ". (", room.x, ", ", room.y, ")")
        self.room = room
        context.location = self
        return true
    }

}

extension RandomGenerator {

    mutating func randomBool() -> Bool {
        return randomHalfOpen() > 0.5
    }

}

class DungeonGenerator {

    var randomGenerator: RandomGenerator
    let maxRooms: Int
    let level: Int

    var rooms = [DungeonLocation.Room]()

    init(seed: Int, level: Int) {
        self.level = level
        randomGenerator = MersenneTwister(seed: UInt64(seed))
        maxRooms = Int(pow((Double(level) * 10), 0.8) + 4)
    }

    func buildDungeon() -> DungeonLocation.Room {
        cprint("Generating level ", level, " ", terminator: "")
        let startingRoom = createRoom(x: 0, y: 0)
        while (rooms.count < maxRooms) {
            buildDungeon(startingRoom)
        }

        cprint(" enjoy!")
        return startingRoom
    }

    private func buildDungeon(_ room: DungeonLocation.Room) {
        guard rooms.count < maxRooms else { return }

        room.north = randomGenerator.randomBool() ? createRoom(x: room.x, y: room.y - 1) : room.north
        room.east = randomGenerator.randomBool() ? createRoom(x: room.x + 1, y: room.y) : room.east
        room.south = randomGenerator.randomBool() ? createRoom(x: room.x, y: room.y + 1) : room.south
        room.west = randomGenerator.randomBool() ? createRoom(x: room.x - 1, y: room.y) : room.west

        if let other = room.north {
            other.south = room
            buildDungeon(other)
        }

        if let other = room.east {
            other.west = room
            buildDungeon(other)
        }

        if let other = room.south {
            other.north = room
            buildDungeon(other)
        }

        if let other = room.west {
            other.east = room
            buildDungeon(other)
        }
    }

    private func createRoom(x: Int, y: Int) -> DungeonLocation.Room {
        cprint(".", terminator: "")
        // print(#function, x, y)
        for room in rooms {
            if room.x == x && room.y == y {
                // print(#function, "room already exists at", x, y)
                return room
            }
        }
        let room = DungeonLocation.Room(x: x, y: y)
        rooms.append(room)
        return room
    }

}
