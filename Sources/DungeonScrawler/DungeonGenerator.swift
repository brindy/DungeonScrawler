//
//  DungeonGenerator.swift
//  DungeonScrawlerPackageDescription
//
//  Created by Chris Brind on 19/02/2018.
//

import Foundation


class DungeonGenerator {
    
    var 🎲: RandomGenerator
    
    let minRooms: Int
    let level: Int
    
    var dungeon = Dungeon()
    
    init(seed: Int, level: Int) {
        self.level = level
        🎲 = MersenneTwister(seed: UInt64(seed))
        minRooms = (level * 10) + 5
    }
    
    func buildDungeon() -> Dungeon {
        cprint("Generating level ", level, " ", terminator: "")
        
        createStartRoom()
        
        while (dungeon.rooms.count < minRooms) {
            let room = randomRoom()
            let direction = 🎲.randomInt(max: 4)
            let maxDistance = Int(ceil(Double(level) / 2))
            // print(#function, maxDistance, dungeon.rooms.count)
            let distance = 🎲.randomInt(max: maxDistance) + 1
            travel(from: room, direction: direction, distance: distance)
        }
        
        createStairsDown()
        
        cprint(" enjoy!")
        return dungeon
    }
    
    private func createStartRoom() {
        let room = createRoom(x: 0, y: 0)
        room.up = true
    }
    
    private func createStairsDown() {
        var room: DungeonLocation.Room?
        while(room?.up ?? true) {
            room = randomRoom()
        }
        room?.down = true
    }
    
    private func randomRoom() -> DungeonLocation.Room {
        return dungeon.rooms[🎲.randomInt(max: dungeon.rooms.count)]
    }
    
    private func travel(from room: DungeonLocation.Room, direction: Int, distance: Int) {
        guard dungeon.rooms.count < minRooms else { return }
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
