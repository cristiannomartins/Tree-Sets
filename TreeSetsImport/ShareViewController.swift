//
//  ShareViewController.swift
//  TreeSetsImport
//
//  Created by Cristianno Vieira on 11/02/17.
//  Copyright © 2017 Cristianno Vieira. All rights reserved.
//

import UIKit
import Social
import CoreData
import MobileCoreServices

class ShareViewController: SLComposeServiceViewController {
  
  override func isContentValid() -> Bool {
    // Do validation of contentText and/or NSExtensionContext attachments here
    return true
  }
  
  override func didSelectPost() {
    // This is called after the user selects Post. Do the upload of contentText and/or NSExtensionContext attachments.
    if let content = extensionContext?.inputItems[0] as? NSExtensionItem {
      let contentType = kUTTypeURL as String
      if let contents = content.attachments as? [NSItemProvider] {
        for attachment in contents {
          if attachment.hasItemConformingToTypeIdentifier(contentType) {
            attachment.loadItem(forTypeIdentifier: contentType, options: nil) {
              data, error in
              let URL = data as! URL
              if let csvData = NSData.init(contentsOf: URL) {
                // save file
                let contentsOfFile = String(data: csvData as Data, encoding: .utf8)!
                self.importExternalTrainerCSV(contentsOfFile)
              }
            }
          }
        }
      }
    }
    
    // Inform the host that we're done, so it un-blocks its UI. Note: Alternatively you could call super's -didSelectPost, which will similarly complete the extension context.
    self.extensionContext!.completeRequest(returningItems: [], completionHandler: nil)
  }
  
  enum ExternalTrainerCSV: Int {
    case name = 0
    case category
    case sex
    case start
    case end
  }
  
  let coreDataWrapper = CoreDataWrapper()
  
  func importExternalTrainerCSV(_ contents: String) {
    let fetchTrainers = NSFetchRequest<Trainer>(entityName: "Trainer")
    let fetchClasses = NSFetchRequest<TrainerClass>(entityName: "TrainerClass")
    
    //let managedObjectContext = persistentContainer.viewContext
    do {
      let trainers = try coreDataWrapper.managedObjectContext.fetch(fetchTrainers)
      let tClasses = try coreDataWrapper.managedObjectContext.fetch(fetchClasses)
      
      var lines = contents.components(separatedBy: "\n")
      lines.remove(at: 0) // gets rid of table's header
      for line in lines {
        let values = line.components(separatedBy: ";")
        if let trainer = trainers.filter({$0.name == values[ExternalTrainerCSV.name.rawValue]}).first {
          trainer.start = values[ExternalTrainerCSV.start.rawValue]
          trainer.end = values[ExternalTrainerCSV.end.rawValue]
          trainer.trainerClass = tClasses.filter({$0.name == values[ExternalTrainerCSV.category.rawValue]}).first
          trainer.sex = values[ExternalTrainerCSV.sex.rawValue]
          //print("Boo")
          //try trainer.managedObjectContext?.save()
        } else {
          print("Could not find trainer named \(values[ExternalTrainerCSV.name.rawValue]).")
        }
      }
    } catch {
      print("Failed to retrieve record: \(error)")
    }
    
    coreDataWrapper.saveContext()
  }
  
  override func configurationItems() -> [Any]! {
    // To add configuration options via table cells at the bottom of the sheet, return an array of SLComposeSheetConfigurationItem here.
    return []
  }
  
}
