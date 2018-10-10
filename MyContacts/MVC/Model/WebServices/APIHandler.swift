//
//  APIHandler.swift
//  MyContacts
//
//  Created by RAVI on 09/10/18.
//  Copyright © 2018 Naveen. All rights reserved.
//

import Foundation
import Alamofire

class APIHandler{
    class func RequestCall(url:String,params:Parameters,method:HTTPMethod,success:@escaping (_ data : Data)-> Void){
        
        let headers: HTTPHeaders = [:]
        let timeManage = Alamofire.SessionManager.default
        timeManage.session.configuration.timeoutIntervalForRequest = 60
        timeManage.session.configuration.timeoutIntervalForResource = 60
        print(params)
        //print(headers)
        print(url)
        
        timeManage.request(url, method: method, parameters: params , encoding: URLEncoding.default , headers: headers).responseJSON { (response ) in
            
            success(response.data!)
            
        }
    }
}
