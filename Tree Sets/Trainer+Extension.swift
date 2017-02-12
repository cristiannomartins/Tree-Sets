//
//  Trainer+Extension.swift
//  Tree Sets
//
//  Created by Cristianno Vieira on 24/01/17.
//  Copyright © 2017 Cristianno Vieira. All rights reserved.
//

import Foundation
import CoreData

extension Trainer {
  static func getTrainers(_ forCategory: TrainerClass?) -> [Trainer] {
    if let category = forCategory {
      return category.trainers?.allObjects as! [Trainer]
    }
    
    //let fetch = NSFetchRequest(entityName: "Trainer")
    let fetch = NSFetchRequest<Trainer>(entityName: "Trainer")
    
    do {
      let trainers = try PopulateDB.CDWrapper.managedObjectContext.fetch(fetch)
      return trainers
    } catch {
      print("Failed to retrieve record: \(error)")
    }
    
    return []
  }
}
