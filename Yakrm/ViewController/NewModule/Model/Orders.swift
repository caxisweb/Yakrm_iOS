//
//  Orders.swift
//  Yakrm
//
//  Created by Gaurav Parmar on 16/05/20.
//  Copyright © 2020 Krutik V. Poojara. All rights reserved.
//

import Foundation
import SwiftyJSON

class Order {

//    "product_title" : "عصائر",
//    "total_products" : "1",
//    "email" : "mr.ahmed.amin@hotmail.com",
//    "user_longitude" : "31.886509805918",
//    "id" : "52",
//    "user_address" : "Tell El Kebir, Ismailia Governorate, Egypt",
//    "phone" : "0551432252",
//    "name" : "Ahmed",
//    "user_id" : "114",
//    "order_status" : "1",
//    "user_latitude" : "30.356577759585"

    var productTitle: String?
    var totalProducts: String?
    var email: String?
    var orderId: String?
    var userAddress: String?
    var phone: String?
    var name: String?
    var userId: String?
    var orderStatus: String?
    var userLatitude: String?
    var userLongitude: String?

    var statusString: String {
        switch self.orderStatus {
        case "1":
            return "Pending"
        case "2":
            return "Accept"
        case "4":
            return "Dispatch"
        case "5":
            return "Delivered"
        case "6":
            return "Cancel"
        default :
            return ""
        }
    }

    init(_ data: JSON) {
        self.productTitle = data["product_title"].string
        self.totalProducts = data["total_products"].string
        self.email = data["email"].string
        self.orderId = data["id"].string
        self.userAddress = data["user_address"].string
        self.phone = data["phone"].string
        self.name = data["name"].string
        self.userId = data["user_id"].string
        self.orderStatus = data["order_status"].string
        self.userLatitude = data["user_latitude"].string
    }

}
