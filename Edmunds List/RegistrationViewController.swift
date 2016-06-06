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
    
    
    @IBOutlet var reenterPasswordTextField: UITextField!
    
    @IBOutlet var specialCharacterRequirementLabel: UILabel!
    
    @IBOutlet var numberRequirementLabel: UILabel!
    
    @IBOutlet var eightCharactersRequirementLabel: UILabel!
    
    @IBOutlet var errorLabel: UILabel!
    
    
    @IBOutlet var specialCharacterImageView: UIImageView!
    
    @IBOutlet var numberImageView: UIImageView!
    
    @IBOutlet var eightCharacterImageView: UIImageView!
    
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
            let user = NSMutableDictionary()
            user["email"] = emailTextField.text!
            user["userName"] = userNameTextField.text!
            user["password"] = passwordTextField.text!.stringBySHA256()!
            DataManager.insertUser(user)
            self.performSegueWithIdentifier("registrationDashboardSegue", sender: self)
        }
        return
    }
    
    
    //MARK:Text Field Delegate
    
    func textFieldDidChange(textField:UITextField) {
        if textField == passwordTextField{
            if let string = textField.text{
                if string.rangeOfCharacterFromSet(NSCharacterSet.alphanumericCharacterSet().invertedSet) != nil{
                    specialCharacterImageView.hidden = false
                }
                else{
                    specialCharacterImageView.hidden = true
                }
                if string.rangeOfCharacterFromSet(NSCharacterSet.decimalDigitCharacterSet()) != nil{
                    numberImageView.hidden = false
                }
                else{
                   numberImageView.hidden = true
                }
                if string.characters.count >= 8{
                    eightCharacterImageView.hidden = false
                }
                else{
                    eightCharacterImageView.hidden = true
                }
            }
        }
    }
    
    // MARK: Private Functions
    private func areFieldsValid()->Bool{
        //Check if email is empty
        if emailTextField.text == nil || emailTextField.text == ""{
            highlightTextField(emailTextField)
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
            highlightTextField(userNameTextField)
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
            highlightTextField(passwordTextField)
            errorLabel.text = "Password cannot be blank."
            return false
        }
        else{
            if !isStringValidPassword(passwordTextField.text!){
                return false
            }
        }
        
        //Check if passwords match
        if reenterPasswordTextField.text != passwordTextField.text{
            highlightTextField(reenterPasswordTextField)
            errorLabel.text = "Passwords do not match."
            return false
        }
        else{
            resetTextField(reenterPasswordTextField)
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
                highlightTextField(passwordTextField)
                return false
            }
            
            //Check for number regular expression
            let numericalRegEx = try NSRegularExpression(pattern: "[0-9]", options: NSRegularExpressionOptions())
            if numericalRegEx.firstMatchInString(password, options: NSMatchingOptions(), range: NSMakeRange(0, password.characters.count)) == nil{
                errorLabel.text = "Password should contain at least 1 number"
                highlightTextField(passwordTextField)
                return false
            }
            resetTextField(passwordTextField)
            errorLabel.text = ""
            return true
        }
        catch{
            errorLabel.text = "Error while creating regular expression. Please try again!"
            highlightTextField(passwordTextField)
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
                highlightTextField(userNameTextField)
                return false
            }
            if DataManager.isUserPresentWithUserName(userName){
                errorLabel.text = "User with user name \"\(userName)\" already exists."
                highlightTextField(userNameTextField)
                return false
            }
            resetTextField(userNameTextField)
            errorLabel.text = ""
            return true
        }
        catch{
            errorLabel.text = "Error while creating regular expression. Please try again!"
            highlightTextField(userNameTextField)
            return false
        }
    }
    
    // Function to check for password validity
    private func isStringValidEmail(email:String)->Bool{
        do{
            //Check for special character regular expression. 
            let specialCharRegEx = try NSRegularExpression(pattern: "[0-9a-z._%+-]+@[a-z0-9.-]+\\.[a-z]{2,64}", options: .CaseInsensitive)
            if specialCharRegEx.firstMatchInString(email, options: NSMatchingOptions(), range: NSMakeRange(0, email.characters.count)) == nil{
                errorLabel.text = "Invalid Email format"
                highlightTextField(emailTextField)
                return false
            }
            if DataManager.isUserPresentWithEmail(email){
                errorLabel.text = "User with email \"\(email)\" already exists."
                highlightTextField(emailTextField)
                return false
            }
            resetTextField(emailTextField)
            errorLabel.text = ""
            return true
        }
        catch{
            errorLabel.text = "Error while creating regular expression. Please try again!"
            highlightTextField(emailTextField)
            return false
        }
    }
    
    private func highlightTextField(textField:UITextField){
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.redColor().CGColor
    }
    
    private func resetTextField(textField:UITextField){
        textField.layer.borderWidth = 0
        textField.layer.borderColor = UIColor.lightGrayColor().CGColor
    }
    
}

//Extension of String to return a hashed value using SHA256 algorithm in CommonCrypto
extension String{
    func stringBySHA256() -> String? {
        guard
            let encodedData = self.dataUsingEncoding(NSUTF8StringEncoding),
            let hashResult = NSMutableData(length: Int(CC_SHA256_DIGEST_LENGTH))
            else { return nil }
        
        CC_SHA256(encodedData.bytes, CC_LONG(encodedData.length), UnsafeMutablePointer(hashResult.mutableBytes))
        let hashedString = hashResult.base64EncodedStringWithOptions([])
        return hashedString
    }
}
