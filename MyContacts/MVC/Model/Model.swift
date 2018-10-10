//
//  Model.swift
//  MyContacts
//
//  Created by Laxmikanth Reddy on 07/10/18.
//  Copyright © 2018 Naveen. All rights reserved.
//

import Foundation
import Alamofire
import Firebase
import FirebaseStorage

//For Country Details
struct CName: Decodable {
   
    let name:String
    let callingCodes : [String]
}



//For Contact Details
struct AllPerson: Decodable {
    let personArr : [Person]
}
   
struct Person: Decodable {
    let fName: String
    let lName: String
    let country: String
    let email: String
    let imageDownloadURL: String
    let mobNum: String
}
