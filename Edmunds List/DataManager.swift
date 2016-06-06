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
    
    // Function to insert/update a new car
    class func upsertCar(car:NSDictionary){
        let managedObjectContext = appDelegate.managedObjectContext
        
        let modelID = car["modelID"] as! String
        let modelName = car["modelName"] as! String
        let modelNiceName = car["modelNiceName"] as! String
        let year = car["year"] as! Int
        let modelYearID = car["modelYearID"] as! Int
        let makeName = car["makeName"] as! String
        let makeNiceName = car["makeNiceName"] as! String
        let makeID = car["makeID"] as! Int
        
        let fetchRequest = NSFetchRequest(entityName: "Car")
        let predicate = NSPredicate(format: "modelID = %@ AND modelName = %@ AND modelNiceName = %@ AND year = %d AND modelYearID = %d", modelID, modelName, modelNiceName, year, modelYearID)
        
        fetchRequest.predicate = predicate
        do{
            let results = try managedObjectContext.executeFetchRequest(fetchRequest)
            if results.count > 0{
                let carEntity = results[0] as! Car
                carEntity.modelID = modelID
                carEntity.modelName = modelName
                carEntity.modelNiceName = modelNiceName
                carEntity.modelYearID = modelYearID
                carEntity.year = year
                carEntity.makeID = makeID
                carEntity.makeName = makeName
                carEntity.makeNiceName = makeNiceName
                try managedObjectContext.save()
            }
            else{
                let carEntity = NSEntityDescription.insertNewObjectForEntityForName("Car", inManagedObjectContext: managedObjectContext) as! Car
                carEntity.modelID = modelID
                carEntity.modelName = modelName
                carEntity.modelNiceName = modelNiceName
                carEntity.modelYearID = modelYearID
                carEntity.year = year
                carEntity.makeID = makeID
                carEntity.makeName = makeName
                carEntity.makeNiceName = makeNiceName
                try managedObjectContext.save()
            }
        }
        catch let error as NSError{
            print("Error while inserting car : \(error.userInfo)")
        }
    }
    
    class func fetchCars(fetchOffset:Int,fetchLimit:Int)->(carList:[Car]?,totalCount:Int){
        let managedObjectContext = appDelegate.managedObjectContext
        let fetchRequest = NSFetchRequest(entityName: "Car")
        var error:NSError? = nil
        let totalCount = managedObjectContext.countForFetchRequest(fetchRequest, error: &error)
        fetchRequest.fetchLimit = fetchLimit
        fetchRequest.fetchOffset = fetchOffset
        do{
            guard let results = try managedObjectContext.executeFetchRequest(fetchRequest) as? [Car] else{
                return (nil,0)
            }
            return (results,totalCount)
        }
        catch let error as NSError{
            print("Error while fetching cars : \(error.userInfo)")
            return (nil,0)
        }
    }
    
    class func isLoginValid(userName:String,password:String)->Bool{
        let managedObjectContext = appDelegate.managedObjectContext
        let hashedPassword = password.stringBySHA256()!
        let fetchRequest = NSFetchRequest(entityName: "User")
        let predicate = NSPredicate(format: "userName = %@ AND password = %@", userName, hashedPassword)
        fetchRequest.predicate = predicate
        do{
            guard let results = try managedObjectContext.executeFetchRequest(fetchRequest) as? [User] else{
                return false
            }
            if results.count > 0{
                return true
            }
            return false
        }
        catch{
            return false
        }
    }
    
}