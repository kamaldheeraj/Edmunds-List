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
    
    @IBOutlet var backgroundImageView: UIImageView!
    
    @IBOutlet var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


    @IBAction func login(sender: AnyObject) {
        if validLogin(){
            performSegueWithIdentifier("loginSegue", sender: self)
        }
    }
    
    
    @IBAction func cancelRegistration(segue:UIStoryboardSegue){
        
    }
    
    private func validLogin()->Bool{
        if userNameTextField.text == "" || userNameTextField.text == nil{
            let alertController = UIAlertController(title: "Login Failed!", message: "User Name missing! Please enter a User Name.", preferredStyle: .Alert)
            let okAction = UIAlertAction(title: "OK", style: .Default){
                _ in
                return false
            }
            alertController.addAction(okAction)
            self.presentViewController(alertController, animated: true, completion: nil)
        }
        if passwordTextField.text == "" || passwordTextField.text == nil{
            let alertController = UIAlertController(title: "Login Failed!", message: "Password missing! Please enter a Password.", preferredStyle: .Alert)
            let okAction = UIAlertAction(title: "OK", style: .Default){
                _ in
                return false
            }
            alertController.addAction(okAction)
            self.presentViewController(alertController, animated: true, completion: nil)
        }
        if !DataManager.isLoginValid(userNameTextField.text!, password: passwordTextField.text!){
            let alertController = UIAlertController(title: "Login Failed!", message: "Invalid login credentials! Please try again.", preferredStyle: .Alert)
            let okAction = UIAlertAction(title: "OK", style: .Default){
                _ in
                return false
            }
            alertController.addAction(okAction)
            self.presentViewController(alertController, animated: true, completion: nil)
        }
        return true
    }
    
}

