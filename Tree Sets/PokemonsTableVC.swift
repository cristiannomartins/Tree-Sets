//
//  PokemonsTableVC.swift
//  Tree Sets
//
//  Created by Cristianno Vieira on 28/12/16.
//  Copyright © 2016 Cristianno Vieira. All rights reserved.
//

import UIKit

/**
 * Overload of the '<' operator, automatically created by Swift 3 migration tool,
 * in order to allow optional values to be compared without the need of unwrap.
 *
 */
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

class PokemonsTableVC: UITableViewController, UISearchResultsUpdating, UISearchBarDelegate {
  
  // MARK: - Attributes List
  
  var pokedex: Dex? // if not nil, the domain of mons to work with
  // else, the panel that is open is the Pokémon one
  var pokemons: [Pokemon]! // all mons represented on this view
  var pkmnSets: [PokemonSet]! // all mons sets to help set up PokemonSetsVC
  var filteredMons: [Pokemon]! // mons visible to the user
  var selectedRows: [String] = [] // selected mons on tableView
  
  var resultSearchControler: UISearchController! // searchBar container
  
  
  // MARK: - Constructors and Destructors
  
  deinit{
    // garanties the searchBar doesn't have a nil parent view, supressing warning
    if let superView = resultSearchControler.view.superview {
      superView.removeFromSuperview()
    }
  }
  
  // MARK: - UIViewController methods
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // set up initial pokemon list
    pkmnSets = PokemonSet.getPokemonSets(pokedex)
    pokemons = Pokemon.getPokemonSpeciesFromSets(pkmnSets)
    pokemons.sort() { $0.species! < $1.species! }
    filteredMons = pokemons
    
    // sets up searchBar
    resultSearchControler = UISearchController(searchResultsController: nil)
    resultSearchControler.searchResultsUpdater = self
    resultSearchControler.searchBar.delegate = self
    resultSearchControler.dimsBackgroundDuringPresentation = false
    resultSearchControler.searchBar.sizeToFit()
    tableView.tableHeaderView = self.resultSearchControler.searchBar
    //tableView.hideSearchBar()
    tableView.hideTableHeaderView()
    
    // tells table to get data and delegate to this class
    tableView.dataSource = self
    tableView.delegate = self
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = false
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  // MARK: - SearchResults methods
  
  func updateSearchResults(for searchController: UISearchController) {
    filteredMons.removeAll(keepingCapacity: false)
    
    let text = searchController.searchBar.text!
    if text == "" {
      filteredMons = pokemons
    } else {
      filteredMons = pokemons.filter() {
        ($0.species?.localizedCaseInsensitiveContains(text))!
      }
    }
    
    tableView.reloadData()
  }
  
