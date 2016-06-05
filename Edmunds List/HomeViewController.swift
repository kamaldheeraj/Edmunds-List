//
//  HomeViewController.swift
//  Edmunds List
//
//  Created by Kamal Dandamudi on 6/3/16.
//  Copyright © 2016 Kamal Dandamudi. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet var userNameTextField: UITextField!
    
    
    @IBOutlet var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


    @IBAction func login(sender: AnyObject) {
        performSegueWithIdentifier("loginSegue", sender: self)
    }
    
    
    @IBAction func cancelRegistration(segue:UIStoryboardSegue){
        
    }
    
}

