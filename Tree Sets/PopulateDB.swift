//
//  PopulateDB.swift
//  Tree Sets
//
//  Created by Cristianno Vieira on 29/12/16.
//  Copyright © 2016 Cristianno Vieira. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class PopulateDB {
  
  // MARK: -- Local variables declarations
  static let encoding: String.Encoding = String.Encoding.utf8
  
  // managedObjectContext: interface to access the data model
  //static let CDWrapper = CoreDataWrapper()
  static let CDWrapper = (UIApplication.shared.delegate as! AppDelegate).CDWrapper
//  static let managedObjectContext: NSManagedObjectContext =
//    (UIApplication.shared.delegate
//      //as! AppDelegate).persistentContainer.viewContext
//    as! AppDelegate).managedObjectContext
  
  //static fileprivate var basePokemon: [String:Pokemon] = [:]
  static fileprivate var basePkms = [Pokemon]() // references of pkms that were added to the data source
  static fileprivate var types = [Type]() // references of types that were added to the data source
  static fileprivate var stats = [Stats]() // references of stats that were added to the data source
  static fileprivate var abilities = [Ability]() // references of abilities that were added to the data source
  static fileprivate var items = [Item]() // references of items that were added to the data source
  static fileprivate var moves = [Move]() // references of moves that were added to the data source
  static fileprivate var tclasses = [TrainerClass]() // references of Trainer Classes that were added to the data source
  static fileprivate var dexes = [(id: Int, dex: Dex)]() // references of Dexes that were added to the data source
  static fileprivate var pkmSets = [PokemonSet]() // references of PkmSets that were added to the data source
  
  static var processingQueue = DispatchQueue(label: "com.Tree_Sets.heavyProcessing", attributes: [])
  
  // MARK: -- Auxiliary enums
  //Lookup | ID | Ndex | Species | Forme | Type1 | Type2 | Ability1 | Ability2 | AbilityH | HP | Attack | Defense | SpAttack | SpDefense | Speed | Total | Weight | Height | Dex1 | Dex2 | Class | %Male | %Female | Pre-Evolution | Egg Group 1 | Egg Group 2 | Type Concat | Ability Concat
  enum PkmTSV: Int {
    case species = 0
    case id = 1
    case nid
    //case species
    case primaryType = 5
    case secondaryType
    case ability1
    case ability2
    case abilityH
    case baseHP
    case baseAtk
    case baseDef
    case baseSpa
    case baseSpd
    case baseSpe
  }
  
  enum DexCSV: Int {
    // first line of a dex
    //case id = 0
    //case trainers
    
    // other dex lines (max of 5 repetitions)
    case species = 0
    case set1
    case set2
    case set3
    case set4
  }
  
  // just a shortcut to organize the stats ids
  enum StatID: Int16 {
    case HP = 0
    case Atk
    case Def
    case Spa
    case Spd
    case Spe
  }
  
  enum ItemCSV: Int {
    // Name;Mega Stone;ID;Effect
    case name = 0
    case ID = 2
  }
  
  enum PkmImagesCSV: Int {
    // Lookup;ID;subid;Ndex
    case species = 0
    case ID
  }
  
  // Pokemon | Nature | Item | [Moves 1 - 4] | [EV Placement HP-Spe]
  enum PkmSetCSV: Int {
    case species = 0
    case isMega
    case nature
    case heldItem
    case move1
    case move2
    case move3
    case move4
    case hpEV
    case atkEV
    case defEV
    case spaEV
    case spdEV
    case speEV
  }
  
  // Name | dex | Category | possible sex | sex | Start | End
  enum TrainerCSV: Int {
    case name = 0
    case dexID
    case category
    case sex = 4
    case start
    case end
  }
  
  // Trainer Category | Possible Sex | Characteristic
  enum TrainerClassCSV: Int {
    case name = 0
    case possibleSex
    case characteristic
  }
  
  // MARK: -- Auxiliary getOrCreate functions
  
  static fileprivate func createPokemonSet() -> PokemonSet {
    return NSEntityDescription.insertNewObject(forEntityName: "PokemonSet", into: CDWrapper.managedObjectContext) as! PokemonSet
  }
  
  static fileprivate func createImage() -> Image {
    return NSEntityDescription.insertNewObject(forEntityName: "Image", into: CDWrapper.managedObjectContext) as! Image
  }
  
  static fileprivate func getOrCreateMove(_ name: String) -> Move {
    let result = moves.filter() { $0.name == name }
    
    if result.count > 1 {
      // there is more than one pokemon with the same species: something went wrong!
      abort()
    }
    
    if result.count == 1 {
      return result.first!
    }
    
    // TODO: Implement the rest of the moves fields
    let newMove = NSEntityDescription.insertNewObject(forEntityName: "Move", into: CDWrapper.managedObjectContext) as! Move
    newMove.name = name
    moves.append(newMove)
    
    return newMove
  }
  
  static var PkmnID = [String:Int]()
  static fileprivate func getID(forPkmn name: String) -> Int {
    if PkmnID.count > 0 {
      return PkmnID[name]!
    }
    
    if let contentsOfURL = Bundle.main.url(forResource: "pkmn_images-Table 1-1", withExtension: "csv") {
      do {
        let content = try String(contentsOf: contentsOfURL, encoding: encoding)
        
        var lines:[String] = content.components(separatedBy: "\r\n") as [String]
        
        lines.remove(at: 0) // gets rid of the header line
        
        for line in lines {
          let values = line.components(separatedBy: ";")
          PkmnID[values[PkmImagesCSV.species.rawValue]] = Int(values[PkmImagesCSV.ID.rawValue])
        }
      } catch {
        print(error)
      }
    }
    
    return getID(forPkmn: name)
  }
  
  static var ItemID = [String:Int]()
  static fileprivate func getID(forItem name: String) -> Int {
    if ItemID.count > 0 {
      return ItemID[name]!
    }
    
    if let contentsOfURL = Bundle.main.url(forResource: "items_images-Table 1-1", withExtension: "csv") {
      do {
        let content = try String(contentsOf: contentsOfURL, encoding: encoding)
        
        var lines:[String] = content.components(separatedBy: "\r\n") as [String]
        
        lines.remove(at: 0) // gets rid of the header line
        
        for line in lines {
          let values = line.components(separatedBy: ";")
          ItemID[values[ItemCSV.name.rawValue]] = Int(values[ItemCSV.ID.rawValue])
        }
      } catch {
        print(error)
      }
    }
    
    return getID(forItem: name)
  }
  
  static fileprivate func getOrCreateItem(_ name: String) -> Item {
    let result = items.filter() { $0.name == name }
    
    if result.count > 1 {
      // there is more than one pokemon with the same species: something went wrong!
      abort()
    }
    
    if result.count == 1 {
      return result.first!
    }
    
    // TODO: Implement the image from the items
    let newItem = NSEntityDescription.insertNewObject(forEntityName: "Item", into: CDWrapper.managedObjectContext) as! Item
    newItem.name = name
    
    let itemID = getID(forItem: name)
    let itemImage = createImage()
    itemImage.x = NSNumber.init(value: itemID / Image.ImageColumns)
    itemImage.y = NSNumber.init(value: itemID % Image.ImageColumns)
    newItem.image = itemImage
    
    items.append(newItem)
    
    return newItem
  }
  
  static fileprivate func getOrCreateAbility(_ name: String) -> Ability {
    let result = abilities.filter() { $0.name == name }
    
    if result.count > 1 {
      // there is more than one pokemon with the same species: something went wrong!
      abort()
    }
    
    if result.count == 1 {
      return result.first!
    }
    
    let newAbility = NSEntityDescription.insertNewObject(forEntityName: "Ability", into: CDWrapper.managedObjectContext) as! Ability
    newAbility.name = name
    abilities.append(newAbility)
    
    return newAbility
  }
  
  static fileprivate func getOrCreateType(_ name: String) -> Type {
    let result = types.filter() { $0.name == name }
    
    if result.count > 1 {
      // there is more than one pokemon with the same species: something went wrong!
      abort()
    }
    
    if result.count == 1 {
      return result.first!
    }
    
    let newType = NSEntityDescription.insertNewObject(forEntityName: "Type", into: CDWrapper.managedObjectContext) as! Type
    newType.name = name
    types.append(newType)
    
    return newType
  }
  
  static fileprivate func getOrCreateStat(id: Int16, value: Int16) -> Stats {
    let result = stats.filter() { $0.id == id && $0.value == value }
    
    if result.count > 1 {
      // there is more than one pokemon with the same species: something went wrong!
      abort()
    }
    
    if result.count == 1 {
      return result.first!
    }
    
    let newStat = NSEntityDescription.insertNewObject(forEntityName: "Stat", into: CDWrapper.managedObjectContext) as! Stats
    newStat.id = id
    newStat.value = value
    stats.append(newStat)
    
    return newStat
  }
  
  static fileprivate func getOrCreatePokemon(ofSpecies species: String) -> Pokemon {
    let result = basePkms.filter() { $0.species == species }
    
    if result.count > 1 {
      print("there is more than one pokemon with the same species: something went wrong!\n")
      abort()
    }
    
    if result.count == 1 {
      // found the mon
      return result.first!
    }
    
    // need to create a new mon
    let tuples = pkmBaseData.filter() { $0.key == species }
    
    if tuples.count != 1 {
      print("there is more/less than one pokemon with the same species: something went wrong!\n")
      abort()
    }
    
    let monData = tuples.first!
    
    let newMon = NSEntityDescription.insertNewObject(forEntityName: "Pokemon", into: CDWrapper.managedObjectContext) as! Pokemon
    
    newMon.species = monData.key
    
    // TODO: What should I do on these cases?
    if monData.value.count > 1 {
      print("More than one found for species \(monData.key):\n")
      for value in monData.value {
        print("\t\(value)\n")
      }
    }
    
    let values = monData.value.first!.components(separatedBy: "\t")
    newMon.id = Int32(values[PkmTSV.id.rawValue])!
    newMon.firstAbility = getOrCreateAbility(values[PkmTSV.ability1.rawValue])
    newMon.secondAbility = getOrCreateAbility(values[PkmTSV.ability2.rawValue])
    newMon.hiddenAbility = getOrCreateAbility(values[PkmTSV.abilityH.rawValue])
    
    newMon.type1 = getOrCreateType(values[PkmTSV.primaryType.rawValue])
    newMon.type2 = getOrCreateType(values[PkmTSV.secondaryType.rawValue])
    
    var baseStats = [Stats]()
    baseStats.append(getOrCreateStat(id: StatID.HP.rawValue, value: Int16(values[PkmTSV.baseHP.rawValue])!))
    baseStats.append(getOrCreateStat(id: StatID.Atk.rawValue, value: Int16(values[PkmTSV.baseAtk.rawValue])!))
    baseStats.append(getOrCreateStat(id: StatID.Def.rawValue, value: Int16(values[PkmTSV.baseDef.rawValue])!))
    baseStats.append(getOrCreateStat(id: StatID.Spa.rawValue, value: Int16(values[PkmTSV.baseSpa.rawValue])!))
    baseStats.append(getOrCreateStat(id: StatID.Spd.rawValue, value: Int16(values[PkmTSV.baseSpd.rawValue])!))
    baseStats.append(getOrCreateStat(id: StatID.Spe.rawValue, value: Int16(values[PkmTSV.baseSpe.rawValue])!))
    
    //print("1\n")
    newMon.baseStats = NSSet(array: baseStats)
    //print("2\n")
    
    basePkms.append(newMon)
    return newMon
  }
  
  // MARK: -- Other functions
  /**
   * Returns a dictionary that contains an array representing the different forms
   * a given pokemon can have. A string containing the pokemon species is the key.
   */
  static fileprivate func getPokemonBasicData() -> [String:[String]] {
    var pokemons = [String:[String]]()
    
    
    if let contentsOfURL = Bundle.main.url(forResource: "Battle Tree Lookup - Pokedex", withExtension: "tsv") {
      do {
        let content = try String(contentsOf: contentsOfURL, encoding: encoding)
        
        var lines:[String] = content.components(separatedBy: "\r\n") as [String]
        
        lines.remove(at: 0) // gets rid of the header line
        
        for line in lines {
          let values = line.components(separatedBy: "\t")
          if pokemons[values[PkmTSV.species.rawValue]] == nil {
            pokemons[values[PkmTSV.species.rawValue]] = []
          }
          pokemons[values[PkmTSV.species.rawValue]]!.append(line)
        }
      } catch {
        print(error)
      }
    }
    return pokemons
  }
  
  static fileprivate func getRecalcStats(stats precalcStats: [Stats], forItem item: Item) -> NSSet {
    // TODO: Implement this function to recalculate the stats based on the item
    var newStats = [Stats]()
    
    for stat in precalcStats {
      switch PokemonSet.PkmnStats(rawValue: stat.id)! {
      case .hp:
        newStats.append(stat)
      
      case .atk:
        if item.name == "Choice Band" {
          newStats.append(getOrCreateStat(id: PokemonSet.PkmnStats.atk.rawValue, value: Int16(Double(stat.value)*1.5)))
        } else {
          newStats.append(stat)
        }
        
      case .def:
        newStats.append(stat)
      
      case .spa:
        if item.name == "Choice Specs" {
          newStats.append(getOrCreateStat(id: PokemonSet.PkmnStats.spa.rawValue, value: Int16(Double(stat.value)*1.5)))
        } else {
          newStats.append(stat)
        }
      
      case .spd:
        newStats.append(stat)
        
      case .spe:
        if item.name == "Choice Scarf" {
          newStats.append(getOrCreateStat(id: PokemonSet.PkmnStats.spe.rawValue, value: Int16(Double(stat.value)*1.5)))
        } else {
          newStats.append(stat)
        }
      }
    }
    return NSSet(array: newStats)
  }
  
  static fileprivate func createImage(forPokemon id: Int) -> Image {
    let img = NSEntityDescription.insertNewObject(forEntityName: "Image", into: CDWrapper.managedObjectContext) as! Image
    img.x = NSNumber(value: id / Image.PkmColumns)
    img.y = NSNumber(value: id % Image.PkmColumns)
    return img
  }
  
  static fileprivate let pkmBaseData = getPokemonBasicData() // raw data of all pkm species
  //static fileprivate var altForms = [[String]]() // species of alternate forms
  static fileprivate func parsePkms() {
    
    if let contentsOfURL = Bundle.main.url(forResource: "Pokemon-Table 1", withExtension: "csv") {
      do {
        let content = try String(contentsOf: contentsOfURL, encoding: encoding)
        
        var lines:[String] = content.components(separatedBy: "\r\n") as [String]
        
        lines.remove(at: 0) // gets rid of the header line
        
        var index = 0
        while index < lines.count {
          var species = ""
          var bckspecies = ""
          var basePkm: Pokemon!
          for i in 0...3 {
            var values = lines[index + i].components(separatedBy: ";")
            
            if i == 0 {
              species = values[0]
            }
            
            bckspecies = species
            // creates a new line with the same species but a different form
            if values[PkmSetCSV.isMega.rawValue] == "Mega" { // Megas
              species = "\(species) (Mega \(species))"
            }
            
            basePkm = getOrCreatePokemon(ofSpecies: species)
            
            // empty line of alternative sets
            if values[PkmSetCSV.heldItem.rawValue] == "" {
              //species = bckspecies
              continue
            }
            
            let newPkmSet = createPokemonSet()
            newPkmSet.species = basePkm
            newPkmSet.setID = (i + 1) as NSNumber?
            newPkmSet.nature = values[PkmSetCSV.nature.rawValue]
            
            newPkmSet.holding = getOrCreateItem(values[PkmSetCSV.heldItem.rawValue])
            
            var evs = [Stats]()
            
            var divisor = 0
            for c in PkmSetCSV.hpEV.rawValue...PkmSetCSV.speEV.rawValue {
              if values[c] != "" {
                divisor += 1
              }
            }
            
            let investment = divisor == 2 ? 252 : 164
            
            evs.append(getOrCreateStat(id: StatID.HP.rawValue,
                                       value: Int16(values[PkmSetCSV.hpEV.rawValue] == "" ? 0 : investment) ))
            evs.append(getOrCreateStat(id: StatID.Atk.rawValue,
                                       value: Int16(values[PkmSetCSV.atkEV.rawValue] == "" ? 0 : investment) ))
            evs.append(getOrCreateStat(id: StatID.Def.rawValue,
                                       value: Int16(values[PkmSetCSV.defEV.rawValue] == "" ? 0 : investment) ))
            evs.append(getOrCreateStat(id: StatID.Spa.rawValue,
                                       value: Int16(values[PkmSetCSV.spaEV.rawValue] == "" ? 0 : investment) ))
            evs.append(getOrCreateStat(id: StatID.Spd.rawValue,
                                       value: Int16(values[PkmSetCSV.spdEV.rawValue] == "" ? 0 : investment) ))
            evs.append(getOrCreateStat(id: StatID.Spe.rawValue,
                                       value: Int16(values[PkmSetCSV.speEV.rawValue] == "" ? 0 : investment) ))
            
            newPkmSet.evs = NSSet(array: evs)
            
            var precalcStats = [Stats]()
            precalcStats.append(getOrCreateStat(id: StatID.HP.rawValue, value: Int16(newPkmSet.getStatValue(PokemonSet.PkmnStats.hp))))
            precalcStats.append(getOrCreateStat(id: StatID.Atk.rawValue, value: Int16(newPkmSet.getStatValue(PokemonSet.PkmnStats.atk))))
            precalcStats.append(getOrCreateStat(id: StatID.Def.rawValue, value: Int16(newPkmSet.getStatValue(PokemonSet.PkmnStats.def))))
            precalcStats.append(getOrCreateStat(id: StatID.Spa.rawValue, value: Int16(newPkmSet.getStatValue(PokemonSet.PkmnStats.spa))))
            precalcStats.append(getOrCreateStat(id: StatID.Spd.rawValue, value: Int16(newPkmSet.getStatValue(PokemonSet.PkmnStats.spd))))
            precalcStats.append(getOrCreateStat(id: StatID.Spe.rawValue, value: Int16(newPkmSet.getStatValue(PokemonSet.PkmnStats.spe))))
            
            newPkmSet.preCalcStatsNoItem = NSSet(array: precalcStats)
            
            newPkmSet.preCalcStats = getRecalcStats(stats: precalcStats, forItem: newPkmSet.holding!)
            
            var moveSet = [Move]()
            
            moveSet.append(getOrCreateMove(values[PkmSetCSV.move1.rawValue]))
            moveSet.append(getOrCreateMove(values[PkmSetCSV.move2.rawValue]))
            moveSet.append(getOrCreateMove(values[PkmSetCSV.move3.rawValue]))
            moveSet.append(getOrCreateMove(values[PkmSetCSV.move4.rawValue]))
            
            newPkmSet.moveSet = NSSet(array: moveSet)
            newPkmSet.image = createImage(forPokemon: getID(forPkmn:newPkmSet.species!.species!))
            
            //try? newPkmSet.managedObjectContext?.save()
            
            pkmSets.append(newPkmSet)
            //print("\(species), set \(i): OK")
            species = bckspecies
          }
          index += 4
        }
        //CDWrapper.saveContext()
      } catch {
        print(error)
      }
    }
  }
  
  static fileprivate func getTrainerClassPossibleSex(_ name: String) -> String {
    if let contentsOfURL = Bundle.main.url(forResource: "Trainer Category-Table 1", withExtension: "csv") {
      do {
        let content = try String(contentsOf: contentsOfURL, encoding: encoding)
        
        var lines:[String] = content.components(separatedBy: "\r\n") as [String]
        
        lines.remove(at: 0) // gets rid of the header line
        
        
        for line in lines {
          let values = line.components(separatedBy: ";")
          
          if values[TrainerClassCSV.name.rawValue] == name {
            return values[TrainerClassCSV.possibleSex.rawValue]
          }
        }
      } catch {
        print(error)
      }
    }
    
    //print("Could not find trainer class named \(name) on Trainer Category Table.")
    //abort()
    return "?" // undiscovered trainer class
  }
  
  static fileprivate func getPkmSet(pkmNamed species: String, id setID: Int) -> PokemonSet {
    if let result = findPkmSet(pkmNamed: species, id: setID) { // regular form
      return result
    } else if let result = findPkmSet(pkmNamed: "\(species) (Mega \(species))", id: setID) { // mega
      return result
    } else {
      abort()
    }
  }
  
  static fileprivate func findPkmSet(pkmNamed species: String, id setID: Int) -> PokemonSet? {
    let result = pkmSets.filter() { $0.species?.species == species }
    
    if result.count == 0 {
      // there is no pokemon from that species on the db
      abort()
    }
    
    for res in result {
      if Int(res.setID!) == setID {
        return res
      }
    }
//    
//    // Could not find a pkmSet with the same id as requested
//    abort()
    return nil
  }
  
  static fileprivate func parseDexes() {
    if let contentsOfURL = Bundle.main.url(forResource: "Dex-Table 1", withExtension: "csv") {
      do {
        let content = try String(contentsOf: contentsOfURL, encoding: encoding)
        
        let lines:[String] = content.components(separatedBy: "\r\n") as [String]
        
        var curr = 0
        while (curr < lines.count) {
          // first line of a dex (only the id matters)
          let id = Int(lines[curr].components(separatedBy: ";")[0])!
          curr += 1
          
          var values = lines[curr].components(separatedBy: ";")
          
          let newDex = NSEntityDescription.insertNewObject(forEntityName: "Dex", into: CDWrapper.managedObjectContext) as! Dex
          
          var pkmSets = [PokemonSet]()
          
          while values[0] != "" {
            for setID in 1...4 {
              if values[setID] == "\(setID)" {
                pkmSets.append(getPkmSet(pkmNamed: values[DexCSV.species.rawValue], id: setID))
              }
            }
            
            values.removeFirst(5)
            
            if values.count == 0 { // this line has ended
              curr += 1
              
              // there are no more lines available
              if curr == lines.count {
                values.append("")
                continue
              }
              
              values = lines[curr].components(separatedBy: ";")
            } else if values[0] == "" { // or this line was an incomplete one
                curr += 1
            }
          }
          
          newDex.contains = NSSet(array:pkmSets)
          
          dexes.append((id: id, dex: newDex))
          curr += 1
        }
        
      } catch {
        print(error)
      }
    }
  }
  
  static fileprivate func getDex(_ id: Int) -> Dex {
    if dexes.count == 0 {
      parseDexes()
    }
    
    let result = dexes.filter() { $0.id == id }
    
    if result.count > 1 {
      // there is more than one dex with the same id: something went wrong!
      abort()
    }
    
    if result.count == 1 {
      return result.first!.dex
    }
    
    print("Could not find dex with id \(id).")
    abort()
  }
  
  static fileprivate func getOrCreateTrainerClass(_ name: String) -> TrainerClass {
    let result = tclasses.filter() { $0.name == name }
    
    if result.count > 1 {
      // there is more than one pokemon with the same species: something went wrong!
      abort()
    }
    
    if result.count == 1 {
      return result.first!
    }
    
    // TODO: Implement the image of Trainer Class
    let newTClass = NSEntityDescription.insertNewObject(forEntityName: "TrainerClass", into: CDWrapper.managedObjectContext) as! TrainerClass
    newTClass.name = name
    newTClass.possibleSex = getTrainerClassPossibleSex(name)
    tclasses.append(newTClass)
    
    return newTClass
  }
  
  static fileprivate func parseTrainers() /*-> [Trainer]*/ {
    //var trainers = [Trainer]()
    
    if let contentsOfURL = Bundle.main.url(forResource: "Trainer-Table 1", withExtension: "csv") {
      do {
        let content = try String(contentsOf: contentsOfURL, encoding: encoding)
        
        var lines:[String] = content.components(separatedBy: "\r\n") as [String]
        
        lines.remove(at: 0) // gets rid of the header line
        
        for line in lines {
          let values = line.components(separatedBy: ";")
          
          // TODO: Implement the quotes spoken by the trainers
          let newTrainer = NSEntityDescription.insertNewObject(forEntityName: "Trainer", into: CDWrapper.managedObjectContext) as! Trainer
          
          newTrainer.name = values[TrainerCSV.name.rawValue]
          newTrainer.sex = values[TrainerCSV.sex.rawValue]
          newTrainer.start = values[TrainerCSV.start.rawValue] == "" ? nil : values[TrainerCSV.start.rawValue]
          newTrainer.end = values[TrainerCSV.end.rawValue] == "" ? nil : values[TrainerCSV.end.rawValue]
          
          newTrainer.trainerClass = getOrCreateTrainerClass(values[TrainerCSV.category.rawValue])
          
          newTrainer.availableMons = getDex(Int(values[TrainerCSV.dexID.rawValue])!)
          
          //try? newTrainer.managedObjectContext?.save()
            
          //trainers.append(newTrainer)
        }
        //CDWrapper.saveContext()
        
      } catch {
        print(error)
      }
    }
    
    //return trainers
  }
  
  /**
   * Remove all content inside the database (for debugging purposes)
   */
  static fileprivate func removeData () {
    // Remove the existing mons-sets and trainers
    let fetchMonSets = NSFetchRequest<PokemonSet>(entityName: "PokemonSet")
    let fetchTrainers = NSFetchRequest<Trainer>(entityName: "Trainer")
    do {
      
      let pkms = try CDWrapper.managedObjectContext.fetch(fetchMonSets)
      for pkm in pkms {
        CDWrapper.managedObjectContext.delete(pkm)
      }
      
      let trainers = try CDWrapper.managedObjectContext.fetch(fetchTrainers)
      for trainer in trainers {
        CDWrapper.managedObjectContext.delete(trainer)
      }
    } catch {
      print("Failed to retrieve record: \(error)")
    }
    
    // Remove the existing items, moves and pkm
    let fetchItems = NSFetchRequest<Item>(entityName: "Item")
    let fetchMoves = NSFetchRequest<Move>(entityName: "Move")
    let fetchMons = NSFetchRequest<Pokemon>(entityName: "Pokemon")
    
    do {
      let items = try CDWrapper.managedObjectContext.fetch(fetchItems)
      for item in items {
        CDWrapper.managedObjectContext.delete(item)
      }
      
      let moves = try CDWrapper.managedObjectContext.fetch(fetchMoves)
      for move in moves {
        CDWrapper.managedObjectContext.delete(move)
      }
      
      let pkms = try CDWrapper.managedObjectContext.fetch(fetchMons)
      for pkm in pkms {
        CDWrapper.managedObjectContext.delete(pkm)
      }
    } catch {
      print("Failed to retrieve record: \(error)")
    }
    
    // Remove the existing dexes, abilities, types and trainer categories
    let fetchTrainerCat = NSFetchRequest<TrainerClass>(entityName: "TrainerClass")
    let fetchDex = NSFetchRequest<Dex>(entityName: "Dex")
    let fetchAbility = NSFetchRequest<Ability>(entityName: "Ability")
    let fetchType = NSFetchRequest<Type>(entityName: "Type")
    
    do {
      let cats = try CDWrapper.managedObjectContext.fetch(fetchTrainerCat)
      for cat in cats {
        CDWrapper.managedObjectContext.delete(cat)
      }
      
      let dexes = try CDWrapper.managedObjectContext.fetch(fetchDex)
      for dex in dexes {
        CDWrapper.managedObjectContext.delete(dex)
      }
      
      let abilities = try CDWrapper.managedObjectContext.fetch(fetchAbility)
      for ability in abilities {
        CDWrapper.managedObjectContext.delete(ability)
      }
      
      let types = try CDWrapper.managedObjectContext.fetch(fetchType)
      for type in types {
        CDWrapper.managedObjectContext.delete(type)
      }
    } catch {
      print("Failed to retrieve record: \(error)")
    }
  }
  
  static func preload() {
    removeData()
    parsePkms()
    //parseAlternateForms()
    parseTrainers()
    
    //CDWrapper.saveContext()
  }
}
