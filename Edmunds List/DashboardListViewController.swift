//
//  DashboardListViewController.swift
//  Edmunds List
//
//  Created by Kamal Dandamudi on 6/3/16.
//  Copyright © 2016 Kamal Dandamudi. All rights reserved.
//

import UIKit

class DashboardListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    let carsTableView = UITableView()
    let edmundsLogoView = UIImageView()
    
    var list:[Car]?
    var totalCount = 0
    var currentOffset = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Cars Dashboard"
        let rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "home"), style: .Plain, target: self, action: Selector("homeClicked"))
        self.navigationItem.setRightBarButtonItem(rightBarButtonItem, animated: true)
        carsTableView.frame = self.view.frame
        carsTableView.frame.size.height = self.view.frame.size.height - 60
        carsTableView.delegate = self
        carsTableView.dataSource = self
        carsTableView.registerClass(CarsListCell.self, forCellReuseIdentifier: "carCell")
        carsTableView.bounces = false
        self.view.addSubview(carsTableView)
        edmundsLogoView.frame.origin.x = (carsTableView.bounds.size.width - 300)/2
        edmundsLogoView.frame.origin.y = carsTableView.bounds.size.height - 60
        edmundsLogoView.frame.size.width = 300
        edmundsLogoView.frame.size.height = 60
        edmundsLogoView.backgroundColor = UIColor(red: 191/255, green: 47/255, blue: 55/255, alpha: 1.0)
        edmundsLogoView.contentMode = .Center
        edmundsLogoView.image = UIImage(named: "EdmundsAttribution")
        self.view.addSubview(edmundsLogoView)
        edmundsLogoView.bringSubviewToFront(self.view)
        let fetchCarsResult = DataManager.fetchCars(currentOffset, fetchLimit: 20)
        totalCount = fetchCarsResult.totalCount
        list = fetchCarsResult.carList
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list!.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let car = list![indexPath.row]
        let cell = tableView.dequeueReusableCellWithIdentifier("carCell") as! CarsListCell
        cell.accessoryType = .DisclosureIndicator
        cell.selectionStyle = .None
        cell.mainLabel.text = "\(car.modelName!) \(car.year!)"
        cell.subLabel.text = car.makeName
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
        // URL to get small logo images.
        let urlString = "http://www.carlogos.org/uploads/car-logos/\(makeURLName)-logo-1.jpg"
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)){
            // Calling function to download image in background thread and to cache downloaded image for future use.
            if let image = Utils.fetchImageWithURL(urlString){
                dispatch_async(dispatch_get_main_queue()){
                    cell.carImageView.image = image
                }
            }
            else{
                dispatch_async(dispatch_get_main_queue()){
                    cell.carImageView.image = UIImage(named: "edmundsCarLogo.jpg")
                }
            }
        }
        cell.car = car
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier("detailSegue", sender: tableView.cellForRowAtIndexPath(indexPath))
    }
    
    // Function to check if tableview is scrolled to the bottom - 75 offset and fetch next set of cars, reload tableview and flash scroll indicator
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        let offset = scrollView.contentOffset
        let bounds = scrollView.bounds
        let size = scrollView.contentSize
        let y = offset.y + bounds.size.height
        if y > size.height - 30 {
            if currentOffset < totalCount{
                guard let carsResult = DataManager.fetchCars(currentOffset, fetchLimit: 20).carList else{
                    return
                }
                currentOffset += 20
                list?.appendContentsOf(carsResult)
                self.carsTableView.reloadData()
                self.carsTableView.flashScrollIndicators()
            }
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "detailSegue"{
            let destVC = segue.destinationViewController as! DashboardDetailViewController
            destVC.car = (sender as! CarsListCell).car
        }
    }
    
    func homeClicked(){
        self.performSegueWithIdentifier("homeScreenSegue", sender: self)
    }

}
