
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

        func walls() -> String {
            let x = (
                north != nil ? 1 : 0) +
                (east != nil ? 2 : 0) +
                (south != nil ? 4 : 0) +
                (west != nil ? 8 : 0)
            return String(format: "%x", x)
        }

    }

    var hint: String?

    let level: Int
    let seed: Int
    let map: [String]
    var room: Room

    init(seed: Int, level: Int) {
        self.seed = seed
        self.level = level

        let generator = DungeonGenerator(seed: seed, level: level)
        self.room = generator.buildDungeon()
        self.map = generator.map()
    }

    func describe() {
        cprint("You are in the dungeon at ", room.x, ", ", room.y)
        showExits()
    }

    func look() {
        cprint("The room is empty.")
    }

    func handle(command: String, args: [String], context: DungeonScrawler) -> Bool {

        switch(command) {
        case "go": return handleGo(args: args, context: context)
        case "map": return handleMap(context: context)
        default: return false
        }
    }

    private func handleMap(context: DungeonScrawler) -> Bool {

        for line in map {
            cprint(line)
        }

        return true
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
        let startingRoom = createRoom(x: 0, y: 0, "start")
        while (rooms.count < maxRooms) {
            let room = rooms.shuffled()[0]
            print(#function, room.x, room.y)
            buildDungeon(room, roomOdds: 4)
        }

        cprint(" enjoy!")
        return startingRoom
    }

    func map() -> [String] {

        var xMin = 0
        var yMin = 0
        var xMax = 0
        var yMax = 0

        for room in rooms {
            xMin = min(room.x, xMin)
            yMin = min(room.y, yMin)
            xMax = max(room.x, xMax)
            yMax = max(room.y, yMax)
        }

        yMin -= 1
        yMax += 1
        xMin -= 1
        xMax += 1

        var map = [String]()
        for y in yMin ... yMax {
            var line = ""
            for x in xMin ... xMax {

                if let room = roomAt(x, y) {
                    line += room.walls()
                } else {
                    line += "#"
                }

            }
            map.append(line)
        }
        return map
    }

    private func buildDungeon(_ room: DungeonLocation.Room, roomOdds: Int) {
        guard rooms.count < maxRooms else { return }

        switch(randomGenerator.random64(max: 4)) {
        case 0: room.north = createRoom(x: room.x, y: room.y - 1, "north")
        case 1: room.east = createRoom(x: room.x + 1, y: room.y, "east")
        case 2: room.south = createRoom(x: room.x, y: room.y + 1, "south")
        case 3: room.west = createRoom(x: room.x - 1, y: room.y, "west")
        default: return
        }

        if let other = room.north {
            other.south = room
            buildDungeon(other, roomOdds: roomOdds - 1)
        }

        if let other = room.east {
            other.west = room
            buildDungeon(other, roomOdds: roomOdds - 1)
        }

        if let other = room.south {
            other.north = room
            buildDungeon(other, roomOdds: roomOdds - 1)
        }

        if let other = room.west {
            other.east = room
            buildDungeon(other, roomOdds: roomOdds - 1)
        }
    }

    private func createRoom(x: Int, y: Int, _ direction: String) -> DungeonLocation.Room {
        cprint(".", terminator: "")
        if let room = roomAt(x, y) {
            return room
        }
        let room = DungeonLocation.Room(x: x, y: y)
        rooms.append(room)
        return room
    }

    private func roomAt(_ x: Int, _ y: Int) -> DungeonLocation.Room? {
        for room in rooms {
            if room.x == x && room.y == y {
                return room
            }
        }
        return nil
    }

}
