//
//  PokemonSetsVC.swift
//  Tree Sets
//
//  Created by Cristianno Vieira on 24/01/17.
//  Copyright © 2017 Cristianno Vieira. All rights reserved.
//

import UIKit
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// UIImage+Alpha.swift

extension UIImage{
  
  func alpha(value:CGFloat)->UIImage
  {
    UIGraphicsBeginImageContextWithOptions(size, false, scale)
    draw(at: CGPoint.zero, blendMode: .normal, alpha: value)
    let newImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return newImage!
    
  }
}


class PokemonSetsVC: UITableViewController {

  //var sets: [Pokemon:[PokemonSet]] = [:] // sets of mons to show in detail
  var tuples: [(key: Pokemon, value: [PokemonSet])] = []
  //var sortedKeys:[Pokemon]! // dictionary keys in alphabetical order
  var statsBuff: [PokemonSet:[Int]] = [:]
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // alphabetically sort the keys
    //		for key in sets.keys {
    //			sets[key]?.sort(by: { p1, p2 in p1.setID < p2.setID })
    //		}
    
    //FIXME: Descobrir pq esse sortedKeys está gerando memory leaks =/
    //sortedKeys = sets.keys.sorted() { $0.species < $1.species }
    //sortedKeys.append(contentsOf: keys)
    
    
    // tells table to get data and delegate to this class
    tableView.dataSource = self
    tableView.delegate = self
    
    // clears the stats buffer
    //statsBuff.removeAll()
  }
  
  //	deinit {
  ////		sortedKeys.removeAll()
  ////		for key in sets.keys {
  ////			sets[key]?.removeAll()
  ////		}
  ////		sets.removeAll()
  ////
  ////		for key in statsBuff.keys {
  ////			statsBuff[key]?.removeAll()
  ////		}
  ////		statsBuff.removeAll()
  //		//hasItemEnabled.removeAll()
  //	}
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  // MARK: - Table view data source
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    return tuples.count //sortedKeys.count
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return tuples[section].value.count //sets[sortedKeys[section]]!.count
  }
  
  override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return tuples[section].key.species //sortedKeys[section].species;
  }
  
  // configuring cells
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "pscell", for: indexPath) as! PokemonSetsCell
    cell.layer.shouldRasterize = true
    cell.layer.rasterizationScale = UIScreen.main.scale
    
    //print(indexPath)
    
    let pkmSet = tuples[indexPath.section].value[indexPath.row] //sets[sortedKeys[indexPath.section]]![indexPath.row]
    
    // id, item and nature
    cell.pkmSetID.text = "\(pkmSet.setID!)"
    cell.holdItem.text = pkmSet.holding!.name
    cell.nature.text = pkmSet.nature
    
    // existing abilities
    cell.firstAbility.text = pkmSet.species!.firstAbility!.name
    
    if let second = pkmSet.species!.secondAbility, second.name != "#N/A", second.name != cell.firstAbility.text {
      cell.secondAbility.text = second.name
      cell.secondAbility.textColor = UIColor.black
    } else {
      cell.secondAbility.textColor = UIColor.clear
    }
    
    if let hidden = pkmSet.species!.hiddenAbility, hidden.name != "#N/A", hidden.name != cell.firstAbility.text {
      cell.hiddenAbility.text = hidden.name
      cell.hiddenAbility.textColor = UIColor.black
    } else {
      cell.hiddenAbility.textColor = UIColor.clear
    }
    
    // existing moves
    let moveSet = pkmSet.moveSet?.allObjects as! [Move]
    cell.move1.text = moveSet[0].name
    
    if moveSet.count > 1 {
      cell.move2.text = moveSet[1].name
    } else {
      cell.move2.text = "—"
    }
    if moveSet.count > 2 {
      cell.move3.text = moveSet[2].name
    } else {
      cell.move3.text = "—"
    }
    if moveSet.count > 3 {
      cell.move4.text = moveSet[3].name
    } else {
      cell.move4.text = "—"
    }
    
    if statsBuff[pkmSet] == nil {
      // calculating total stats
      statsBuff[pkmSet] = [Int].init(repeating: 0, count: 6)
      for stat in pkmSet.preCalcStats?.allObjects as! [Stats] {
        statsBuff[pkmSet]![Int(stat.id)] = Int(stat.value)
      }
    }
    
    // megastones
