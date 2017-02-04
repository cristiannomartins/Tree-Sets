//
//  TrainerCell.swift
//  Tree Sets
//
//  Created by Cristianno Vieira on 24/01/17.
//  Copyright © 2017 Cristianno Vieira. All rights reserved.
//

import UIKit

class TrainerCell: UITableViewCell {
  
  //@IBOutlet weak var tImage: UIImageView!
  @IBOutlet weak var tName: UILabel!
  @IBOutlet weak var tCategory: UILabel!
  @IBOutlet weak var limits: UILabel!
  
  var trainer: Trainer!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
}
