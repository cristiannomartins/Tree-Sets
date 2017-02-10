//
//  UIViewController+Extensions.swift
//  Tree Sets
//
//  Created by Cristianno Vieira on 09/02/17.
//  Copyright © 2017 Cristianno Vieira. All rights reserved.
//

import UIKit

// Put this piece of code anywhere you like
extension UIViewController {
  func hideKeyboardWhenTappedAround() {
    let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
    view.addGestureRecognizer(tap)
  }
  
  func dismissKeyboard() {
    view.endEditing(true)
  }
}
