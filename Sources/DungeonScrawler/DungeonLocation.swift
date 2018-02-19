
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
    let dungeon: Dungeon
    
    var currentRoom: Room

    init(seed: Int, level: Int) {
        self.seed = seed
        self.level = level

        let generator = DungeonGenerator(seed: seed, level: level)
        dungeon = generator.buildDungeon()
        currentRoom = dungeon.rooms[0]
    }

    func describe() {
        cprint("You are in the dungeon at ", currentRoom.x, ", ", currentRoom.y)
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

        let map = dungeon.map()
        
        for line in map {
            cprint(line)
        }

        return true
    }

    private func showExits() {
        var exits = [String]()
        if currentRoom.north != nil {
            exits.append("north")
        }

        if currentRoom.east != nil {
            exits.append("east")
        }

        if currentRoom.south != nil {
            exits.append("south")
        }

        if currentRoom.west != nil {
            exits.append("west")
        }

        cprint("Exits are: ", exits)
    }

    private func handleGo(args: [String], context: DungeonScrawler) -> Bool {
        guard args.count > 0 else { return false }

        let direction = args[0]
        switch(direction) {
        case "north": return go(currentRoom.north, direction: direction, context: context)
        case "east": return go(currentRoom.east, direction: direction, context: context)
        case "south": return go(currentRoom.south, direction: direction, context: context)
        case "west": return go(currentRoom.west, direction: direction, context: context)
        default: return false
        }

    }

    private func go(_ room: Room?, direction: String, context: DungeonScrawler) -> Bool {
        guard let room = room else { return false }
        cprint("Heading ", direction, ". (", room.x, ", ", room.y, ")")
        currentRoom = room
        context.location = self
        return true
    }

    
}

struct Dungeon {
    
    var rooms = [DungeonLocation.Room]()
    
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
                    line += "."
                }
                
            }
            map.append(line)
        }
        return map
    }
    
    func roomAt(_ x: Int, _ y: Int) -> DungeonLocation.Room? {
        for room in rooms {
            if room.x == x && room.y == y {
                return room
            }
        }
        return nil
    }


}

class DungeonGenerator {

    var randomGenerator: RandomGenerator
    let minRooms: Int
    let level: Int

    var dungeon = Dungeon()

    init(seed: Int, level: Int) {
        self.level = level
        randomGenerator = MersenneTwister(seed: UInt64(seed))
        minRooms = Int(pow((Double(level) * 10), 0.8) + 4)
    }

    func buildDungeon() -> Dungeon {
        cprint("Generating level ", level, " ", terminator: "")
        _ = createRoom(x: 0, y: 0)

        while (dungeon.rooms.count < minRooms) {
            let room = dungeon.rooms[randomGenerator.randomInt(max: dungeon.rooms.count)]
            buildDungeon(room)
        }

        cprint(" enjoy!")
        return dungeon
    }


    private func buildDungeon(_ room: DungeonLocation.Room) {
        guard dungeon.rooms.count < minRooms else { return }

        switch(randomGenerator.randomInt(max: 4)) {
        case 0: room.north = createRoom(x: room.x, y: room.y - 1)
        case 1: room.east = createRoom(x: room.x + 1, y: room.y)
        case 2: room.south = createRoom(x: room.x, y: room.y + 1)
        case 3: room.west = createRoom(x: room.x - 1, y: room.y)
        default: fatalError()
        }

        if let other = room.north {
            other.south = room
            travel(from: other, direction: 0, distance: randomGenerator.randomInt(max: level))
        }

        if let other = room.east {
            other.west = room
            travel(from: other, direction: 1, distance: randomGenerator.randomInt(max: level))
        }

        if let other = room.south {
            other.north = room
            travel(from: other, direction: 2, distance: randomGenerator.randomInt(max: level))
        }

        if let other = room.west {
            other.east = room
            travel(from: other, direction: 3, distance: randomGenerator.randomInt(max: level))
        }
    }

    private func travel(from room: DungeonLocation.Room, direction: Int, distance: Int) {

        guard distance > 0 else { return }

        switch(direction) {
        case 0: room.north = createRoom(x: room.x, y: room.y - 1)
        case 1: room.east = createRoom(x: room.x + 1, y: room.y)
        case 2: room.south = createRoom(x: room.x, y: room.y + 1)
        case 3: room.west = createRoom(x: room.x - 1, y: room.y)
        default: fatalError()
        }

        if let other = room.north {
            other.south = room
            travel(from: other, direction: 0, distance: distance - 1)
        }

        if let other = room.east {
            other.west = room
            travel(from: other, direction: 1, distance: distance - 1)
        }

        if let other = room.south {
            other.north = room
            travel(from: other, direction: 2, distance: distance - 1)
        }

        if let other = room.west {
            other.east = room
            travel(from: other, direction: 3, distance: distance - 1)
        }

    }

    private func createRoom(x: Int, y: Int) -> DungeonLocation.Room {
        cprint(".", terminator: "")
        if let room = dungeon.roomAt(x, y) {
            return room
        }
        let room = DungeonLocation.Room(x: x, y: y)
        dungeon.rooms.append(room)
        return room
    }


}

extension RandomGenerator {

    mutating func randomInt(max: Int) -> Int {
        return Int(random32(max: UInt32(max)))
    }

}

