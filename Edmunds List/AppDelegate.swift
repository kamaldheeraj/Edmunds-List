//
//  AppDelegate.swift
//  Edmunds List
//
//  Created by Kamal Dandamudi on 6/3/16.
//  Copyright © 2016 Kamal Dandamudi. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        // prefetching car list for dashboard
        fetchCars()
        
        return true
    }
    
    func applicationWillResignActive(application: UIApplication) {
    }
    
    func applicationDidEnterBackground(application: UIApplication) {
    }
    
    func applicationWillEnterForeground(application: UIApplication) {
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
    }
    
    func applicationWillTerminate(application: UIApplication) {
        self.saveContext()
    }
    
    // MARK: - Core Data stack
    
    lazy var applicationDocumentsDirectory: NSURL = {
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls[urls.count-1]
    }()
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        let modelURL = NSBundle.mainBundle().URLForResource("Edmunds_List", withExtension: "momd")!
        return NSManagedObjectModel(contentsOfURL: modelURL)!
    }()
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.URLByAppendingPathComponent("Edmunds_List.sqlite")
        var failureReason = "There was an error creating or loading the application's saved data."
        do {
            try coordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: nil)
        } catch {
            // Report any error we got.
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
            dict[NSLocalizedFailureReasonErrorKey] = failureReason
            
            dict[NSUnderlyingErrorKey] = error as NSError
            let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
            abort()
        }
        
        return coordinator
    }()
    
    lazy var managedObjectContext: NSManagedObjectContext = {
        let coordinator = self.persistentStoreCoordinator
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch {
                let nserror = error as NSError
                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                abort()
            }
        }
    }
    
    private func fetchCars(){
        WebserviceHelper.getCars(){
            success,data,error in
            if success && data != nil{
                do{
                    let json = try NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers)
                    print(json)
                    dispatch_async(dispatch_get_main_queue()){
                        var i = 0
                        guard let makes = json["makes"] as? [NSDictionary] else{
                            return
                        }
                        for make in makes{
                            let makeID = make["id"]
                            let makeName = make["name"]
                            let makeNiceName = make["niceName"]
                            guard let models = make["models"] as? [NSDictionary] else{
                                return
                            }
                            for model in models{
                                let modelID = model["id"]
                                let modelName = model["name"]
                                let modelNiceName = model["niceName"]
                                guard let years = model["years"] as? [NSDictionary] else{
                                    return
                                }
                                let year = years[0]["year"]
                                let modelYearID = years[0]["id"]
                                let carDictionary = NSMutableDictionary()
                                carDictionary["makeID"] = makeID
                                carDictionary["makeName"] = makeName
                                carDictionary["makeNiceName"] = makeNiceName
                                carDictionary["modelID"] = modelID
                                carDictionary["modelName"] = modelName
                                carDictionary["modelNiceName"] = modelNiceName
                                carDictionary["year"] = year
                                carDictionary["modelYearID"] = modelYearID
                                DataManager.upsertCar(carDictionary)
                                i += 1
                                print(i)
                            }
                        }
                    }
                }
                catch let error as NSError{
                    print("Error fetching car data from API \(error.userInfo)")
                }
            }
        }
    }
    
}

