//
//  DeliveryScreenVC.swift
//  Yakrm
//
//  Created by Gaurav Parmar on 10/05/20.
//  Copyright © 2020 Krutik V. Poojara. All rights reserved.
//

import UIKit

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

    // MARK: - UIViewControlller Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.containerPlaceOrder.alpha = 1
        self.viewBorderPlaceOrder.alpha = 1
        self.cntainerMyOrder.alpha = 0
        self.viewBorderMyOrder.alpha = 0
//        self.navigationController?.navigationBar.isHidden = false
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
        })
    }

    @IBAction func btnMenu(_ sender: UIButton) {
        sideMenuController?.showLeftViewAnimated()
    }

}
