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
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!

    var app = AppDelegate()

    // MARK: - UIViewController Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        btnDiscount.layer.cornerRadius = btnDiscount.frame.size.height / 2
        btnDiscount.clipsToBounds = true

        btnDelivery.layer.cornerRadius = btnDelivery.frame.size.height / 2
        btnDelivery.clipsToBounds = true
        
        if self.app.strLanguage == "ar" {
            segmentedControl.selectedSegmentIndex = 1
        } else {
            segmentedControl.selectedSegmentIndex = 0
        }
        
        segmentedControl.addTarget(self, action: #selector(StartScreenVC.indexChanged(_:)), for: .valueChanged)
        segmentedControl.addTarget(self, action: #selector(StartScreenVC.indexChanged(_:)), for: .touchUpInside)

    }

    // MARK: - IBAction Methods
    @IBAction func discountTapped(_ sender: UIButton) {

        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "SidemenuView"), object: nil, userInfo: nil)

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let navigationController = storyboard.instantiateViewController(withIdentifier: "NavigationController") as! UINavigationController
        let deliveryStoryboard = UIStoryboard.init(name: "Main", bundle: nil)
        navigationController.setViewControllers([deliveryStoryboard.instantiateViewController(withIdentifier: "HomeView")], animated: false)
        let mainViewController = storyboard.instantiateInitialViewController() as! MainViewController
        mainViewController.rootViewController = navigationController
        mainViewController.setup(type: UInt(2))

        let window = UIApplication.shared.delegate!.window!!
        window.rootViewController = mainViewController

        UIView.transition(with: window, duration: 0.3, options: [.transitionCrossDissolve], animations: nil, completion: nil)
        
//        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
//        let VC = storyboard.instantiateViewController(withIdentifier: "HomeView") as! HomeView
//        self.navigationController?.pushViewController(VC, animated: true)
    }

    @IBAction func deliveryTapped(_ sender: UIButton) {
        if app.defaults.string(forKey: "user_id") != nil {

//            self.app.isDelivery = true
            self.app.defaults.set(true, forKey: "isDelivery")
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
            VC.isDelivery =  true
            self.navigationController?.pushViewController(VC, animated: true)
        }

    }
    
    @objc func indexChanged(_ sender: UISegmentedControl) {
        if segmentedControl.selectedSegmentIndex == 0 {
            self.changeLang()
        } else if segmentedControl.selectedSegmentIndex == 1 {
            self.changeLang()
        }
    }
    
    func changeLang(){
        if self.app.strLanguage == "ar" {
            self.app.strLanguage = "en"
            self.app.isEnglish = true
        } else {
            self.app.strLanguage = "ar"
            self.app.isEnglish = false
        }
        self.app.defaults.setValue(self.app.strLanguage, forKey: "selectedLanguage")
        self.app.defaults.setValue(self.app.isEnglish, forKey: "selectedLanguagebool")
        self.app.defaults.synchronize()
        sideMenuController?.hideLeftViewAnimated()

        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "SidemenuView"), object: nil, userInfo: nil)

        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "LANGUAGE_WILL_CHANGE"), object: self.app.strLanguage)

        let storyboard = UIStoryboard.init(name: "DeliveryModule", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "StartScreenVC")
        let navigation  = UINavigationController.init(rootViewController: vc)
        
        let window = UIApplication.shared.delegate!.window!!
        window.rootViewController = navigation

        UIView.transition(with: window, duration: 0.3, options: [.transitionCrossDissolve], animations: nil, completion: nil)
    }
}
