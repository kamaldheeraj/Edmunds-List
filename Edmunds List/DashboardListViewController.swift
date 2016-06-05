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
        self.navigationItem.title = "Dashboard"
        carsTableView.frame = self.view.frame
        carsTableView.frame.size.height = self.view.frame.size.height - 60
        carsTableView.delegate = self
        carsTableView.dataSource = self
        carsTableView.registerClass(CarsListCell.self, forCellReuseIdentifier: "carCell")
        carsTableView.bounces = false
        self.view.addSubview(carsTableView)
        edmundsLogoView.frame.origin.x = 0
        edmundsLogoView.frame.origin.y = carsTableView.bounds.size.height
        edmundsLogoView.frame.size.width = carsTableView.bounds.size.width
        edmundsLogoView.frame.size.height = 60
        edmundsLogoView.backgroundColor = UIColor(red: 191/255, green: 47/255, blue: 55/255, alpha: 1.0)
        edmundsLogoView.contentMode = .Center
        self.view.addSubview(edmundsLogoView)
        edmundsLogoView.image = UIImage(named: "EdmundsAttribution")
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
        cell.mainLabel.text = car.modelName
        cell.subLabel.text = car.makeName
        cell.carImageView.image = UIImage(named: "edmundsCarLogo.jpg")
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
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let offset = scrollView.contentOffset
        let bounds = scrollView.bounds
        let size = scrollView.contentSize
        let y = offset.y + bounds.size.height
        let h = size.height
        if y > h - 150 {
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

}
