//
//  Validations.swift
//  MyContacts
//
//  Created by RAVI on 09/10/18.
//  Copyright © 2018 Naveen. All rights reserved.
//

import Foundation
import UIKit

class Validations{
    
    class func nameValidations(textField:UITextField) -> String{
        
        if textField.text == nil || (textField.text == ""){
            
            return Name
        }else{
            if !SubValidation.isNameValid(name: textField.text!){
                return name
            }
        }
        return "true"
    }
    
    class func phoneNumValidation(textField:UITextField) -> String{
        
        if textField.text == nil || (textField.text == ""){
            return PhoneNo
        }else{
            if !SubValidation.isMobileNumberValid(Mobile: textField.text!){
                return ValidPhoneNo
                
            }
        }
        return "true"
    }
    
    class func emailValidation(textField:UITextField) -> String {
        
        if textField.text == nil || (textField.text == ""){
            return Email
        }else {
            if !SubValidation.isValidEmail(email: textField.text!){
                return EmailValidation
            }
        }
        return "true"
    }
    
    class func imageValidation(image:UIImageView) -> String {
        let imageCompare = UIImage.init(named: "addPhot")
        if image == nil || image.image == imageCompare!{
            return imageError
        }
        
        return "true"
    }
    
}
class SubValidation: NSObject {
    
    static func isValidEmail(email:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: email)
    }
    
    static func isPasswordValid(password : String) -> Bool{
        
        if (password.count >= 4) && (password.count <= 20){
            return true;}
        
        
        return false;
    }
    
    
    static func isNameValid(name : String) -> Bool{
        
        if (name.count >= 2) && (name.count <= 50){
            return true;}
        
        
        return false;
    }
    static func isMobileNumberValid(Mobile : String) -> Bool{
        
        if Mobile.count == 10{
            return true;
        }
        
        return false;
    }
}

//Constants

let name = "Name must be 2 - 50 characters"
let Email = "Please enter Email"
let EmailValidation = "Please use Email format (example - abc@abc.com)"
let PhoneNo = "Please enter Mobile Number"
let ValidPhoneNo = "Please enter Valid Phone Number"
let Name = "Please enter First Name"
let LastName = "Please enter Last Name or must be 2-50 characters"
let Error = "Error"
let imageError = "Please Select An Image"