  // MARK: - Table view data source
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return filteredMons.count
  }
  
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = self.tableView.dequeueReusableCell(withIdentifier: "pcell")! as! PokemonCell
    
    cell.pkm = filteredMons[indexPath.row]
    cell.pName.text = filteredMons[indexPath.row].species
    if cell.pName.text!.contains("(Mega ") {
      let components = cell.pName.text!.components(separatedBy: " ")
      cell.pName.text = ""
      for c in components {
        if c == "(Mega" {
          break
        }
        cell.pName.text = "\(cell.pName.text!)\(c) "
      }
      cell.pName.text = "\(cell.pName.text!)(Mega)"
    }
    
    // asynchronously sets up the image view for the cell, to speed up the tableView
    (filteredMons[indexPath.row].sets!.allObjects.first as! PokemonSet).image!.async_setUIImage(.PokemonSprite)
    { [weak weakSelf = self] in
      //if let cell = self.tableView.cellForRow(at: indexPath) as? PokemonCell {
      if let visibleRows = weakSelf?.tableView.indexPathsForVisibleRows, visibleRows.contains(indexPath) {
        cell.pImage.image = $0
      }
    }
    
    // verifies which image to apply to the checkmark of the cell
    if let _ = selectedRows.index(of: cell.pName!.text!) {
      cell.checkmark.isChecked = true // if selected
    } else {
      cell.checkmark.isChecked = false
    }
    
    if let currentDex = pokedex {
      let dexSets = currentDex.contains!.allObjects as! [PokemonSet]
      let pName:String
      
      if cell.pName.text!.hasSuffix(" (Mega)") {
        let species = cell.pName.text!.components(separatedBy: " (Mega)").first!
        pName = "\(species) (Mega \(species))"
      } else {
        pName = cell.pName.text!
      }
      
      var setsForSpecies = dexSets.filter({p in p.species!.species! == pName})
      if setsForSpecies.count == setsForSpecies.first?.species?.sets?.count {
        cell.sets.text = "All"
      } else {
        cell.sets.text = ""
        setsForSpecies.sort(by: { p1, p2 in Int(p1.setID!) < Int(p2.setID!) })
        for set in setsForSpecies {
          if cell.sets.text! == "" {
            cell.sets.text = "\(set.setID!)"
          } else {
            cell.sets.text = "\(cell.sets.text!), \(set.setID!)"
          }
        }
      }
    } else {
      cell.sets.text = "All"
    }
    
    return cell
  }
 
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let pcell = tableView.cellForRow(at: indexPath) as! PokemonCell
    
    // since multi-selection tables always call didSelectRowAtIndexPath, it is
    // necessary to verify if this line is being selected or deselected
    if let index = selectedRows.index(of: pcell.pName!.text!) {
      selectedRows.remove(at: index)
      //NSLog("Deselecting row #\((indexPath as NSIndexPath).row)")
    } else {
      selectedRows.append(pcell.pName!.text!)
      //NSLog("Selecting row #\((indexPath as NSIndexPath).row)")
    }
    // updates the table
    tableView.reloadRows(at: [indexPath], with: .none)
  }
  
  // configuring SearchBar's bookmark button
  func searchBarBookmarkButtonClicked(_ searchBar: UISearchBar) {
    performSegue(withIdentifier: "pushPokemonSets", sender: self)
  }
  
  func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
    self.resultSearchControler.searchBar.showsBookmarkButton = false
  }
  
  func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
    self.resultSearchControler.searchBar.showsBookmarkButton = true
  }
  
  // MARK: - Navigation
  
  // In a storyboard-based application, you will often want to do a little preparation before navigation
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    if let dest = segue.destination as? PokemonSetsVC {
      //dest.sets.removeAll()
      dest.tuples.removeAll();
      
      selectedRows.sort()
      
      for var name in selectedRows {
        if let mega = name.range(of: " (Mega)") {//contains("(Mega)") {
          name.removeSubrange(mega)
          name = "\(name) (Mega \(name))"
        }
        
        if let pkm = pokemons.first(where: { p in p.species == name }) {
          //        if dest.sets[pkm] == nil {
          //          dest.sets[pkm] = []
          //        }
          // appends all sets for that pokemon species on the current domain to the sets to be showed in PokemonSetsVC
          //dest.sets[pkm]!.append(contentsOf: pkmnSets.filter({p in p.species?.species == pkm.species}))
          //dest.sets[pkm] = pkmnSets.filter() {$0.species?.species == pkm.species}
          let sets = pkmnSets.filter() {$0.species?.species == pkm.species}
          dest.tuples.append((key: pkm, value: sets.sorted() {Int($0.setID!) < Int($1.setID!)}))
        }
        
      }
    }
    
    // makes sure the search is deactivated for next time
    //if self.resultSearchControler.isActive {
    resultSearchControler.isActive = false
    //}
  }
  
  // exit segues for PokemonSetsVC to be able to return via gestures
  @IBAction func cancelToPokemonViewController(_ segue:UIStoryboardSegue) {
  }
  
  @IBAction func savePokemonDetail(_ segue:UIStoryboardSegue) {
  }
  
  // allows only exits through gestures performed if this view was stacked via
  // a segue from Trainers
  @IBAction func segueBackToTrainers(_ sender: AnyObject) {
    if pokedex != nil {
      performSegue(withIdentifier: "cancelToTrainers", sender: self)
    }
  }
  
  @IBAction func clearSelection (_ sender: AnyObject) {
    selectedRows.removeAll()
    tableView.reloadData()
  }
  
  /*
   // Override to support conditional editing of the table view.
   override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
   // Return false if you do not want the specified item to be editable.
   return true
   }
   */
  
  /*
   // Override to support editing the table view.
   override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
   if editingStyle == .delete {
   // Delete the row from the data source
   tableView.deleteRows(at: [indexPath], with: .fade)
   } else if editingStyle == .insert {
   // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
   }
   }
   */
  
  /*
   // Override to support rearranging the table view.
   override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
   
   }
   */
  
  /*
   // Override to support conditional rearranging of the table view.
   override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
   // Return false if you do not want the item to be re-orderable.
   return true
   }
   */
  
  /*
   // MARK: - Navigation
   
   // In a storyboard-based application, you will often want to do a little preparation before navigation
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
   // Get the new view controller using segue.destinationViewController.
   // Pass the selected object to the new view controller.
   }
   */
  
}
