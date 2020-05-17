//
//  ViewController.swift
//  Yakrm
//
//  Created by Krutik V. Poojara on 06/12/18.
//  Copyright © 2018 Krutik V. Poojara. All rights reserved.
//

import UIKit
import FSPagerView
import Photos
import AVKit
import AVFoundation

@available(iOS 11.0, *)
@available(iOS 11.0, *)
class ViewController: UIViewController, FSPagerViewDataSource, FSPagerViewDelegate {

    // MARK: - Outlet
    @IBOutlet var viewPager: FSPagerView! {
        didSet {
            self.viewPager.register(FSPagerViewCell.self, forCellWithReuseIdentifier: "cell")
            self.viewPager.itemSize = FSPagerView.automaticSize
        }
    }
    @IBOutlet var viewDetails: UIView!
    @IBOutlet var imgIcon: UIImageView!
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var lblSub: UILabel!
    @IBOutlet var lblDetails: UILabel!

    @IBOutlet var pageControll: UIPageControl!

    @IBOutlet var btnAdventure: UIButton!
    @IBOutlet var btnLogin: UIButton!
    @IBOutlet var btnSignUp: UIButton!
    @IBOutlet var btnLanguage: UIButton!

    var app = AppDelegate()
    // MARK: - 
    override func viewDidLoad() {
        super.viewDidLoad()
        app = UIApplication.shared.delegate as! AppDelegate

        if DeviceType.IS_IPHONE_X || DeviceType.IS_IPHONE_XR {
            self.btnLanguage.frame = CGRect(x: self.btnLanguage.frame.origin.x, y: 44, width: self.btnLanguage.frame.size.width, height: self.btnLanguage.frame.size.height)
        }

        if self.app.defaults.string(forKey: "selectedLanguagebool") != nil {
            self.app.isEnglish = (self.app.defaults.value(forKey: "selectedLanguagebool") as! Bool)
        }

        viewPager.delegate =  self
        viewPager.dataSource = self

        sideMenuController?.isRightViewSwipeGestureEnabled = false
        sideMenuController?.isLeftViewSwipeGestureEnabled = false
        sideMenuController?.leftViewWidth = self.view.frame.size.width - 60

        if DeviceType.IS_IPHONE_5 {
            self.lblTitle.font = self.lblTitle.font.withSize(self.lblTitle.font.pointSize-1)
            self.lblSub.font = self.lblSub.font.withSize(self.lblSub.font.pointSize-1)

            self.btnAdventure.titleLabel!.font = self.btnAdventure.titleLabel!.font.withSize(self.btnAdventure.titleLabel!.font.pointSize-2)
            self.btnSignUp.titleLabel!.font = self.btnSignUp.titleLabel!.font.withSize(self.btnSignUp.titleLabel!.font.pointSize-2)
            self.btnLogin.titleLabel!.font = self.btnLogin.titleLabel!.font.withSize(self.btnLogin.titleLabel!.font.pointSize-4)
        }

        self.btnSignUp.layer.cornerRadius = 5
        self.btnAdventure.layer.cornerRadius = 5

        self.btnSignUp.layer.borderWidth = 2
        self.btnSignUp.layer.borderColor = UIColor.init(rgb: 0xEE4158).cgColor

//        if self.app.isEnglish
//        {
            self.lblTitle.text = "Buy gift cards".localized
//        }
//        else
//        {
//            self.lblTitle.text = "شراء كروت الهدايا"
//        }

        self.btnLanguage.setTitle("English Version".localized, for: .normal)
        self.btnAdventure.setTitle("Start The Adventure".localized, for: .normal)

        let strLogin = NSMutableAttributedString(string: "Already have an account? log in".localized)
        strLogin.setColorForText("log in".localized, with: UIColor.init(rgb: 0xEE4158))
        self.btnLogin.setAttributedTitle(strLogin, for: .normal)

        self.permitionForRequestAccess()
    }

    func permitionForRequestAccess() {
        //Camera
        AVCaptureDevice.requestAccess(for: AVMediaType.video) { response in
            if response {
                //access granted
            } else {

            }
        }

        //Photos
        let photos = PHPhotoLibrary.authorizationStatus()
        if photos == .notDetermined {
            PHPhotoLibrary.requestAuthorization({status in
                if status == .authorized {
                } else {}
            })
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        UIApplication.shared.statusBarStyle = .default
    }

    public func numberOfItems(in pagerView: FSPagerView) -> Int {
        return 5
    }

    public func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "cell", at: index)

        self.pageControll.currentPage = index
        cell.backgroundColor = UIColor.clear

        return cell
    }

    @IBAction func btnAllAction(_ sender: UIButton) {
        if sender.tag == 1 {
            let VC = self.storyboard?.instantiateViewController(withIdentifier: "HomeView") as! HomeView
            self.navigationController?.pushViewController(VC, animated: true)
        } else if sender.tag == 2 {
            let VC = self.storyboard?.instantiateViewController(withIdentifier: "NewAccountView") as! NewAccountView
            self.navigationController?.pushViewController(VC, animated: true)
        } else if sender.tag == 3 {
            let VC = self.storyboard?.instantiateViewController(withIdentifier: "LoginView") as! LoginView
            self.navigationController?.pushViewController(VC, animated: true)
        } else if sender.tag == 4 {
            let VC = self.storyboard?.instantiateViewController(withIdentifier: "HomeView") as! HomeView
            self.navigationController?.pushViewController(VC, animated: true)
        } else {
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

            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "LANGUAGE_WILL_CHANGE"), object: self.app.strLanguage)

            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let navigationController = storyboard.instantiateViewController(withIdentifier: "NavigationController") as! UINavigationController
            navigationController.setViewControllers([storyboard.instantiateViewController(withIdentifier: "ViewController")], animated: false)
            let mainViewController = storyboard.instantiateInitialViewController() as! MainViewController
            mainViewController.rootViewController = navigationController
            mainViewController.setup(type: UInt(2))

            let window = UIApplication.shared.delegate!.window!!
            window.rootViewController = mainViewController

            UIView.transition(with: window, duration: 0.3, options: [.transitionCrossDissolve], animations: nil, completion: nil)
        }
    }

}

//        var img = UIImage()
//        if index == 0
//        {
//            img = UIImage(named:"new_logo.png")!
//        }
//        else
//        {
//            img = UIImage(named:"new_logo.png")!
//        }
//        imgIcon.image = img
//        lblTitle.text = "Title : \(index + 1)"
//        lblSub.text = "Sub : \(index + 1)"
//        lblDetails.text = "Desc : \(index + 1)"
//        cell.addSubview(viewDetails)
