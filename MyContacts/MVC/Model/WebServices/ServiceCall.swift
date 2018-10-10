//
//  ServiceCall.swift
//  MyContacts
//
//  Created by RAVI on 09/10/18.
//  Copyright © 2018 Naveen. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import Firebase
import FirebaseStorage

enum URLString : String {
    case countryDetails = "https://restcountries.eu/rest/v1/all"
}

class Connectivity {
    class func isConnectedToInternet() ->Bool {
        return NetworkReachabilityManager()!.isReachable
    }
}

class CountryNameService {
    
    class func getCountryDetails(success: @escaping (_ result:[CName]) -> Void, onError: @escaping (_ error:String) -> Void){
        APIHandler.RequestCall(url: URLString.countryDetails.rawValue, params: [:], method: .get) { (result) in
            do{
                let arr = try JSONDecoder().decode([CName].self, from: result)
                success(arr)
            }catch{
                onError("Failed")
            }
            
        }
        
    }
}


class FirebaseServiceCalls {
    
    class func storeUserInformation(firstName:String,lastName:String,email:String,country:String,phoneNum:String,contactImg:UIImage,success: @escaping (_ success:Bool) -> Void, onError: @escaping (_ error:Bool) -> Void){
        
        let newPostRef = Database.database().reference().child("ContactList").childByAutoId()
        let newPostKey = newPostRef.key
        
        let storageRef = Storage.storage().reference().child("\(newPostKey).png")
        let image = contactImg
        
        if let uploadData = UIImageJPEGRepresentation(image, 0.2) {
            
            storageRef.putData(uploadData, metadata: nil) { (metadata, error) in
                if error != nil {
                    print("error")
                    success(false)
                    onError(true)
                } else {
                    
                }
                storageRef.downloadURL(completion: { (url, error) in
                    if(url != nil){
                        print(url!.absoluteString)
                        let dic = ["firstName":firstName,"lastName":lastName,"email":email,"phoneNum":phoneNum,"imageDownloadURL":"\(url!.absoluteString)","country":country] as [String : Any]
                        newPostRef.setValue(dic)
                        success(true)
                        onError(false)
                    }
                })
            }
        }
        
    }
        
    class func getUserInformation(success: @escaping (_ success:[Person]) -> Void, onError: @escaping (_ error:Bool) -> Void){

        Database.database().reference(withPath: "ContactList").observe(.childAdded) { (snapshot) in
            if !snapshot.exists() { return }
                   // ANLoader.hide()
                    guard let value = snapshot.value else { return }
                    do {
                        
                        let dic = value as! [String:Any]
                        print(dic)
                            let person = Person.init(fName: dic["firstName"] as! String, lName: dic["lastName"] as! String, country: dic["country"] as! String, email: dic["email"] as! String, imageDownloadURL: dic["imageDownloadURL"] as! String, mobNum: dic["phoneNum"] as! String)
                    print(person.fName)
                        success([person])
            }
            
        }
        
    }
    
}

