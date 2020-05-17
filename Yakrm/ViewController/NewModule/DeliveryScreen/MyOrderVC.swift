//
//  MyOrderVC.swift
//  Yakrm
//
//  Created by Gaurav Parmar on 10/05/20.
//  Copyright © 2020 Krutik V. Poojara. All rights reserved.
//

import UIKit
import Alamofire
import Toaster
import SwiftyJSON

class MyOrderVC: UIViewController {

    // MARK: - IBOutlet
    @IBOutlet weak var tblOrders : UITableView!
    
    var orders : [Order] = [Order]()
    var app = AppDelegate()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getOrders()
    }
    
    private func getOrders() {
        
        
        let headers: HTTPHeaders = ["Authorization": self.app.defaults.value(forKey: "tokan") as! String,
        "Content-Type": "application/json"]
        
        AppWebservice.shared.request("\(self.app.newBaseURL)users/orders/my_orders", method: .get, parameters: nil, headers: headers, loader: true) { (status, response, error) in
            if status == 200 {
                for obj in response?["data"].array ?? [] {
                    self.orders.append(Order(obj))
                }
                self.tblOrders.reloadData()
            }else {
                Toast(text: error?.localizedDescription).show()
            }
        }
        
    }
    
    func refresh(){
        self.getOrders()
    }
}

extension MyOrderVC : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.orders.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "OrderCell", for: indexPath) as? OrderCell else { return UITableViewCell() }
        cell.setData(self.orders[indexPath.row])
        cell.viewDetailTapped = {
            let storyboard = UIStoryboard.init(name: "DeliveryModule", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "DeliveryDetailVC") as! DeliveryDetailVC
            vc.orderId = self.orders[indexPath.row].orderId ?? ""
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        return cell
    }
    
}
extension MyOrderVC : UITableViewDelegate {
    
}
