//
//  OrderDetail.swift
//  Yakrm
//
//  Created by Gaurav Parmar on 16/05/20.
//  Copyright © 2020 Krutik V. Poojara. All rights reserved.
//

import Foundation
import SwiftyJSON

class OrderDetailRootClass: NSObject, NSCoding {

    var createdAt: String!
    var email: String!
    var id: String!
    var isPaymentComplete: String!
    var message: String!
    var name: String!
    var notes: String!
    var notificationToken: String!
    var orderCharge: String!
    var orderDetail: [OrderDetail]!
    var orderImage: String!
    var orderStatus: String!
    var phone: String!
    var price: String!
    var serviceCharge: String!
    var shopAddress: String!
    var shopLatitude: String!
    var shopLongitude: String!
    var status: String!
    var totalPrice: String!
    var transactionId: String!
    var updatedAt: String!
    var userAddress: String!
    var userId: String!
    var userLatitude: String!
    var userLongitude: String!

    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!) {
        if json.isEmpty {
            return
        }
        createdAt = json["created_at"].stringValue
        email = json["email"].stringValue
        id = json["id"].stringValue
        isPaymentComplete = json["is_payment_complete"].stringValue
        message = json["message"].stringValue
        name = json["name"].stringValue
        notes = json["notes"].stringValue
        notificationToken = json["notification_token"].stringValue
        orderCharge = json["order_charge"].stringValue
        orderDetail = [OrderDetail]()
        let orderDetailArray = json["order_detail"].arrayValue
        for orderDetailJson in orderDetailArray {
            let value = OrderDetail(fromJson: orderDetailJson)
            orderDetail.append(value)
        }
        orderImage = json["order_image"].stringValue
        orderStatus = json["order_status"].stringValue
        phone = json["phone"].stringValue
        price = json["price"].stringValue
        serviceCharge = json["service_charge"].stringValue
        shopAddress = json["shop_address"].stringValue
        shopLatitude = json["shop_latitude"].stringValue
        shopLongitude = json["shop_longitude"].stringValue
        status = json["status"].stringValue
        totalPrice = json["total_price"].stringValue
        transactionId = json["transaction_id"].stringValue
        updatedAt = json["updated_at"].stringValue
        userAddress = json["user_address"].stringValue
        userId = json["user_id"].stringValue
        userLatitude = json["user_latitude"].stringValue
        userLongitude = json["user_longitude"].stringValue
    }

    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String: Any] {
        var dictionary = [String: Any]()
        if createdAt != nil {
            dictionary["created_at"] = createdAt
        }
        if email != nil {
            dictionary["email"] = email
        }
        if id != nil {
            dictionary["id"] = id
        }
        if isPaymentComplete != nil {
            dictionary["is_payment_complete"] = isPaymentComplete
        }
        if message != nil {
            dictionary["message"] = message
        }
        if name != nil {
            dictionary["name"] = name
        }
        if notes != nil {
            dictionary["notes"] = notes
        }
        if notificationToken != nil {
            dictionary["notification_token"] = notificationToken
        }
        if orderCharge != nil {
            dictionary["order_charge"] = orderCharge
        }
        if orderDetail != nil {
        var dictionaryElements = [[String: Any]]()
        for orderDetailElement in orderDetail {
            dictionaryElements.append(orderDetailElement.toDictionary())
        }
        dictionary["orderDetail"] = dictionaryElements
        }
        if orderImage != nil {
            dictionary["order_image"] = orderImage
        }
        if orderStatus != nil {
            dictionary["order_status"] = orderStatus
        }
        if phone != nil {
            dictionary["phone"] = phone
        }
        if price != nil {
            dictionary["price"] = price
        }
        if serviceCharge != nil {
            dictionary["service_charge"] = serviceCharge
        }
        if shopAddress != nil {
            dictionary["shop_address"] = shopAddress
        }
        if shopLatitude != nil {
            dictionary["shop_latitude"] = shopLatitude
        }
        if shopLongitude != nil {
            dictionary["shop_longitude"] = shopLongitude
        }
        if status != nil {
            dictionary["status"] = status
        }
        if totalPrice != nil {
            dictionary["total_price"] = totalPrice
        }
        if transactionId != nil {
            dictionary["transaction_id"] = transactionId
        }
        if updatedAt != nil {
            dictionary["updated_at"] = updatedAt
        }
        if userAddress != nil {
            dictionary["user_address"] = userAddress
        }
        if userId != nil {
            dictionary["user_id"] = userId
        }
        if userLatitude != nil {
            dictionary["user_latitude"] = userLatitude
        }
        if userLongitude != nil {
            dictionary["user_longitude"] = userLongitude
        }
        return dictionary
    }

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder) {
        createdAt = aDecoder.decodeObject(forKey: "created_at") as? String
        email = aDecoder.decodeObject(forKey: "email") as? String
        id = aDecoder.decodeObject(forKey: "id") as? String
        isPaymentComplete = aDecoder.decodeObject(forKey: "is_payment_complete") as? String
        message = aDecoder.decodeObject(forKey: "message") as? String
        name = aDecoder.decodeObject(forKey: "name") as? String
        notes = aDecoder.decodeObject(forKey: "notes") as? String
        notificationToken = aDecoder.decodeObject(forKey: "notification_token") as? String
        orderCharge = aDecoder.decodeObject(forKey: "order_charge") as? String
        orderDetail = aDecoder.decodeObject(forKey: "order_detail") as? [OrderDetail]
        orderImage = aDecoder.decodeObject(forKey: "order_image") as? String
        orderStatus = aDecoder.decodeObject(forKey: "order_status") as? String
        phone = aDecoder.decodeObject(forKey: "phone") as? String
        price = aDecoder.decodeObject(forKey: "price") as? String
        serviceCharge = aDecoder.decodeObject(forKey: "service_charge") as? String
        shopAddress = aDecoder.decodeObject(forKey: "shop_address") as? String
        shopLatitude = aDecoder.decodeObject(forKey: "shop_latitude") as? String
        shopLongitude = aDecoder.decodeObject(forKey: "shop_longitude") as? String
        status = aDecoder.decodeObject(forKey: "status") as? String
        totalPrice = aDecoder.decodeObject(forKey: "total_price") as? String
        transactionId = aDecoder.decodeObject(forKey: "transaction_id") as? String
        updatedAt = aDecoder.decodeObject(forKey: "updated_at") as? String
        userAddress = aDecoder.decodeObject(forKey: "user_address") as? String
        userId = aDecoder.decodeObject(forKey: "user_id") as? String
        userLatitude = aDecoder.decodeObject(forKey: "user_latitude") as? String
        userLongitude = aDecoder.decodeObject(forKey: "user_longitude") as? String
    }

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    func encode(with aCoder: NSCoder) {
        if createdAt != nil {
            aCoder.encode(createdAt, forKey: "created_at")
        }
        if email != nil {
            aCoder.encode(email, forKey: "email")
        }
        if id != nil {
            aCoder.encode(id, forKey: "id")
        }
        if isPaymentComplete != nil {
            aCoder.encode(isPaymentComplete, forKey: "is_payment_complete")
        }
        if message != nil {
            aCoder.encode(message, forKey: "message")
        }
        if name != nil {
            aCoder.encode(name, forKey: "name")
        }
        if notes != nil {
            aCoder.encode(notes, forKey: "notes")
        }
        if notificationToken != nil {
            aCoder.encode(notificationToken, forKey: "notification_token")
        }
        if orderCharge != nil {
            aCoder.encode(orderCharge, forKey: "order_charge")
        }
        if orderDetail != nil {
            aCoder.encode(orderDetail, forKey: "order_detail")
        }
        if orderImage != nil {
            aCoder.encode(orderImage, forKey: "order_image")
        }
        if orderStatus != nil {
            aCoder.encode(orderStatus, forKey: "order_status")
        }
        if phone != nil {
            aCoder.encode(phone, forKey: "phone")
        }
        if price != nil {
            aCoder.encode(price, forKey: "price")
        }
        if serviceCharge != nil {
            aCoder.encode(serviceCharge, forKey: "service_charge")
        }
        if shopAddress != nil {
            aCoder.encode(shopAddress, forKey: "shop_address")
        }
        if shopLatitude != nil {
            aCoder.encode(shopLatitude, forKey: "shop_latitude")
        }
        if shopLongitude != nil {
            aCoder.encode(shopLongitude, forKey: "shop_longitude")
        }
        if status != nil {
            aCoder.encode(status, forKey: "status")
        }
        if totalPrice != nil {
            aCoder.encode(totalPrice, forKey: "total_price")
        }
        if transactionId != nil {
            aCoder.encode(transactionId, forKey: "transaction_id")
        }
        if updatedAt != nil {
            aCoder.encode(updatedAt, forKey: "updated_at")
        }
        if userAddress != nil {
            aCoder.encode(userAddress, forKey: "user_address")
        }
        if userId != nil {
            aCoder.encode(userId, forKey: "user_id")
        }
        if userLatitude != nil {
            aCoder.encode(userLatitude, forKey: "user_latitude")
        }
        if userLongitude != nil {
            aCoder.encode(userLongitude, forKey: "user_longitude")
        }

    }

}
class OrderDetail: NSObject, NSCoding {