//    if cell.holdItem!.text!.hasSuffix("ite") {
//      // FIXME: MegaSet does not come from the tuples
//      let megaSet = tuples[indexPath.section].value[indexPath.row]
//      statsBuff[megaSet] = [Int].init(repeating: 0, count: 6)
//      for stat in megaSet.preCalcStats?.allObjects as! [Stats] {
//        statsBuff[megaSet]![Int(stat.id)] = Int(stat.value)
//      }
//    }
    
    cell.hpTotal.text  = String(statsBuff[pkmSet]![0])
    cell.atkTotal.text = String(statsBuff[pkmSet]![1])
    cell.defTotal.text = String(statsBuff[pkmSet]![2])
    cell.spaTotal.text = String(statsBuff[pkmSet]![3])
    cell.spdTotal.text = String(statsBuff[pkmSet]![4])
    cell.speTotal.text = String(statsBuff[pkmSet]![5])
    
    // shows variations on stats caused by held items
    if (hasItemEnabled.index(forKey: indexPath) != nil) && !hasItemEnabled[indexPath]! {
      cell.holdItem.alpha = 0.2
      
      pkmSet.holding!.image!.async_setUIImage(.ItemSprite) {
        [weak weakSelf = self] in
        if let visibleRows = weakSelf?.tableView.indexPathsForVisibleRows, visibleRows.contains(indexPath) {
          //if let cell = self.tableView.cellForRow(at: indexPath) as? PokemonSetsCell {
          cell.itemImage.setImage($0.alpha(value: 0.2), for: [])
        }
      }
      // remoção do item dos stats
      cell.removeItem(statsBuff: statsBuff[pkmSet]!)
    } else {
      cell.addItem(statsBuff: statsBuff[pkmSet]!)
      hasItemEnabled[indexPath] = true
      cell.holdItem.alpha = 1.0
      
      pkmSet.holding!.image!.async_setUIImage(.ItemSprite) {
        [weak weakSelf = self] in
        if let visibleRows = weakSelf?.tableView.indexPathsForVisibleRows, visibleRows.contains(indexPath) {
          //if let cell = self.tableView.cellForRow(at: indexPath) as? PokemonSetsCell {
          cell.itemImage.setImage($0, for: [])
        }
      }
    }
    
    // asynchronously sets up the image views for the cell, to speed up the tableView
    pkmSet.image!.async_setUIImage(.PokemonSprite)
    {
      [weak weakSelf = self] in
      if let visibleRows = weakSelf?.tableView.indexPathsForVisibleRows, visibleRows.contains(indexPath) {
        //if let cell = self.tableView.cellForRow(at: indexPath) as? PokemonSetsCell {
        cell.pkmImage.image = $0
      }
    }
    
    // highlighting stats modifications from natures
    let changedStats = pkmSet.getChangedStats()
    if      changedStats.increased == .atk { cell.atkLabel.textColor = UIColor.red   }
    else if changedStats.decreased == .atk { cell.atkLabel.textColor = UIColor.blue  }
    else                                   { cell.atkLabel.textColor = UIColor.black }
    if      changedStats.increased == .def { cell.defLabel.textColor = UIColor.red   }
    else if changedStats.decreased == .def { cell.defLabel.textColor = UIColor.blue  }
    else                                   { cell.defLabel.textColor = UIColor.black }
    if      changedStats.increased == .spa { cell.spaLabel.textColor = UIColor.red   }
    else if changedStats.decreased == .spa { cell.spaLabel.textColor = UIColor.blue  }
    else                                   { cell.spaLabel.textColor = UIColor.black }
    if      changedStats.increased == .spd { cell.spdLabel.textColor = UIColor.red   }
    else if changedStats.decreased == .spd { cell.spdLabel.textColor = UIColor.blue  }
    else                                   { cell.spdLabel.textColor = UIColor.black }
    if      changedStats.increased == .spe { cell.speLabel.textColor = UIColor.red   }
    else if changedStats.decreased == .spe { cell.speLabel.textColor = UIColor.blue  }
    else                                   { cell.speLabel.textColor = UIColor.black }
    
    // set up the progress bar completion and color, based on where EVs are invested
    //    cell.hpBar.progress = Float(hp)/362.0
    //    cell.atkBar.progress = Float(atk)/337.0
    //    cell.defBar.progress = Float(def)/337.0
    //    cell.spaBar.progress = Float(spa)/337.0
    //    cell.spdBar.progress = Float(spd)/337.0
    //    cell.speBar.progress = Float(spe)/337.0
    
    //    if pkmSet.evhp != 0 { cell.hpBar.progressTintColor = UIColor(red: 1.0, green: 0.0, blue: 0.0, alpha: 1.0) }
    //    else { cell.hpBar.progressTintColor = UIColor(red: 0.0, green: 0.0, blue: 1.0, alpha: 1.0) }
    //    if pkmSet.evatk != 0 { cell.atkBar.progressTintColor = UIColor(red: 1.0, green: 0.0, blue: 0.0, alpha: 1.0) }
    //    else { cell.atkBar.progressTintColor = UIColor(red: 0.0, green: 0.0, blue: 1.0, alpha: 1.0) }
    //    if pkmSet.evdef != 0 { cell.defBar.progressTintColor = UIColor(red: 1.0, green: 0.0, blue: 0.0, alpha: 1.0) }
    //    else { cell.defBar.progressTintColor = UIColor(red: 0.0, green: 0.0, blue: 1.0, alpha: 1.0) }
    //    if pkmSet.evspa != 0 { cell.spaBar.progressTintColor = UIColor(red: 1.0, green: 0.0, blue: 0.0, alpha: 1.0) }
    //    else { cell.spaBar.progressTintColor = UIColor(red: 0.0, green: 0.0, blue: 1.0, alpha: 1.0) }
    //    if pkmSet.evspd != 0 { cell.spdBar.progressTintColor = UIColor(red: 1.0, green: 0.0, blue: 0.0, alpha: 1.0) }
    //    else { cell.spdBar.progressTintColor = UIColor(red: 0.0, green: 0.0, blue: 1.0, alpha: 1.0) }
    //    if pkmSet.evspe != 0 { cell.speBar.progressTintColor = UIColor(red: 1.0, green: 0.0, blue: 0.0, alpha: 1.0) }
    //    else { cell.speBar.progressTintColor = UIColor(red: 0.0, green: 0.0, blue: 1.0, alpha: 1.0) }
    
    //    if pkmSet.evhp != 0 { cell.hpLabel.backgroundColor = UIColor(white: 0.8, alpha: 1.0) }
    //    else { cell.hpLabel.backgroundColor = UIColor.clear }
    //    if pkmSet.evatk != 0 { cell.atkLabel.backgroundColor = UIColor(white: 0.8, alpha: 1.0) }
    //    else { cell.atkLabel.backgroundColor = UIColor.clear }
    //    if pkmSet.evdef != 0 { cell.defLabel.backgroundColor = UIColor(white: 0.8, alpha: 1.0) }
    //    else { cell.defLabel.backgroundColor = UIColor.clear }
    //    if pkmSet.evspa != 0 { cell.spaLabel.backgroundColor = UIColor(white: 0.8, alpha: 1.0) }
    //    else { cell.spaLabel.backgroundColor = UIColor.clear }
    //    if pkmSet.evspd != 0 { cell.spdLabel.backgroundColor = UIColor(white: 0.8, alpha: 1.0) }
    //    else { cell.spdLabel.backgroundColor = UIColor.clear }
    //    if pkmSet.evspe != 0 { cell.speLabel.backgroundColor = UIColor(white: 0.8, alpha: 1.0) }
    //    else { cell.speLabel.backgroundColor = UIColor.clear }
    for stat in pkmSet.evs?.allObjects as! [Stats] {
      //print("stat.id \(stat.id) stat.value \(stat.value)")
      switch PopulateDB.StatID(rawValue: stat.id)! {
      case .HP:
        if stat.value != 0 { cell.hpTotal.textColor = UIColor(red: 1.0, green: 0.0, blue: 0.0, alpha: 1.0) }
        else { cell.hpTotal.textColor = UIColor.black }
      case .Atk:
        if stat.value != 0 { cell.atkTotal.textColor = UIColor(red: 1.0, green: 0.0, blue: 0.0, alpha: 1.0) }
        else { cell.atkTotal.textColor = UIColor.black }
      case .Def:
        if stat.value != 0 { cell.defTotal.textColor = UIColor(red: 1.0, green: 0.0, blue: 0.0, alpha: 1.0) }
        else { cell.defTotal.textColor = UIColor.black }
      case .Spa:
        if stat.value != 0 { cell.spaTotal.textColor = UIColor(red: 1.0, green: 0.0, blue: 0.0, alpha: 1.0) }
        else { cell.spaTotal.textColor = UIColor.black }
      case .Spd:
        if stat.value != 0 { cell.spdTotal.textColor = UIColor(red: 1.0, green: 0.0, blue: 0.0, alpha: 1.0) }
        else { cell.spdTotal.textColor = UIColor.black }
      case .Spe:
        if stat.value != 0 { cell.speTotal.textColor = UIColor(red: 1.0, green: 0.0, blue: 0.0, alpha: 1.0) }
        else { cell.speTotal.textColor = UIColor.black }
      }
    }
    
    // prepare for itemButton pressing
    //buttonToSpeTotal[cell.itemImage] = cell.speTotal
    //buttonToSpaTotal[cell.itemImage] = cell.spaTotal
    //buttonToAtkTotal[cell.itemImage] = cell.atkTotal
    
    //		if !hasItemEnabled.keys.contains(indexPath) {
    //			hasItemEnabled[indexPath] = true
    //			//itemForIndex[indexPath] = pkmSet.holding!.name!
    //		}
    
    return cell
  }
  
  //var buttonToSpeTotal: [UIButton:UILabel] = [:]
  //var buttonToSpaTotal: [UIButton:UILabel] = [:]
  //var buttonToAtkTotal: [UIButton:UILabel] = [:]
  var hasItemEnabled: [IndexPath:Bool] = [:]
  //var itemForIndex: [IndexPath:String] = [:]
  
  @IBAction func itemButtonPressed(_ button: UIButton) {
    // find the PokemonSetsCell (which is a superview of button, on the views hierarchy)
    var view: UIView? = button
    var cell: PokemonSetsCell?
    repeat {
      view = view?.superview
      cell = view as? PokemonSetsCell
    } while (cell == nil);
    
    let indexPath = tableView.indexPath(for:cell!)!
    let pkmSet = tuples[indexPath.section].value[indexPath.row]
    
    if hasItemEnabled[indexPath]! {
      pkmSet.holding!.image!.async_setUIImage(.ItemSprite) {
        [weak weakSelf = self] in
        if let visibleRows = weakSelf?.tableView.indexPathsForVisibleRows, visibleRows.contains(indexPath) {
          cell?.itemImage.setImage($0.alpha(value: 0.2), for: [])
          cell?.holdItem.alpha = 0.2
        }
      }
      
      // remoção do item dos stats
      cell?.removeItem(statsBuff: statsBuff[pkmSet]!)
    } else {
      pkmSet.holding!.image!.async_setUIImage(.ItemSprite) {
        [weak weakSelf = self] in
        if let visibleRows = weakSelf?.tableView.indexPathsForVisibleRows, visibleRows.contains(indexPath) {
          cell?.itemImage.setImage($0, for: [])
          cell?.holdItem.alpha = 1.0
        }
      }
      
      // adição do item nos stats
      cell?.addItem(statsBuff: statsBuff[pkmSet]!)
    }
    hasItemEnabled[indexPath] = !hasItemEnabled[indexPath]!
  }
}





















