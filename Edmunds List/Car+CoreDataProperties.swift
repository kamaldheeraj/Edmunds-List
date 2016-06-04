//
//  Car+CoreDataProperties.swift
//  Edmunds List
//
//  Created by Kamal Dandamudi on 6/4/16.
//  Copyright © 2016 Kamal Dandamudi. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Car {

    @NSManaged var makeName: String?
    @NSManaged var makeNiceName: String?
    @NSManaged var modelID: String?
    @NSManaged var modelName: String?
    @NSManaged var modelNiceName: String?
    @NSManaged var year: NSNumber?
    @NSManaged var modelYearID: NSNumber?
    @NSManaged var makeID: NSNumber?

}
