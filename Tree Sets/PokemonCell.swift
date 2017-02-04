//
//  PokemonCell.swift
//  Tree Sets
//
//  Created by Cristianno Vieira on 24/01/17.
//  Copyright © 2017 Cristianno Vieira. All rights reserved.
//

import UIKit

class PokemonCell: UITableViewCell {
  
  var pkm: Pokemon!
  
  @IBOutlet weak var sets: UILabel!
  @IBOutlet weak var checkmark: Checkmark!
  @IBOutlet weak var pName: UILabel!
  @IBOutlet weak var pImage: UIImageView!
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
}
