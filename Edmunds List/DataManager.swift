//
//  DataManager.swift
//  Edmunds List
//
//  Created by Kamal Dandamudi on 6/4/16.
//  Copyright © 2016 Kamal Dandamudi. All rights reserved.
//

import CoreData
import Foundation
import UIKit

class DataManager{
    
    static let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    
    // Function to insert new object into Core Data
    class func insertUser(user:NSDictionary){
        let managedObjectContext = appDelegate.managedObjectContext
        
        let userEntity = NSEntityDescription.insertNewObjectForEntityForName("User", inManagedObjectContext: managedObjectContext)
        
        userEntity.setValue(user.objectForKey("userName") as! String, forKey: "userName")
        userEntity.setValue(user.objectForKey("email") as! String, forKey: "email")
        userEntity.setValue(user.objectForKey("password") as! String, forKey: "password")
        
        do{
            try managedObjectContext.save()
        }
        catch let error as NSError{
            print("Error while saving User: \(error.userInfo)")
        }
        
    }
    
    // Function to check if user with userName already exists
    class func isUserPresentWithUserName(userName:String)->Bool{
        let managedObjectContext = appDelegate.managedObjectContext
        
        let fetchRequest = NSFetchRequest(entityName: "User")
        let predicate = NSPredicate(format: "userName = %@", userName)
        fetchRequest.predicate = predicate
        
        do{
        let results = try managedObjectContext.executeFetchRequest(fetchRequest)
            if results.count > 0{
                return true
            }
            else{
                return false
            }
        }
        catch let error as NSError{
            print("Error while fetching Users : \(error.userInfo)")
            return false
        }
    }
    
    // Function to check if user with email already exists
    class func isUserPresentWithEmail(email:String)->Bool{
        let managedObjectContext = appDelegate.managedObjectContext
        
        let fetchRequest = NSFetchRequest(entityName: "User")
        let predicate = NSPredicate(format: "email = %@", email)
        fetchRequest.predicate = predicate
        
        do{
            let results = try managedObjectContext.executeFetchRequest(fetchRequest)
            if results.count > 0{
                return true
            }
            else{
                return false
            }
        }
        catch let error as NSError{
            print("Error while fetching Users : \(error.userInfo)")
            return false
        }
    }
    
}