//
//  LoadingVC.swift
//  Tree Sets
//
//  Created by Cristianno Vieira on 12/02/17.
//  Copyright © 2017 Cristianno Vieira. All rights reserved.
//

import UIKit

class LoadingVC: UIViewController {
  
  @IBOutlet weak var status: UILabel!
  @IBOutlet weak var activity: UIActivityIndicatorView!
  var activity1: UIActivityIndicatorView!
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    activity.isHidden = false
    activity.startAnimating()
    activity.hidesWhenStopped = true
    
    let CDWrapper = PopulateDB.CDWrapper
    let defaults = UserDefaults.standard
    // Start of Database copy from Bundle to App Document Directory
    let fileManager = FileManager.default
    //let appSupportPath = NSURL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.applicationSupportDirectory, .userDomainMask, true)[0])
    let appSupportPath = CDWrapper.applicationDocumentsDirectory
    try? fileManager.createDirectory(at: appSupportPath as URL, withIntermediateDirectories: false, attributes: nil)
    let destinationSqliteURL = appSupportPath.appendingPathComponent("Tree_Sets.sqlite")
    let sourceSqliteURL = Bundle.main.url(forResource: "Tree_Sets", withExtension: "sqlite")
    if let source = sourceSqliteURL, fileManager.fileExists(atPath: source.path) {
      if !fileManager.fileExists(atPath: destinationSqliteURL.path) {
        // var error:NSError? = nil
        do {
          try fileManager.copyItem(atPath: sourceSqliteURL!.path, toPath: destinationSqliteURL.path)
          try fileManager.copyItem(atPath: Bundle.main.url(forResource: "Tree_Sets", withExtension: "sqlite-shm")!.path,
                                   toPath: appSupportPath.appendingPathComponent("Tree_Sets.sqlite-shm").path)
          try fileManager.copyItem(atPath: Bundle.main.url(forResource: "Tree_Sets", withExtension: "sqlite-wal")!.path,
                                   toPath: appSupportPath.appendingPathComponent("Tree_Sets.sqlite-wal").path)
          
          self.status.text = "Database path set."
          print(destinationSqliteURL.path as Any)
          
          defaults.set(true, forKey: "isPreloaded")
          
        } catch let error as NSError {
          print("Unable to create database \(error.debugDescription)")
        }
      } else {
        self.status.text = "Database found."
      }
    } else {
      self.status.text = "Prepopulated Database could not be found in AppBundle."
    }
    
    
    // creating db during first launch
    let isPreloaded = defaults.bool(forKey: "isPreloaded")
    
    if !isPreloaded {
      self.status.text = "Creating new Database."
      PopulateDB.processingQueue.async {
        PopulateDB.preload()
        DispatchQueue.main.async {
          print("New Database created at path: \(destinationSqliteURL.path)")
          defaults.set(true, forKey: "isPreloaded")
          self.status.text = "Database is ready."
          
          // finish
          self.activity.stopAnimating()
          self.perform(#selector(self.showMainApp), with: nil, afterDelay: 0.3)
          //self.performSegue(withIdentifier: "startApplication", sender: self)
        }
      }
      
    } else {
      //status.text = "Database found in Documents directory."
      self.status.text = "Database is ready."
      
      // finish
      self.activity.stopAnimating()
      self.performSegue(withIdentifier: "startApplication", sender: self)
      //self.perform(#selector(self.showMainApp), with: nil, afterDelay: 0.3)
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
    
//    activity1 = UIActivityIndicatorView()
//    
//    activity1.hidesWhenStopped = true
//    activity1.isHidden = false
//    activity1.startAnimating()
  }
  
  func showMainApp() {
    self.performSegue(withIdentifier: "startApplication", sender: self)
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  
  /*
   // MARK: - Navigation
   
   // In a storyboard-based application, you will often want to do a little preparation before navigation
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
   // Get the new view controller using segue.destinationViewController.
   // Pass the selected object to the new view controller.
   }
   */
  
}
