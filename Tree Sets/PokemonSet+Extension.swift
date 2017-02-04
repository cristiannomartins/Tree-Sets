//
//  PokemonSet+Extension.swift
//  Tree Sets
//
//  Created by Cristianno Vieira on 22/01/17.
//  Copyright © 2017 Cristianno Vieira. All rights reserved.
//

import Foundation
import CoreData

extension PokemonSet {
  static func getPokemonSets(_ fromDex: Dex? = nil) -> [PokemonSet] {
    if let dex = fromDex {
      return dex.contains?.allObjects as! [PokemonSet]
    }
    
    //let fetch = NSFetchRequest(entityName: "PokemonSet")
    let fetch = NSFetchRequest<PokemonSet>(entityName: "PokemonSet")
    
    do {
      let pokemons = try PopulateDB.managedObjectContext.fetch(fetch)
      return pokemons
    } catch {
      print("Failed to retrieve record: \(error)")
    }
    
    return []
  }
  
  fileprivate func getEVs(_ category: PkmnStats) -> Int16 {
//    switch category {
//    case .hp: return evhp
//    case .atk: return evatk
//    case .def: return evdef
//    case .spa: return evspa
//    case .spd: return evspd
//    default: return evspe
//    }
    
    for ev in evs?.allObjects as! [Stats] {
      if ev.id == category.rawValue {
        return ev.value
      }
    }
    
    abort()
  }
  
  fileprivate func getMultiplier (_ nature: Nature, first: Int, last: Int, divisor: Int, remainder: Int) -> Double {
    let rawValue = nature.rawValue
    if rawValue >= first && rawValue <= last {
      return 1.1
    } else if rawValue % divisor == remainder {
      return 0.9
    } else {
      return 1.0
    }
  }
  
  
  fileprivate func natureBonus(_ stat: PkmnStats) -> Double {
    //NSLog(self.nature!)
    let nature = Nature.getNatureFromString(self.nature!)!
    if nature.rawValue >= 20 {
      return 1.0
    }
    
    switch stat {
    case PkmnStats.atk:
      return getMultiplier(nature, first: 0, last: 3, divisor: 4, remainder: 0)
    case PkmnStats.def:
      return getMultiplier(nature, first: 4, last: 7, divisor: 4, remainder: 1)
    case PkmnStats.spe:
      return getMultiplier(nature, first: 8, last: 11, divisor: 4, remainder: 2)
    case PkmnStats.spd:
      return getMultiplier(nature, first: 12, last: 15, divisor: 4, remainder: 3)
      
    default:                               // diagonal of NATURES
      return getMultiplier(nature, first: 16, last: 19, divisor: 5, remainder: 0)
    }
  }
  
  func getBaseStatValue(_ category: PkmnStats) -> Int16 {
//    switch category {
//    case .hp:
//      return species!.baseStats!.hp
//    case .atk:
//      return species!.baseStats!.atk
//    case .def:
//      return species!.baseStats!.def
//    case .spa:
//      return species!.baseStats!.spa
//    case .spd:
//      return species!.baseStats!.spd
//    default:
//      return species!.baseStats!.spe
//    }
    
    for base in species?.baseStats?.allObjects as! [Stats] {
      if base.id == category.rawValue {
        return base.value
      }
    }
    
    abort()
  }
  
  fileprivate func calcHPTotalStat() -> Int {
    let doubleBase = 2.0*Double(getBaseStatValue(PkmnStats.hp))
    let level = 50.0
    
    let percentageLvl = level/100.0
    
    let baseTotal = doubleBase +
      31.0 +
      floor(Double(getEVs(PkmnStats.hp))/4.0)
    
    return Int(floor(baseTotal*percentageLvl + level + 10.0))
  }
  
  func getStatValue(_ category: PkmnStats) -> Int {
    if category == PkmnStats.hp {
      return calcHPTotalStat()
    }
    
    let doubleBase = 2.0*Double(getBaseStatValue(category))
    
    let level = 50.0 // All maison pkm are set to level 50
    
    let percentageLvl = level/100.0
    
    let baseTotal = doubleBase +
      31.0 + // considering 30+ battle streak
      floor(Double(getEVs(category))/4.0)
    
    let baseWONature = floor(baseTotal*percentageLvl + 5.0)
    
    return Int(floor(baseWONature * natureBonus(category)))
  }
  
  func getChangedStats() -> (decreased: PkmnStats, increased: PkmnStats) {
    var stats = (decreased: PkmnStats.hp, increased: PkmnStats.hp)
    for stat:PkmnStats in [.atk, .def, .spa, .spd, .spe] {
      let bonus = natureBonus(stat)
      if bonus > 1.0 {
        stats.increased = stat
      } else {
        if bonus < 1.0 {
          stats.decreased = stat
        }
        
      }
    }
    return stats
  }
  
  enum PkmnStats: Int16 {
    case hp = 0, atk, def, spa, spd, spe
  }
  
  enum Nature: Int {
    case adamant = 0, lonely, brave, naughty,  // +Atk (-SpA, -Def, -Spe, -SpD) 0  - 3
    bold, impish, relaxed, lax,                // +Def (-Atk, -SpA, -Spe, -SpD) 4  - 7
    timid, hasty, jolly, naive,                // +Spe (-Atk, -Def, -SpA, -SpD) 8  - 11
    calm, gentle, sassy, careful,              // +SpD (-Atk, -Def, -Spe, -SpA) 12 - 15
    modest, mild, rash, quiet,                 // +SpA (-Atk, -Def, -Spe, -SpD) 16 - 19
    hardy, docile, serious, bashful, quirky    // None                          20 - 24
    
    static func count() -> Int {
      return quirky.rawValue + 1
    }
    static func getNatureFromString(_ name: String) -> Nature? {
      let lowercased = name.lowercased()
      for i in 0 ..< count() {
        let nature = Nature(rawValue: i)!
        if lowercased == "\(nature)" {
          return nature
        }
      }
      return nil
    }
  }
}
