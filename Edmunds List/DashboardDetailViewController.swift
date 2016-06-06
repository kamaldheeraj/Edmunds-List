//
//  DashboardDetailViewController.swift
//  Edmunds List
//
//  Created by Kamal Dandamudi on 6/5/16.
//  Copyright © 2016 Kamal Dandamudi. All rights reserved.
//

import UIKit

class DashboardDetailViewController: UIViewController {
    
    var car:Car!
    
    @IBOutlet var carDetailImageView: UIImageView!
    
    @IBOutlet var makeLabel: UILabel!
    
    @IBOutlet var modelLabel: UILabel!
    
    @IBOutlet var yearLabel: UILabel!
    
    @IBOutlet var horsePowerLabel: UILabel!
    
    @IBOutlet var torqueLabel: UILabel!
    
    @IBOutlet var cylindersLabel: UILabel!
    
    @IBOutlet var doorsLabel: UILabel!
    
    @IBOutlet var driveLabel: UILabel!
    
    @IBOutlet var transmissionTypeLabel: UILabel!
    
    @IBOutlet var mpgLabel: UILabel!
    
    @IBOutlet var msrpLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        makeLabel.text = "Make: \(car.makeName!)"
        modelLabel.text = car.modelName
        yearLabel.text = "Year: \(String(car.year!))"
        fetchCarDetails()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func fetchCarDetails(){
        var makeURLName = ""
        if car.makeName! == "MINI"{
            // To handle different in naming convention between logo website and edmunds
            makeURLName = "Mini"
        }
        else if car.makeName! == "FIAT"{
            // To handle different in naming convention between logo website and edmunds
            makeURLName = "Fiat"
        }
        else if car.makeName!.uppercaseString == car.makeName! {
            //To handle car names that are acnonyms like GMC,BMW etc
            makeURLName = car.makeName!.uppercaseString
        }
        else if car.makeName! == "McLaren"{
            // To handle different in naming convention between logo website and edmunds
            makeURLName = "McLaren"
        }
        else if car.makeName! == "Lincoln"{
            // To handle different in naming convention between logo website and edmunds
            makeURLName = "Lincoln-Motor"
        }
        else{
            makeURLName = car.makeName!.capitalizedString.stringByReplacingOccurrencesOfString(" ", withString: "-")
        }
        // URL to get larger logo images.
        let urlString = "http://www.carlogos.org/uploads/car-logos/\(makeURLName)-logo-2.jpg"
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)){
            // Calling function to download image in background thread and to cache downloaded image for future use.
            if let image = Utils.fetchImageWithURL(urlString){
                dispatch_async(dispatch_get_main_queue()){
                    self.carDetailImageView.image = image
                }
            }
            else{
                dispatch_async(dispatch_get_main_queue()){
                    self.carDetailImageView.image = UIImage(named: "edmunds250.jpeg")
                }
            }
        }
        WebserviceHelper.getCarDetails(car.makeNiceName!, modelNiceName: car.modelNiceName!, year: car.year!){
            success,data,error in
            if success && data != nil && error == nil{
                dispatch_async(dispatch_get_main_queue()){
                    do{
                        let json = try NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers)
                        guard let styles = json["styles"] as? [NSDictionary] else{
                            return
                        }
                        if styles.count > 0{
                            let style = styles[0]
                            guard let engine = style["engine"] as? NSDictionary else{
                                return
                            }
                            if let torque = engine["torque"] as? NSNumber{
                                self.torqueLabel.text = "Torque: \(torque)"
                            }
                            if let horsePower = engine["horsepower"] as? NSNumber{
                                self.horsePowerLabel.text = "HorsePower: \(horsePower)"
                            }
                            if let cylinders = engine["cylinder"] as? NSNumber{
                                self.cylindersLabel.text = "Cylinders: \(cylinders)"
                            }
                            if let transmission = style["transmission"] as? NSDictionary {
                                if let transmissionType = transmission["transmissionType"] as? String{
                                    self.transmissionTypeLabel.text = transmissionType.capitalizedString
                                }
                            }
                            if let price = style["price"] as? NSDictionary{
                                if let baseMSRP = price["baseMSRP"] as? NSNumber{
                                    self.msrpLabel.text = "MSRP: $ \(baseMSRP)"
                                }
                                else{
                                    self.msrpLabel.text = ""
                                }
                            }
                            else{
                                self.msrpLabel.text = ""
                            }
                            if let doors = style["numOfDoors"] as? String{
                                self.doorsLabel.text = "Doors: \(doors)"
                            }
                            if let drive = style["drivenWheels"] as? String{
                                self.driveLabel.text = "\(drive)".capitalizedString
                            }
                            if let mpg = style["MPG"] as? NSDictionary{
                                if let highway = mpg["highway"] as? String, let city = mpg["city"] as? String{
                                    self.mpgLabel.text = "MPG: \(highway)/\(city)"
                                }
                                else{
                                    self.mpgLabel.text = ""
                                }
                            }
                            else{
                                self.mpgLabel.text = ""
                            }
                        }
                    }
                    catch{
                        print("Error while serializing Car Details data to JSON")
                    }
                }
            }
        }
    }
    
}
