//
//  DeliveryScreenVC.swift
//  Yakrm
//
//  Created by Gaurav Parmar on 10/05/20.
//  Copyright © 2020 Krutik V. Poojara. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class DeliveryScreenVC: UIViewController {

    // MARK: - IBOutlets

    @IBOutlet weak var viewPlaceOrder: UIView!
    @IBOutlet weak var viwMyOrder: UIView!

    @IBOutlet weak var viewBorderPlaceOrder: UIView!
    @IBOutlet weak var viewBorderMyOrder: UIView!

    @IBOutlet weak var btnPlaceOrder: UIButton!
    @IBOutlet weak var btnMyOrder: UIButton!

    @IBOutlet weak var containerPlaceOrder: UIView!
    @IBOutlet weak var cntainerMyOrder: UIView!
    
    @IBOutlet weak var btnNotification: MIBadgeButton!
    
    var orderVC: MyOrderVC?
    var app = AppDelegate()

    // MARK: - UIViewControlller Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.containerPlaceOrder.alpha = 1
        self.viewBorderPlaceOrder.alpha = 1
        self.cntainerMyOrder.alpha = 0
        self.viewBorderMyOrder.alpha = 0
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.getNotificationNumber()
    }

    // MARK: - IBAction Method

    @IBAction private func btnPlaceOrderTapped(_ sender: UIButton) {

        UIView.animate(withDuration: 0.5, animations: {
            self.containerPlaceOrder.alpha = 1
            self.viewBorderPlaceOrder.alpha = 1
            self.cntainerMyOrder.alpha = 0
            self.viewBorderMyOrder.alpha = 0
        })

    }

    @IBAction private func btnMyOrderTapped(_ sender: UIButton) {
        UIView.animate(withDuration: 0.5, animations: {
            self.containerPlaceOrder.alpha = 0
            self.viewBorderPlaceOrder.alpha = 0
            self.cntainerMyOrder.alpha = 1
            self.viewBorderMyOrder.alpha = 1
            self.orderVC?.refresh()
        })
    }

    @IBAction func btnMenu(_ sender: UIButton) {
        sideMenuController?.showLeftViewAnimated()
    }
    
    @IBAction func btnNotificationTapped(_ sender: UIButton){
        let mainStoryboard = UIStoryboard.init(name: "Main", bundle: nil)
        let VC = mainStoryboard.instantiateViewController(withIdentifier: "AlarmsView") as! AlarmsView
        self.navigationController?.pushViewController(VC, animated: true)
    }

    private func getNotificationNumber() {

        let headers: HTTPHeaders = ["Authorization": self.app.defaults.value(forKey: "tokan") as! String,
        "Content-Type": "application/json"]

        AppWebservice.shared.request("\(self.app.newBaseURL)users/notification/get_total_today_noti", method: .get, parameters: nil, headers: headers, loader: false) { (status, response, error) in
            if status == 200 {
                self.btnNotification.badgeString = (response?["total_noti"].string ?? "0")
            } else {
               self.btnNotification.badgeString = "0"
            }
        }

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "orderSegue" {
            self.orderVC = segue.destination as! MyOrderVC
            self.orderVC?.refresh()
        }
    }
}
