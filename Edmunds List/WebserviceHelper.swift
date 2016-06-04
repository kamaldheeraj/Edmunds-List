//
//  WebserviceHelper.swift
//  Edmunds List
//
//  Created by Kamal Dandamudi on 6/4/16.
//  Copyright © 2016 Kamal Dandamudi. All rights reserved.
//

import Foundation

class WebserviceHelper{
    
    class func getCars(completionHandler:(succes:Bool,data:NSData?,error:NSError?)->Void){
        guard let url = NSURL(string: "https://api.edmunds.com/api/vehicle/v2/makes?fmt=json&year=2016&api_key=ne855ea3mmmyg44qg364cdvk") else{
            completionHandler(succes: false, data: nil,error: nil)
            return
        }
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "GET"
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request){
            data,response,taskError in
            if taskError != nil || data == nil{
                completionHandler(succes: false, data: data, error: taskError)
                return
            }
            completionHandler(succes: true, data: data, error: taskError)
            return
        }
        task.resume()
    }
    
}