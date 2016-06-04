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
    
    var list:[Car]?
    var totalCount = 0
    var currentOffset = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Dashboard"
        carsTableView.frame = self.view.frame
        carsTableView.delegate = self
        carsTableView.dataSource = self
        carsTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "carCell")
        self.view.addSubview(carsTableView)
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
        let cell = tableView.dequeueReusableCellWithIdentifier("carCell")!
        cell.textLabel?.text = list![indexPath.row].modelName
        return cell
    }
    
    // Function to check if tableview is scrolled to the bottom - 30 offset and fetch next set of cars and reload tableview
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let offset = scrollView.contentOffset
        let bounds = scrollView.bounds
        let size = scrollView.contentSize
        let inset = scrollView.contentInset
        let y = offset.y + bounds.size.height - inset.bottom
        let h = size.height
        if y > h - 30 {
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

}
