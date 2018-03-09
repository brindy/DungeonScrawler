//
//  PCGenerator.swift
//  DungeonScrawlerPackageDescription
//
//  Created by Chris Brind on 04/03/2018.
//

import Foundation

class PCGenerator {
    
    func start() -> PC? {

        guard let name = askName() else { return nil }
        cprint()
        let pc = PC(name: name)
        
        guard let package = askStartingPackage(name: name) else { return nil }
        cprint()
        pc.stats = package.stats
        pc.points = PC.Points(experience: 0, hitPoints: pc.stats.constitution, magicPoints: pc.stats.power)
        pc.skills = package.skills
        
        // TODO starting skills
        
        // TODO starting weapons
        
        cprint(🎨.italic, "The wind suddenly erupts around you and your vision begins to blur. You feel as though you are tumbling for an eternity and then, as if nothing happened, you wake up...")
        cprint()
        return pc
    }
    
    private func askName() -> String? {
        cprint(🎨.bold, 🎨.green, "Welcome adventure!")
        cprint()
        cprint("Tell me, what is your name? ")
        cprint("> ", terminator: "")
        
        while(true) {
            guard let name = readLine()?.trimmingCharacters(in: .whitespaces), !name.isEmpty else {
                cprint()
                cprint("I'm sorry, you are mumbling, what did you say your name was?")
                cprint("> ", terminator: "")
                continue
            }
            
            cprint()
            cprint("Excellent! It is good to meet you, ", 🎨.bold, 🎨.red, name, 🎨.reset, "!")
            
            return name
        }
    }
    
    private func askStartingPackage(name: String) -> (stats: PC.Stats, skills: [PC.Skills: Int])? {
        cprint(🎨.bold, 🎨.red, name, 🎨.reset, ", please choosing a starting package:")
        cprint()
        cprint(🎨.bold, "1", 🎨.reset, ". Warrior")
        cprint(🎨.bold, "2", 🎨.reset, ". Rogue")
        cprint(🎨.bold, "3", 🎨.reset, ". Mage")
        cprint()
        
        var package: Int?
        
        selection:
            while(true) {
                cprint("> ", terminator: "")
                package = Int(readLine() ?? "")
                
                switch(package ?? 0) {
                case 1...3: break selection
                default:
                    cprint("Huh?  Please enter a number and press enter.")
                    cprint()
                }
                
        }
        
        switch(package!) {
        case 1:
            cprint("Oh yes, I could see from your chiselled phsyique you are naturally warrior material.")
            return (PC.Stats.warrior, PC.Skills.warrior)
            
        case 2:
            cprint("Aha! I had a sense there was something sneaky about you.")
            return (PC.Stats.rogue, PC.Skills.warrior)
            
        case 3:
            cprint("Of course! That explains the power I sense inside of you.")
            return (PC.Stats.mage, PC.Skills.warrior)
            
        default: return nil
        }
    }
    
}

extension PC.Stats {
    
    static var warrior = PC.Stats(strength: 21, constitution: 10, power: 3, dexterity: 10)
    static var rogue = PC.Stats(strength: 10, constitution: 10, power: 3, dexterity: 21)
    static var mage = PC.Stats(strength: 3, constitution: 10, power: 21, dexterity: 10)
    
}

extension PC.Skills {
    
    static var warrior = [PC.Skills: Int]()
    static var rogue = [PC.Skills: Int]()
    static var magic = [PC.Skills: Int]()

}
