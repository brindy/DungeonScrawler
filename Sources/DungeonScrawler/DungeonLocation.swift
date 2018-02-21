
import Foundation

class DungeonLocation: Location {


    var hint: String?

    let seed: Int

    var level: Int
    var dungeon: Dungeon!

    var currentRoom: Dungeon.Room! {
        didSet {
            currentRoom.visited = true
        }
    }

    init(seed: Int, level: Int) {
        self.seed = seed
        self.level = level

        generate()
    }
    
    func describe() {
        cprint("You are in the dungeon.")
        showUpOrDown()
        showExits()
    }

    func look() {
        cprint("The room is empty.")
    }

    func handle(command: String, args: [String], context: DungeonScrawler) -> Bool {

        switch(command) {
        case "go": return handleGo(args: args, context: context)
        case "north": return handleGo(args: ["north"], context: context)
        case "east": return handleGo(args: ["east"], context: context)
        case "south": return handleGo(args: ["south"], context: context)
        case "west": return handleGo(args: ["west"], context: context)
        case "n": return handleGo(args: ["north"], context: context)
        case "e": return handleGo(args: ["east"], context: context)
        case "s": return handleGo(args: ["south"], context: context)
        case "w": return handleGo(args: ["west"], context: context)
        case "up": return handleUp(context: context)
        case "down": return handleDown(context: context)
        case "map": return handleMap(context: context)
        default: return false
        }
    }
    
    private func generate() {
        let generator = DungeonGenerator(seed: seed, level: level)
        dungeon = generator.buildDungeon()
        currentRoom = dungeon.rooms[0]
    }
    
    private func showUpOrDown() {
        if currentRoom.up && level > 1 {
            cprint()
            cprint("Stairs ascend to an upper level.")
        } else if currentRoom.up {
            cprint()
            cprint("Daylight shines through a hole in the ceiling above.")
        } else if currentRoom.down {
            cprint()
            cprint("A set of stairs descends in to the darkness below.")
        }
    }
    
    private func handleDown(context: DungeonScrawler) -> Bool {
        guard currentRoom.down else {
            cprint("You need to find the stairs down before you can do that!")
            return true
        }

        if level > 1 {
            cprint("With a deep breath, you descend another set of stairs in to the darkness below.")
        } else {
            cprint("Bracing yourself, you descend the stairs in to the darkness below.")
        }
        
        level += 1
        generate()
        return true
    }
    
    private func handleUp(context: DungeonScrawler) -> Bool {
        guard currentRoom.up else {
            cprint("You can't go up here.")
            return true
        }
        
        if level > 1 {
            ascendLevel(context: context)
        } else {
            ascendToTown(context: context)
        }

        return true
    }

    private func ascendLevel(context: DungeonScrawler) {
        
        level -= 1
        cprint("You head back up the long staircase.")
        generate()
        
        for room in dungeon.rooms {
            if room.down {
                currentRoom = room
            }
        }
        
    }
    
    private func ascendToTown(context: DungeonScrawler) {
        cprint("You climb back out of the dungeon, leaving behind the ominous hole in the ground and head towards the town.")
        context.location = TownLocation()
    }
    
    private func handleMap(context: DungeonScrawler) -> Bool {
        dungeon.printMap(currentRoom: currentRoom, visitedOnly: true)
        return true
    }

    private func showExits() {
        cprint()
        cprint("Exits are: ", currentRoom.exits())
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

    private func go(_ room: Dungeon.Room?, direction: String, context: DungeonScrawler) -> Bool {
        guard let room = room else {
            cprint("You can't go that way.")
            return true
        }
        cprint("Heading ", direction, ".")
        currentRoom = room
        context.location = self
        return true
    }

    
}

struct Dungeon {
    
    class Room {
        
        // user affected
        
        var visited = false
        
        // room properties
        
        var north: Room?
        var east: Room?
        var south: Room?
        var west: Room?
        
        var up = false
        var down = false
        
        let x: Int
        let y: Int
        
        init(x: Int, y: Int) {
            self.x = x
            self.y = y
        }
        
        func exits() -> [String] {
            var exits = [String]()
            if north != nil {
                exits.append("north")
            }
            
            if east != nil {
                exits.append("east")
            }
            
            if south != nil {
                exits.append("south")
            }
            
            if west != nil {
                exits.append("west")
            }
            
            if up {
                exits.append("up")
            }
            
            if down {
                exits.append("down")
            }
            return exits
        }
        
        static func ==(left: Room, right: Room) -> Bool {
            return left.x == right.x && left.y == right.y
        }
        
    }

    
    var rooms = [Room]()
    
    func printMap(currentRoom: Room? = nil, visitedOnly: Bool = false) {
        let extents = calculateExtents()
        
        let width = ((extents.xMax - extents.xMin) * 2) - 1
        let height = ((extents.yMax - extents.yMin) * 2) - 1
        
        var grid = Array(repeating: Array(repeating: ".", count: width), count: height)
        
        for y in extents.yMin ..< extents.yMax {
            for x in extents.xMin ..< extents.xMax {
                let gridX = ((x - extents.xMin) * 2) - 1
                let gridY = ((y - extents.yMin) * 2) - 1
                
                guard let room = roomAt(x, y) else { continue }
                if visitedOnly && !room.visited { continue }

                grid[gridY][gridX] = "O"
                grid[gridY][gridX] = room.up ? "▲" : grid[gridY][gridX]
                grid[gridY][gridX] = room.down ? "▼" : grid[gridY][gridX]
                
                if nil != currentRoom {
                    grid[gridY][gridX] = room == currentRoom! ? "U" : grid[gridY][gridX]
                }
                
                if room.north != nil {
                    grid[gridY - 1][gridX] =  "|"
                }
                
                if room.east != nil {
                    grid[gridY][gridX + 1] =  "-"
                }

                if room.south != nil {
                    grid[gridY + 1][gridX] =  "|"
                }

                if room.west != nil {
                    grid[gridY][gridX - 1] =  "-"
                }
            }
        }
        
        for cols in grid {
            for location in cols {
                print(location.replacingOccurrences(of: ".", with: "\(🎨.grey)#\(🎨.reset)"), terminator: "")
            }
            print()
        }
    }
    
    func roomAt(_ x: Int, _ y: Int) -> Room? {
        for room in rooms {
            if room.x == x && room.y == y {
                return room
            }
        }
        return nil
    }

    private func calculateExtents() -> (xMin: Int, yMin: Int, xMax: Int, yMax: Int) {
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
        
        return (xMin - 1, yMin - 1, xMax + 1, yMax + 1)
    }

}


