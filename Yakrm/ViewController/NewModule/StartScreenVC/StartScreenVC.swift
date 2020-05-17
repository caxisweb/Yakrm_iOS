//
//  StartScreenVC.swift
//  Yakrm
//
//  Created by Gaurav Parmar on 10/05/20.
//  Copyright © 2020 Krutik V. Poojara. All rights reserved.
//

import UIKit

class StartScreenVC: UIViewController {

    // MARK: - IBOutlet
    @IBOutlet weak var deliveryView: UIView!
    @IBOutlet weak var discountView: UIView!

    @IBOutlet weak var btnDiscount: UIButton!
    @IBOutlet weak var btnDelivery: UIButton!

    var app = AppDelegate()

    // MARK: - UIViewController Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        btnDiscount.layer.cornerRadius = btnDiscount.frame.size.height / 2
        btnDiscount.clipsToBounds = true

        btnDelivery.layer.cornerRadius = btnDelivery.frame.size.height / 2
        btnDelivery.clipsToBounds = true

    }

    // MARK: - IBAction Methods
    @IBAction func discountTapped(_ sender: UIButton) {

        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let VC = storyboard.instantiateViewController(withIdentifier: "HomeView") as! HomeView
        self.navigationController?.pushViewController(VC, animated: true)
    }

    @IBAction func deliveryTapped(_ sender: UIButton) {
        if app.defaults.string(forKey: "user_id") != nil {

            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "SidemenuView"), object: nil, userInfo: nil)

            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let navigationController = storyboard.instantiateViewController(withIdentifier: "NavigationController") as! UINavigationController
            let deliveryStoryboard = UIStoryboard.init(name: "DeliveryModule", bundle: nil)
            navigationController.setViewControllers([deliveryStoryboard.instantiateViewController(withIdentifier: "DeliveryScreenVC")], animated: false)
            let mainViewController = storyboard.instantiateInitialViewController() as! MainViewController
            mainViewController.rootViewController = navigationController
            mainViewController.setup(type: UInt(2))

            let window = UIApplication.shared.delegate!.window!!
            window.rootViewController = mainViewController

            UIView.transition(with: window, duration: 0.3, options: [.transitionCrossDissolve], animations: nil, completion: nil)
        } else {
            let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
            let VC = storyboard.instantiateViewController(withIdentifier: "LoginView") as! LoginView
//            VC.isDelivery =  true
            self.navigationController?.pushViewController(VC, animated: true)
        }

    }
}
