//
//  RegistrationViewController.swift
//  Edmunds List
//
//  Created by Kamal Dandamudi on 6/3/16.
//  Copyright © 2016 Kamal Dandamudi. All rights reserved.
//

import UIKit

class RegistrationViewController: UIViewController,UITextFieldDelegate {
    
    @IBOutlet var emailTextField: UITextField!
    
    @IBOutlet var userNameTextField: UITextField!
    
    @IBOutlet var passwordTextField: UITextField!
    
    @IBOutlet var specialCharacterRequirementLabel: UILabel!
    
    @IBOutlet var numberRequirementLabel: UILabel!
    
    @IBOutlet var eightCharactersRequirementLabel: UILabel!
    
    @IBOutlet var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.delegate = self
        userNameTextField.delegate = self
        passwordTextField.delegate = self
        passwordTextField.addTarget(self, action: #selector(textFieldDidChange), forControlEvents: .EditingChanged)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func registerAction(sender: AnyObject) {
        //Validate Field Data
        if areFieldsValid(){
            self.performSegueWithIdentifier("registrationDashboardSegue", sender: self)
        }
        return
    }
    
    
    //Text Field Delegate
    
    func textFieldDidChange(textField:UITextField) {
        if textField == passwordTextField{
            if let string = textField.text{
                if string.rangeOfCharacterFromSet(NSCharacterSet.alphanumericCharacterSet().invertedSet) != nil{
                    specialCharacterRequirementLabel.backgroundColor = UIColor.greenColor()
                }
                else{
                    specialCharacterRequirementLabel.backgroundColor = UIColor.lightGrayColor()
                }
                if string.rangeOfCharacterFromSet(NSCharacterSet.decimalDigitCharacterSet()) != nil{
                    numberRequirementLabel.backgroundColor = UIColor.greenColor()
                }
                else{
                    numberRequirementLabel.backgroundColor = UIColor.lightGrayColor()
                }
                if string.characters.count > 8{
                    eightCharactersRequirementLabel.backgroundColor = UIColor.greenColor()
                }
                else{
                    eightCharactersRequirementLabel.backgroundColor = UIColor.lightGrayColor()
                }
            }
        }
    }
    
    
    private func areFieldsValid()->Bool{
        //Check if email is empty
        if emailTextField.text == nil || emailTextField.text == ""{
            emailTextField.layer.borderWidth = 1
            emailTextField.layer.borderColor = UIColor.redColor().CGColor
            errorLabel.text = "Email cannot be blank."
            return false
        }
        else{
            if !isStringValidEmail(emailTextField.text!){
                return false
            }
        }
        
        //Check if username is empty
        if userNameTextField.text == nil || userNameTextField.text == ""{
            userNameTextField.layer.borderWidth = 1
            userNameTextField.layer.borderColor = UIColor.redColor().CGColor
            errorLabel.text = "User cannot be blank."
            return false
        }
        else{
            if !isStringValidUser(userNameTextField.text!){
                return false
            }
        }
        
        //Check if password is empty
        if passwordTextField.text == nil || passwordTextField.text == ""{
            passwordTextField.layer.borderWidth = 1
            passwordTextField.layer.borderColor = UIColor.redColor().CGColor
            errorLabel.text = "Password cannot be blank."
            return false
        }
        else{
            if !isStringValidPassword(passwordTextField.text!){
                return false
            }
        }
        return true
    }
    
    
    // Function to check for password validity
    private func isStringValidPassword(password:String)->Bool{
        //Check for password length
        if password.characters.count < 8{
            errorLabel.text = "Passwords must be at least eight characters long"
            return false
        }
        do{
            //Check for special character regular expression
            let specialCharRegEx = try NSRegularExpression(pattern: "[^a-z0-9]", options: .CaseInsensitive)
            if specialCharRegEx.firstMatchInString(password, options: NSMatchingOptions(), range: NSMakeRange(0, password.characters.count)) == nil{
                errorLabel.text = "Password should contain at least 1 special character"
                passwordTextField.layer.borderWidth = 1
                passwordTextField.layer.borderColor = UIColor.redColor().CGColor
                return false
            }
            
            //Check for number regular expression
            let numericalRegEx = try NSRegularExpression(pattern: "[0-9]", options: NSRegularExpressionOptions())
            if numericalRegEx.firstMatchInString(password, options: NSMatchingOptions(), range: NSMakeRange(0, password.characters.count)) == nil{
                errorLabel.text = "Password should contain at least 1 number"
                passwordTextField.layer.borderWidth = 1
                passwordTextField.layer.borderColor = UIColor.redColor().CGColor
                return false
            }
            passwordTextField.layer.borderWidth = 0
            passwordTextField.layer.borderColor = UIColor.lightGrayColor().CGColor
            errorLabel.text = ""
            return true
        }
        catch{
            errorLabel.text = "Error while creating regular expression. Please try again!"
            passwordTextField.layer.borderWidth = 1
            passwordTextField.layer.borderColor = UIColor.redColor().CGColor
            return false
        }
    }
    
    // Function to check for password validity
    private func isStringValidUser(userName:String)->Bool{
        do{
            //Check for special character regular expression
            let specialCharRegEx = try NSRegularExpression(pattern: "[0-9]", options: .CaseInsensitive)
            if specialCharRegEx.firstMatchInString(userName, options: NSMatchingOptions(), range: NSMakeRange(0, userName.characters.count)) != nil{
                errorLabel.text = "User Name should not contain any numbers"
                userNameTextField.layer.borderWidth = 1
                userNameTextField.layer.borderColor = UIColor.redColor().CGColor
                return false
            }
            userNameTextField.layer.borderWidth = 0
            userNameTextField.layer.borderColor = UIColor.lightGrayColor().CGColor
            errorLabel.text = ""
            return true
        }
        catch{
            errorLabel.text = "Error while creating regular expression. Please try again!"
            userNameTextField.layer.borderWidth = 1
            userNameTextField.layer.borderColor = UIColor.redColor().CGColor
            return false
        }
    }
    
    // Function to check for password validity
    private func isStringValidEmail(email:String)->Bool{
        do{
            //Check for special character regular expression
            let specialCharRegEx = try NSRegularExpression(pattern: "[0-9a-z._%+-]+@[a-z0-9.-]+\\.[a-z]{2,64}", options: .CaseInsensitive)
            if specialCharRegEx.firstMatchInString(email, options: NSMatchingOptions(), range: NSMakeRange(0, email.characters.count)) == nil{
                errorLabel.text = "Invalid Email format"
                emailTextField.layer.borderWidth = 1
                emailTextField.layer.borderColor = UIColor.redColor().CGColor
                return false
            }
            emailTextField.layer.borderWidth = 0
            emailTextField.layer.borderColor = UIColor.lightGrayColor().CGColor
            errorLabel.text = ""
            return true
        }
        catch{
            errorLabel.text = "Error while creating regular expression. Please try again!"
            emailTextField.layer.borderWidth = 1
            emailTextField.layer.borderColor = UIColor.redColor().CGColor
            return false
        }
    }
    
}
