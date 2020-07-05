//
//  AppFirebase.swift
//  Tawseeel
//
//  Created by Gaurav Parmar on 15/02/20.
//  Copyright © 2020 Gaurav Parmar. All rights reserved.
//

import Foundation
import FirebaseDatabase

class AppFirebase {
    
    var ref: DatabaseReference!
    
    static let shared = AppFirebase()
    
    private init(){
        self.ref = Database.database().reference()
    }
    
//    func fetchDriver(completionHandler: @escaping ([Driver]) -> Void){
//        var driver : [Driver] = [Driver]()
//        ref.child("Drivers").observe(.value, with: { (snapshot) in
//            if snapshot.exists() {
//                guard let children = snapshot.children.allObjects as? [DataSnapshot] else { return }
//                for child in children {
//                    guard let dictionary = child.value as? [String: Any] else { return }
//                    driver.append(Driver.init(dictionary: dictionary))
//                }
//                completionHandler(driver)
//            }
//        })
//    }
    
    func messages(for conversation: String, _ completion: @escaping ([Message]) -> Void) {
        var message : [Message] = [Message]()
        Database.database().reference().child("OrdersChat").child(conversation).observe(.value, with: { (snapshot) in
            if snapshot.exists() {
                guard let children = snapshot.children.allObjects as? [DataSnapshot] else { return }
                for child in children {
                    guard let dictionary = child.value as? [String: Any] else { return }
                    message.append(Message.init(dictionary: dictionary))
                }
                completion(message)
            }
        })
    }
}
