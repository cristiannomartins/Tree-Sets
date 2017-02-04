//
//  Pokemon+Extension.swift
//  Tree Sets
//
//  Created by Cristianno Vieira on 24/01/17.
//  Copyright © 2017 Cristianno Vieira. All rights reserved.
//

import CoreData

extension Pokemon {
  // Insert code here to add functionality to your managed object subclass
  static func getPokemonSpeciesFromSets (_ pkmnSets: [PokemonSet]) -> [Pokemon] {
    var pkms: [Pokemon] = []
    for set in pkmnSets {
      if pkms.filter({ p in p.species == set.species?.species }).count == 0 {
        pkms.append(set.species!)
      }
    }
    
    return pkms
  }
}
