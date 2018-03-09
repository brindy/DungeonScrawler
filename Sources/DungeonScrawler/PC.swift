//
//  PC.swift
//  DungeonScrawlerPackageDescription
//
//  Created by Chris Brind on 04/03/2018.
//

import Foundation

class PC {

    struct Points {
        
        var experience: Int = 0
        var hitPoints: Int = 0
        var magicPoints: Int = 0
        
    }
    
    struct Stats {
        
        var strength: Int = 0       // min 3, start 10, max 21, how hard you can hit
        var constitution: Int = 0   // min 3, start 10, max 21, how much damage you can take
        var power: Int = 0          // min 3, start 10, max 21, how magical you are
        var dexterity: Int = 0      // min 3, start 10, max 21, how graceful you are (influences dodge and ranged attacks)
        
    }
    
    // 0 - 100
    struct Skills {
        
        var dodge: Int = 0          // +(dex * 2), critical = free attack
        var firstAid: Int = 0       // critical = full heal
        
        var shields: Int = 0
        
        var simpleMelee: Int = 0
        var martialMelee: Int = 0
        
        var simpleRanged: Int = 0
        var martialRanged: Int = 0
        var unarmedCombat: Int = 0
        
        var casting: Int = 0
        
    }
    
    struct Body {
        
        var head: HeadItem? = nil
        let torso: TorsoItem? = nil
        let legs: LegsItem? = nil
        let mainHand: Item? = nil
        let offHand: Item? = nil
        let leftRing: RingItem? = nil
        let rightRing: RingItem? = nil
        
    }
    
    let name: String
    var points = Points()
    var stats = Stats()
    var body = Body()

    var inventory = [Item]()
    
    init(name: String) {
        self.name = name
    }
    
}

protocol Item {
    
}

protocol EquipableItem: Item {
    
    func equipped(onPC pc: PC)
    
    func unequipped(fromPC pc: PC)
    
}

protocol WearableItem: EquipableItem {
    
}

protocol HeadItem: WearableItem {
    
}

protocol TorsoItem: WearableItem {
    
}

protocol LegsItem: WearableItem {
    
}

protocol RingItem: WearableItem {
    
}

