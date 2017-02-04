//
//  UITableView+Extension.swift
//  Tree Sets
//
//  Created by Cristianno Vieira on 24/01/17.
//  Copyright © 2017 Cristianno Vieira. All rights reserved.
//

import UIKit

extension UITableView {
  //	func hideSearchBar () {
  //		if let searchBar = tableHeaderView as? UISearchBar {
  //			bounds.origin.y = searchBar.bounds.size.height
  //		}
  //	}
  
  func hideTableHeaderView () {
    if let header = tableHeaderView {
      bounds.origin.y = header.bounds.size.height
    }
  }
}