    var createdAt: String!
    var id: String!
    var orderId: String!
    var productTitle: String!
    var quantity: String!
    var updatedAt: String!
    var userId: String!

    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!) {
        if json.isEmpty {
            return
        }
        createdAt = json["created_at"].stringValue
        id = json["id"].stringValue
        orderId = json["order_id"].stringValue
        productTitle = json["product_title"].stringValue
        quantity = json["quantity"].stringValue
        updatedAt = json["updated_at"].stringValue
        userId = json["user_id"].stringValue
    }

    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String: Any] {
        var dictionary = [String: Any]()
        if createdAt != nil {
            dictionary["created_at"] = createdAt
        }
        if id != nil {
            dictionary["id"] = id
        }
        if orderId != nil {
            dictionary["order_id"] = orderId
        }
        if productTitle != nil {
            dictionary["product_title"] = productTitle
        }
        if quantity != nil {
            dictionary["quantity"] = quantity
        }
        if updatedAt != nil {
            dictionary["updated_at"] = updatedAt
        }
        if userId != nil {
            dictionary["user_id"] = userId
        }
        return dictionary
    }

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder) {
        createdAt = aDecoder.decodeObject(forKey: "created_at") as? String
        id = aDecoder.decodeObject(forKey: "id") as? String
        orderId = aDecoder.decodeObject(forKey: "order_id") as? String
        productTitle = aDecoder.decodeObject(forKey: "product_title") as? String
        quantity = aDecoder.decodeObject(forKey: "quantity") as? String
        updatedAt = aDecoder.decodeObject(forKey: "updated_at") as? String
        userId = aDecoder.decodeObject(forKey: "user_id") as? String
    }

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    func encode(with aCoder: NSCoder) {
        if createdAt != nil {
            aCoder.encode(createdAt, forKey: "created_at")
        }
        if id != nil {
            aCoder.encode(id, forKey: "id")
        }
        if orderId != nil {
            aCoder.encode(orderId, forKey: "order_id")
        }
        if productTitle != nil {
            aCoder.encode(productTitle, forKey: "product_title")
        }
        if quantity != nil {
            aCoder.encode(quantity, forKey: "quantity")
        }
        if updatedAt != nil {
            aCoder.encode(updatedAt, forKey: "updated_at")
        }
        if userId != nil {
            aCoder.encode(userId, forKey: "user_id")
        }

    }

}
