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
    
    let list = ["1","2","3","4"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Dashboard"
        carsTableView.frame = self.view.frame
        carsTableView.delegate = self
        carsTableView.dataSource = self
        carsTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "carCell")
        self.view.addSubview(carsTableView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("carCell")!
        cell.textLabel?.text = list[indexPath.row]
        return cell
    }

}
