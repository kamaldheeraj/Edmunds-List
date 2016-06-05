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
        WebserviceHelper.getCarDetails(car.makeNiceName!, modelNiceName: car.modelNiceName!, year: car.year!){
            success,data,error in
            if success && data != nil && error == nil{
                dispatch_async(dispatch_get_main_queue()){
                    do{
                        let json = try NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers)
                        guard let styles = json["styles"] as? [NSDictionary] else{
                            return
                        }
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
