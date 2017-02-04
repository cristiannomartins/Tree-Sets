//
//  Image.swift
//  Maison Sets
//
//  Created by Cristianno Vieira on 08/12/15.
//  Copyright © 2015 Cristianno Vieira. All rights reserved.
//

import Foundation
import CoreData
import UIKit


public class Image: NSManagedObject {
  
  static public let ImageColumns = 39
  static public let PkmColumns = 32
  
  class Sprite {
    var height:      Int16 = 30 // size of the sprite
    var width:       Int16 = 30
    var offsetX:     Int16 = 0  // offset at the beginning of the sheet
    var offsetY:     Int16 = 0
    var gapX:        Int16 = 0  // gap in between two sprites
    var gapY:        Int16 = 0
    var nLines:      Int16 = 0  // size of the sheet
    var nColumns:    Int16 = 0
    var spriteSheet: CIImage
    
    fileprivate init (offsetX: Int16, offsetY: Int16, gapX: Int16, gapY: Int16, nLines: Int16, nColumns: Int16, spriteFile: String) {
      self.offsetX = offsetX
      self.offsetY = offsetY
      self.gapX = gapX
      self.gapY = gapY
      self.nLines = nLines
      self.nColumns = nColumns
      self.spriteSheet = CIImage(image: UIImage(named: spriteFile)!)!
    }
    
    static let PokemonSprite = Sprite(offsetX: -30, offsetY: 5, gapX: 1, gapY: 11, nLines: 33, nColumns: 32, spriteFile: "pokesprite")
    static let ItemSprite    = Sprite(offsetX: -30, offsetY: 0, gapX: 3, gapY: 3, nLines: 22, nColumns: 39, spriteFile: "items")
  }
  
  var buffer: UIImage?
  static var _downloadQueue = DispatchQueue(label: "com.Maison_Sets.processdownload", attributes: [])
  
  func async_setUIImage(_ sprite: Sprite, to: @escaping (UIImage) -> Void) {
    if let prebuild = buffer {
      to(prebuild)
      return
    }
    
    to(#imageLiteral(resourceName: "ultraball"))
    
    //let downloadQueue = DispatchQueue(label: "com.Maison_Sets.processdownload", attributes: [])
    
    Image._downloadQueue.async(execute: {
      let positionX = CGFloat(sprite.offsetX + (sprite.height + sprite.gapX) * (sprite.nLines - Int16(self.x!))) // each sprite size + offset
      let positionY = CGFloat(sprite.offsetY + (sprite.width + sprite.gapY) * Int16(self.y!))
      
//      if sprite.spriteSheet == Sprite.PokemonSprite.spriteSheet {
//        print("x: \(self.x!), y: \(self.y!), posX: \(positionX), posY: \(positionY)")
//      }
      
      let rect = CGRect(x: positionY, y: positionX,
                        width: CGFloat(sprite.width),
                        height: CGFloat(sprite.height))
      
      let context = CIContext(options: nil)
      let cgsprite = context.createCGImage(sprite.spriteSheet, from: rect)
      
      self.buffer = UIImage(cgImage: cgsprite!)
      
      DispatchQueue.main.async(execute: {
        to(self.buffer!)
      })
    })
  }
  
}
