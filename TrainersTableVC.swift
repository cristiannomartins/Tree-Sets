//
//  TrainersTableVC.swift
//  Tree Sets
//
//  Created by Cristianno Vieira on 28/12/16.
//  Copyright © 2016 Cristianno Vieira. All rights reserved.
//

import UIKit

class TrainersTableVC: UITableViewController, UISearchResultsUpdating {
  
  var resultSearchControler: UISearchController!
  var trainers: [Trainer]!            // list of all trainers on the datasource
  var filteredTrainers: [Trainer]!    // trainers visible to the user
  
  var category: TrainerClass?
  
  override func viewWillAppear(_ animated: Bool) {
    tableView.reloadData()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // starts the trainer's list with all the trainers on the datasource
    trainers = Trainer.getTrainers(category)
    trainers.sort(by: { t1, t2 in t1.name! < t2.name! })
    filteredTrainers = trainers
    
    // how to programatically set up a reuse identifier for a TableViewCell
    //self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
    
    // setting up a search bar for the tableView
    resultSearchControler = UISearchController(searchResultsController: nil)
    resultSearchControler.searchResultsUpdater = self
    resultSearchControler.dimsBackgroundDuringPresentation = false
    resultSearchControler.searchBar.sizeToFit()
    tableView.tableHeaderView = resultSearchControler.searchBar
    //tableView.hideSearchBar()
    tableView.hideTableHeaderView()
    
    // finish setting up the tableView: this class is both, datasource and delegate for it
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
    filteredTrainers.removeAll(keepingCapacity: false)
    
    let text = searchController.searchBar.text!
    
    if text == "" {
      filteredTrainers = trainers
    } else {
      let predicate1:NSPredicate = NSPredicate(format: "SELF.name CONTAINS[c] %@", text)
      let predicate2:NSPredicate = NSPredicate(format: "SELF.trainerClass.name CONTAINS[c] %@", text)
      let predicate:NSPredicate  = NSCompoundPredicate(orPredicateWithSubpredicates: [predicate1,predicate2])
      let result = (trainers as NSArray).filtered(using: predicate) as! [Trainer]
      
      filteredTrainers = result.sorted(by: {s1, s2 in s1.name! < s2.name!})
    }
    tableView.reloadData()
  }
  
  // MARK: - Table view data source
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return filteredTrainers.count
  }
  
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "tcell", for: indexPath) as! TrainerCell
    
    cell.limits.text = "[\(filteredTrainers[(indexPath as NSIndexPath).row].start ?? "?")"
    if filteredTrainers[(indexPath as NSIndexPath).row].start! != filteredTrainers[(indexPath as NSIndexPath).row].end! {
      cell.limits.text = cell.limits.text! + " - \(filteredTrainers[(indexPath as NSIndexPath).row].end ?? "?")"
    }
    cell.limits.text = cell.limits.text! + "]"
    
    cell.tName.text = filteredTrainers[(indexPath as NSIndexPath).row].name
    cell.tCategory.text = filteredTrainers[(indexPath as NSIndexPath).row].trainerClass!.name
    
    cell.trainer = filteredTrainers[(indexPath as NSIndexPath).row]
    
    return cell
  }
  
  // MARK: - Navigation
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if let dest = segue.destination as? PokemonsTableVC {
      
      let selectedTrainer = (sender as! TrainerCell).trainer
      dest.pokedex = selectedTrainer?.availableMons
      dest.title = selectedTrainer?.name
      
      // makes sure the search is deactivated for next time
      if self.resultSearchControler.isActive {
        resultSearchControler.isActive = false
      }
    }
  }
  
  @IBAction func cancelToTrainersViewController(_ segue:UIStoryboardSegue) {
  }
  
  @IBAction func saveTrainerDetail(_ segue:UIStoryboardSegue) {
  }
  
  // allows only exits through gestures performed if this view was stacked via
  // a segue from Trainers
//  @IBAction func segueBackToCategories(_ sender: AnyObject) {
//    if category != nil {
//      performSegue(withIdentifier: "cancelToCategories", sender: self)
//    }
//  }
//  
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
