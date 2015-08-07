//
//  CoreDataStackManager.swift
//  MemeMe
//
//  Created by Brian Josel on 7/30/15.
//  Copyright (c) 2015 Brian Josel. All rights reserved.
//

import Foundation
import CoreData

//sqlite filename
private let SQLITE_FILE_NAME = "memes.sqlite"

//class for dealing and managing Core Data
class CoreDataStackManager {
    
    class func sharedInstance() -> CoreDataStackManager {
        struct Static {
            static let instance = CoreDataStackManager()
        }
        return Static.instance
    }
    
    //documents directory
    lazy var applicationDocumentsDirectory : NSURL = {
        let urls = NSFileManager.defaultManager().URLsForDirectory(NSSearchPathDirectory.DocumentDirectory, inDomains: NSSearchPathDomainMask.UserDomainMask)
        return urls[urls.count - 1] as! NSURL
        }()
    
    //managed object model
    lazy var managedObjectModel : NSManagedObjectModel = {
        let url = NSBundle.mainBundle().URLForResource("MemeModel", withExtension: ".momd")!
        return NSManagedObjectModel(contentsOfURL: url)!
        }()
    
    //persistence store coordinator
    lazy var persistenceStoreCoordinator : NSPersistentStoreCoordinator? = {
        //coordinator to return, based off managed object model
        var coordinator : NSPersistentStoreCoordinator? = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.URLByAppendingPathComponent(SQLITE_FILE_NAME)
        
        //create error
        var error: NSError? = nil
        
        //check addition of persistent store is possible, if not, set coordinator to nil and report error
        if coordinator?.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: nil, error: &error) == nil {
            //could not add persistent store
            
            //set coordinator to nil
            coordinator = nil
            
            var errorDict = NSMutableDictionary()
            errorDict[NSLocalizedDescriptionKey] = "Failed to initialize application's saved data"
            errorDict[NSLocalizedFailureReasonErrorKey] = "There was an error creating or loading the application's saved data"
            errorDict[NSUnderlyingErrorKey] = error
            error = NSError(domain: "persistenceStoreCoordinator", code: 9999, userInfo: errorDict as [NSObject : AnyObject])
            
            //report error
            NSLog("Unresolved error \(error), \(error!.userInfo!)")
//            abort()
            
        }
        
        return coordinator
        }()
    
    lazy var managedObjectContext : NSManagedObjectContext? = {
        //managedObjectContext to be returned
        var context = NSManagedObjectContext()
        
        //get persistenceStoreCoordinator
        let coordinator = self.persistenceStoreCoordinator
        
        //if coordinator is nil, return nil
        if coordinator == nil {
            return nil
        }
        
        //add persistenceStoreCoordinator
        context.persistentStoreCoordinator = coordinator
        
        //return
        return context
        
        }()
    
    //save latest context
    func saveContext() {
        println("saving context")
        
        //get managedObjectContext if it exists
        if let context = self.managedObjectContext {
            
            //create error in case saving fails
            var error : NSError? = nil
            
            //if context has changes and fails to save, report error
            if context.hasChanges && !context.save(&error) {
                NSLog("Unresolved error \(error), \(error?.userInfo)")
                abort()
            } //else implies successful save
            println("successfully saved context")
        } else {
            NSLog("No managedObjectContext")
            abort()
        }
    }
    
}