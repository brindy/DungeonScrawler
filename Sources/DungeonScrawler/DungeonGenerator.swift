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
        🎲 = MersenneTwister(seed: UInt64(seed + level))
        minRooms = Int(log10(Double(level + 1)) * 50)
    }
    
    func buildDungeon() -> Dungeon {
        createStartRoom()
        
        while (dungeon.rooms.count < minRooms) {
            let room = dungeon.rooms.random(withGenerator: &🎲)
            
            guard let direction = randomCorridorDirection(forRoom: room) else {
                continue
            }
            
            let distance = 🎲.randomInt(max: 2) + 1
            travel(from: room, direction: direction, distance: distance)
        }
        
        createStairsDown()
        return dungeon
    }
    
    private func randomCorridorDirection(forRoom room: Dungeon.Room) -> Int? {
        var directions = [Int]()
        if room.exits().count < 3 {
            
            if room.north == nil { directions.append(0) }
            if room.east == nil { directions.append(1) }
            if room.south == nil { directions.append(2) }
            if room.west == nil { directions.append(3) }
            
        } else {
            if room.north == nil && room.south == nil {
                directions.append(0)
                directions.append(2)
            }
            
            if room.east == nil && room.west == nil {
                directions.append(1)
                directions.append(3)
            }
        }
        
        guard directions.count > 0 else { return nil }
        
        return directions.random(withGenerator: &🎲)
    }
    
    private func createStartRoom() {
        let room = createRoom(x: 0, y: 0)
        room.up = true
    }
    
    private func createStairsDown() {
        var rooms = [Dungeon.Room]()
        var minDistance = Int(ceil(Double(level) / 2))
        
        while(rooms.isEmpty) {
            for room in dungeon.rooms {
                let x = Double(room.x)
                let y = Double(room.y)
                let d = Int(sqrt(x * x + y * y))
                if d > minDistance {
                    rooms.append(room)
                }
            }
            minDistance -= 1
        }

        rooms.random(withGenerator: &🎲).down = true
    }
    
    private func travel(from room: Dungeon.Room, direction: Int, distance: Int) {
        guard dungeon.rooms.count < minRooms else { return }
        guard distance > 0 else { return }
        guard 0 == 🎲.randomInt(max: room.exits().count) else { return }
        
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
    
    private func createRoom(x: Int, y: Int) -> Dungeon.Room {
        if let room = dungeon.roomAt(x, y) {
            return room
        }
        let room = Dungeon.Room(x: x, y: y)
        dungeon.rooms.append(room)
        return room
    }
    
}

extension RandomGenerator {
    
    mutating func randomInt(max: Int) -> Int {
        return Int(random32(max: UInt32(max)))
    }
    
}
