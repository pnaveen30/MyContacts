//
//  CustomTextField.swift
//  MyContacts
//
//  Created by Laxmikanth Reddy on 10/10/18.
//  Copyright © 2018 Naveen. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
class CustomTextField: UITextField{
    
    @IBInspectable var setBottomBorder : Bool = false{
        didSet{
        if(setBottomBorder == true){
            self.borderStyle = .none
            self.layer.backgroundColor = UIColor.white.cgColor
            
            self.layer.masksToBounds = false
            self.layer.shadowColor = UIColor.gray.cgColor
            self.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
            self.layer.shadowOpacity = 1.0
            self.layer.shadowRadius = 0.0
            }
            
        }
    }
    

}

