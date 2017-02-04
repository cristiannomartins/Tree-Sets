//
//  TabBarVC.swift
//  Tree Sets
//
//  Created by Cristianno Vieira on 28/12/16.
//  Copyright © 2016 Cristianno Vieira. All rights reserved.
//

import UIKit

class TabBarVC: UITabBarController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // set up the items coloration to have their original color scheme
    for item in tabBar.items! {
      let image = item.image!
      item.selectedImage = image.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
      item.image = item.selectedImage
    }
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
}

