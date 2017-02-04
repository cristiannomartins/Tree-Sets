//
//  PokemonSetsCell.swift
//  Tree Sets
//
//  Created by Cristianno Vieira on 24/01/17.
//  Copyright © 2017 Cristianno Vieira. All rights reserved.
//

import UIKit

class PokemonSetsCell: UITableViewCell {

  @IBOutlet weak var hpTotal: UILabel!
  @IBOutlet weak var atkTotal: UILabel!
  @IBOutlet weak var defTotal: UILabel!
  @IBOutlet weak var spaTotal: UILabel!
  @IBOutlet weak var spdTotal: UILabel!
  @IBOutlet weak var speTotal: UILabel!
  
  @IBOutlet weak var firstAbility: UILabel!
  @IBOutlet weak var secondAbility: UILabel!
  @IBOutlet weak var hiddenAbility: UILabel!
  
  @IBOutlet weak var nature: UILabel!
  @IBOutlet weak var holdItem: UILabel!
  @IBOutlet weak var move1: UILabel!
  @IBOutlet weak var move2: UILabel!
  @IBOutlet weak var move3: UILabel!
  @IBOutlet weak var move4: UILabel!
  
  //  @IBOutlet weak var hpBar: UIProgressView!
  //  @IBOutlet weak var atkBar: UIProgressView!
  //  @IBOutlet weak var defBar: UIProgressView!
  //  @IBOutlet weak var spaBar: UIProgressView!
  //  @IBOutlet weak var spdBar: UIProgressView!
  //  @IBOutlet weak var speBar: UIProgressView!
  
  @IBOutlet weak var hpLabel: UILabel!
  @IBOutlet weak var atkLabel: UILabel!
  @IBOutlet weak var defLabel: UILabel!
  @IBOutlet weak var spaLabel: UILabel!
  @IBOutlet weak var spdLabel: UILabel!
  @IBOutlet weak var speLabel: UILabel!
  
  //@IBOutlet weak var itemImage: UIImageView!
  @IBOutlet weak var itemImage: UIButton!
  @IBOutlet weak var pkmImage: UIImageView!
  @IBOutlet weak var pkmSetID: UILabel!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
  enum Stats: Int {
    case hp = 0
    case atk
    case def
    case spa
    case spd
    case spe
  }
  
  func removeItem (statsBuff: [Int]) {
    switch holdItem.text! {
    // reset atk
    case "Choice Band", "Muscle Band", "Thick Club":
      atkTotal.text = "\(statsBuff[Stats.atk.rawValue])"
    case "Cell Battery", "Liechi Berry", "Snowball":
      atkTotal.text = "\(Int(floor(Double(statsBuff[Stats.atk.rawValue]) * 1.5)))"
    case "Life Orb":
      atkTotal.text = "\(statsBuff[Stats.atk.rawValue])"
      spaTotal.text = "\(statsBuff[Stats.spa.rawValue])"
    case "Weakness Policy":
      atkTotal.text = "\(Int(floor(Double(statsBuff[Stats.atk.rawValue]) * 2.0)))"
      spaTotal.text = "\(Int(floor(Double(statsBuff[Stats.spa.rawValue]) * 2.0)))"
      
    // reset def
    case "Ganlon Berry", "Kee Berry":
      defTotal.text = "\(Int(floor(Double(statsBuff[Stats.def.rawValue]) * 1.5)))"
      
    // reset spa
    case "Choice Specs", "Wise Glasses":
      spaTotal.text = "\(statsBuff[Stats.spa.rawValue])"
    case "Absorb Bulb", "Petaya Berry":
      spaTotal.text = "\(Int(floor(Double(statsBuff[Stats.spa.rawValue]) * 1.5)))"
      
    // reset spd
    case "Apicot Berry", "Luminous Moss", "Maranga Berry":
      spdTotal.text = "\(Int(floor(Double(statsBuff[Stats.spd.rawValue]) * 1.5)))"
    case "Assault Vest":
      spdTotal.text = "\(statsBuff[Stats.spd.rawValue])"
      
    // reset spe
    case "Choice Scarf", "Iron Ball":
      speTotal.text = "\(statsBuff[Stats.spe.rawValue])"
    case "Salac Berry":
      speTotal.text = "\(Int(floor(Double(statsBuff[Stats.spe.rawValue]) * 1.5)))"
      
    default: break
    }
  }
  
  func addItem(statsBuff: [Int]) {
    switch holdItem.text! {
    // set atk
    case "Choice Band":
      atkTotal.text = "\(Int(floor(Double(statsBuff[Stats.atk.rawValue]) * 1.5)))"
    case "Cell Battery", "Liechi Berry", "Snowball":
      atkTotal.text = "\(statsBuff[Stats.atk.rawValue])"
    case "Life Orb":
      atkTotal.text = "\(Int(floor(Double(statsBuff[Stats.atk.rawValue]) * 1.3)))"
      spaTotal.text = "\(Int(floor(Double(statsBuff[Stats.spa.rawValue]) * 1.3)))"
    case "Muscle Band":
      atkTotal.text = "\(Int(floor(Double(statsBuff[Stats.atk.rawValue]) * 1.1)))"
    //FIXME: Thick Club only boosts cubone's or marowak's attack
    case "Thick Club":
      atkTotal.text = "\(Int(floor(Double(statsBuff[Stats.atk.rawValue]) * 2.0)))"
    case "Weakness Policy":
      atkTotal.text = "\(statsBuff[Stats.atk.rawValue])"
      spaTotal.text = "\(statsBuff[Stats.spa.rawValue])"
      
    //set def
    case "Ganlon Berry", "Kee Berry":
      defTotal.text = "\(statsBuff[Stats.def.rawValue])"
      
    // set spa
    case "Choice Specs":
      spaTotal.text = "\(Int(floor(Double(statsBuff[Stats.spa.rawValue]) * 1.5)))"
    case "Absorb Bulb", "Petaya Berry":
      spaTotal.text = "\(statsBuff[Stats.spa.rawValue])"
    case "Wise Glasses":
      spaTotal.text = "\(Int(floor(Double(statsBuff[Stats.spa.rawValue]) * 1.1)))"
      
    // set spd
    case "Apicot Berry", "Luminous Moss", "Maranga Berry":
      spdTotal.text = "\(statsBuff[Stats.spd.rawValue])"
    case "Assault Vest":
      spdTotal.text = "\(Int(floor(Double(statsBuff[Stats.spd.rawValue]) * 1.5)))"
      
    // set spe
    case "Choice Scarf":
      speTotal.text = "\(Int(floor(Double(statsBuff[Stats.spe.rawValue]) * 1.5)))"
    case "Iron Ball":
      speTotal.text = "\(Int(floor(Double(statsBuff[Stats.spe.rawValue]) / 2.0)))"
    case "Salac Berry":
      speTotal.text = "\(statsBuff[Stats.spe.rawValue])"
      
    default: break
    }
  }

}
