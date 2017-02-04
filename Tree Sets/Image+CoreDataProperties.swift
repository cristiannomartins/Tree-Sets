//
//  Image+CoreDataProperties.swift
//  Tree Sets
//
//  Created by Cristianno Vieira on 02/02/17.
//  Copyright © 2017 Cristianno Vieira. All rights reserved.
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData


extension Image {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Image> {
        return NSFetchRequest<Image>(entityName: "Image");
    }

    @NSManaged public var x: NSNumber?
    @NSManaged public var y: NSNumber?
    @NSManaged public var item: Item?
    @NSManaged public var pokemon: PokemonSet?
    @NSManaged public var trainerClass: TrainerClass?

}
