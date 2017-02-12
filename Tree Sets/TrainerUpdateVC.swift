//
//  TrainerUpdateVC.swift
//  Tree Sets
//
//  Created by Cristianno Vieira on 25/01/17.
//  Copyright © 2017 Cristianno Vieira. All rights reserved.
//

import UIKit
import CoreData

class TrainerUpdateVC: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
  
  @IBOutlet weak var categoryPicker: UIPickerView!
  @IBOutlet weak var endPicker: UIPickerView!
  @IBOutlet weak var startPicker: UIPickerView!
  @IBOutlet weak var sexPicker: UIPickerView!
  @IBOutlet weak var nameTF: UITextField!
  
  var trainersName: String!
  var activity: UIActivityIndicatorView = UIActivityIndicatorView()
  
  let sexData = ["M", "F", "?"]
  static var categoryData: [String]? = nil
  
  @IBAction func hasNewName(_ sender: AnyObject) {
    trainersName = nameTF.text
    
    let fetchTrainer = NSFetchRequest<Trainer>(entityName: "Trainer")
    fetchTrainer.predicate = NSPredicate(format: "SELF.name ==[c] %@", trainersName)
    
    do {
      let trainers = try PopulateDB.CDWrapper.managedObjectContext.fetch(fetchTrainer)
      
      if let t = trainers.first {
        sexPicker.selectRow(getSexLine(t), inComponent: 0, animated: false)
        startPicker.selectRow(Int(t.start ?? "0")!, inComponent: 0, animated: false)
        endPicker.selectRow(Int(t.end ?? "0")!, inComponent: 0, animated: false)
        categoryPicker.selectRow(getCategoryLine(t.trainerClass!), inComponent: 0, animated: false)
      } else {
        // create the alert
        let alert = UIAlertController(title: "Search", message: "There is no trainer named \(trainersName!) on the database.", preferredStyle: UIAlertControllerStyle.alert)
        
        // add an action (button)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        
        // show the alert
        self.present(alert, animated: true, completion: nil)
      }
    } catch {
      print("Failed to retrieve record: \(error)")
    }
  }
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    self.hasNewName(self)
    return true
  }
  
  func getCSV() -> URL? {
    var text = "name;class;sex;start;end"
    
    let fetchTrainers = NSFetchRequest<Trainer>(entityName: "Trainer")
    
    do {
      let trainers = try PopulateDB.CDWrapper.managedObjectContext.fetch(fetchTrainers)
      
      for t in trainers {
        text = text + "\n\(t.name!);\(t.trainerClass!.name!);\(t.sex!);\(t.start ?? "");\(t.end ?? "")"
      }
    } catch {
      print("Failed to retrieve record: \(error)")
      return nil
    }
    
    if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
      let path = dir.appendingPathComponent("trainer.csv")
      //writing
      do {
        try text.write(to: path, atomically: false, encoding: String.Encoding.utf8)
      }
      catch {
        print("Failed to write to file: \(error)")
        return nil
      }
      
      return path
    }
    
    return nil
  }
  
  @IBAction func exportCSV(_ sender: UIButton) {
    activity.isHidden = false
    activity.startAnimating()
    
    PopulateDB.processingQueue.async {
      //var text: String
      //var filename: String
      let path: URL
      path = self.getCSV()!
      
      DispatchQueue.main.async {
        self.activity.stopAnimating()
        
        // 2
        let activityViewController = UIActivityViewController(activityItems:
          [path], applicationActivities: nil)
        
        // 3
        let excludeActivities = [
          UIActivityType.assignToContact,
          UIActivityType.saveToCameraRoll,
          UIActivityType.addToReadingList,
          UIActivityType.postToFlickr,
          UIActivityType.postToVimeo]
        activityViewController.excludedActivityTypes = excludeActivities
        
        // 4
        self.present(activityViewController, animated: true, completion: nil)
      }
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.hideKeyboardWhenTappedAround()
    
    // Do any additional setup after loading the view.
    if TrainerUpdateVC.categoryData == nil {
      let fetchTrainerCat = NSFetchRequest<TrainerClass>(entityName: "TrainerClass")
      TrainerUpdateVC.categoryData = [String]()
      do {
        let cats = try PopulateDB.CDWrapper.managedObjectContext.fetch(fetchTrainerCat)
        for cat in cats {
          TrainerUpdateVC.categoryData!.append(cat.name!)
        }
      } catch {
        print("Failed to retrieve record: \(error)")
      }
      
      TrainerUpdateVC.categoryData!.sort()
    }
    
    categoryPicker.dataSource = self
    categoryPicker.delegate = self
    startPicker.dataSource = self
    startPicker.delegate = self
    endPicker.dataSource = self
    endPicker.delegate = self
    sexPicker.dataSource = self
    sexPicker.delegate = self
    nameTF.delegate = self
    
    activity.isHidden = true
    activity.hidesWhenStopped = true
    activity.activityIndicatorViewStyle = .whiteLarge
    activity.center = self.view.center
    activity.color = UIColor.red
    view.addSubview(activity)
    resetFields()
  }
  
  func getSexLine(_ t: Trainer) -> Int {
    switch t.sex! {
    case "M":
      return 0
    case "F":
      return 1
    default:
      return 2
    }
  }
  
  func getCategoryLine(_ tc: TrainerClass) -> Int {
    for tclass in 0..<TrainerUpdateVC.categoryData!.count {
      if TrainerUpdateVC.categoryData![tclass] == tc.name! {
        return tclass
      }
    }
    return -1
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  @IBAction func updateDataAndReturn(_ sender: UIButton) {
    // TODO: botões cancel e done devem retornar ao TrainersTable, e done deve salvar mods
    if sender.currentTitle == "Done" {
      let fetchTrainer = NSFetchRequest<Trainer>(entityName: "Trainer")
      fetchTrainer.predicate = NSPredicate(format: "SELF.name == %@", trainersName)
      
      do {
        let trainers = try PopulateDB.CDWrapper.managedObjectContext.fetch(fetchTrainer)
//        if trainers.count != 1 {
//          print("Error: More than one trainer has the same name!!")
//          return
//        }
        
        let t = trainers.first!
        t.sex = sexData[sexPicker.selectedRow(inComponent: 0)]
        
        if startPicker.selectedRow(inComponent: 0) != 0 {
          t.start = "\(startPicker.selectedRow(inComponent: 0))"
        }
        
        if endPicker.selectedRow(inComponent: 0) != 0 {
          t.end = "\(endPicker.selectedRow(inComponent: 0))"
        }
        
        let fetchTrainerCat = NSFetchRequest<TrainerClass>(entityName: "TrainerClass")
        fetchTrainerCat.predicate = NSPredicate(format: "SELF.name == %@", TrainerUpdateVC.categoryData![categoryPicker.selectedRow(inComponent: 0)])
        t.trainerClass = try PopulateDB.CDWrapper.managedObjectContext.fetch(fetchTrainerCat).first!
        
        try t.managedObjectContext?.save()
        
      } catch {
        print("Failed to retrieve record: \(error)")
      }
    }
    resetFields()
    tabBarController?.selectedIndex = 0
    //performSegue(withIdentifier: "trainerUpdated", sender: self)
  }
  
  func resetFields() {
    nameTF.text = ""
    categoryPicker.selectRow(0, inComponent: 0, animated: false)
    sexPicker.selectRow(2, inComponent: 0, animated: false)
    startPicker.selectRow(0, inComponent: 0, animated: false)
    endPicker.selectRow(0, inComponent: 0, animated: false)
  }
  
  //MARK: - Delegates and data sources
  //MARK: Data Sources
  func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 1
  }
  func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    if categoryPicker == pickerView {
      return TrainerUpdateVC.categoryData!.count // how many categories there are?
    } else if sexPicker == pickerView {
      return sexData.count
    } else {
      return 5000
    }
  }
  
  //MARK: Delegates
  func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    if categoryPicker == pickerView {
      return  TrainerUpdateVC.categoryData?[row] // how many categories there are?
    } else if sexPicker == pickerView {
      return sexData[row]
    } else {
      return "\(row)"
    }
  }
  
//  func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
//    //myLabel.text = pickerData[row]
//  }
  
  /*
   // MARK: - Navigation
   
   // In a storyboard-based application, you will often want to do a little preparation before navigation
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
   // Get the new view controller using segue.destinationViewController.
   // Pass the selected object to the new view controller.
   }
   */
  
}
