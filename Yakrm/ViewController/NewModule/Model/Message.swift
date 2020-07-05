//
//  Message.swift
//  Tawseeel
//
//  Created by Gaurav Parmar on 18/02/20.
//  Copyright © 2020 Gaurav Parmar. All rights reserved.
//

import Foundation
import FirebaseDatabase
import SwiftyJSON

class Message {
    
    var date : String?
    var time : String?
    var customerId : String?
    var customerName : String?
    var driverId : String?
    var driverName: String?
    var message : String?
    var orderId : String?
    var userType : String?
    
    
    init() {
    }
    
    init(dictionary: [String: Any]) {
        let json = JSON(dictionary)
        self.date = json["cDate"].string
        self.time = json["cTime"].string
        self.customerId = json["customerId"].string
        self.customerName = json["customerName"].string
        self.driverId = json["driverId"].string
        self.driverName = json["driverName"].string
        self.message = json["message"].string
        self.orderId = json["orderId"].string
        self.userType = json["userType"].string
        
    }
    
    func toDictionary() -> [String: Any]{
        var dict = [String: Any]()
        dict["cDate"] =  self.date
        dict["cTime"] =  self.time
        dict["customerId"] =  self.customerId
        dict["customerName"] =  self.customerName
        dict["driverId"] =  self.driverId
        dict["driverName"] =  self.driverName
        dict["message"] =  self.message
        dict["orderId"] =  self.orderId
        dict["userType"] =  self.userType
        return dict
    }
    
}
