//
//  LoginView.swift
//  Yakrm
//
//  Created by Krutik V. Poojara on 06/12/18.
//  Copyright © 2018 Krutik V. Poojara. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import MBProgressHUD
import Toaster

@available(iOS 11.0, *)
class LoginView: UIViewController, UITextFieldDelegate {
    // MARK: - Outlet

    @IBOutlet var viewNavigation: UIView!
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var viewBorder: UIView!

    @IBOutlet var txtEmail: UITextField!
    @IBOutlet var txtPassword: UITextField!
    @IBOutlet var btnLogin: UIButton!
    @IBOutlet var btnDontHaveAcc: UIButton!
    @IBOutlet var btnForgot: UIButton!
    @IBOutlet var btnNewAccount: UIButton!

    @IBOutlet var lblStep: UILabel!
    @IBOutlet var lblEmail: UILabel!
    @IBOutlet var lblPassword: UILabel!

    var loadingNotification: MBProgressHUD!
    var json: JSON!
    var strMessage: String!

    var app = AppDelegate()

    var strEmail = String()
    var strPassword = String()

    var isRegisterd = Bool()
    var isDelivery : Bool = false

    // MARK: -
    override func viewDidLoad() {
        super.viewDidLoad()
        app = UIApplication.shared.delegate as! AppDelegate

        UIApplication.shared.statusBarStyle = .lightContent

        self.viewNavigation.backgroundColor = UIColor.init(rgb: 0xEE4158)

        self.viewBorder.dropShadow(color: .lightGray, opacity: 1, offSet: CGSize(width: 0, height: 1), radius: 1, scale: true)

        if DeviceType.IS_IPHONE_X || DeviceType.IS_IPHONE_XR {
            self.viewNavigation.frame = CGRect(x: self.viewNavigation.frame.origin.x, y: self.viewNavigation.frame.origin.y, width: self.viewNavigation.frame.size.width, height: 88)
            self.scrollView.frame = CGRect(x: self.scrollView.frame.origin.x, y: self.viewNavigation.frame.origin.y + self.viewNavigation.frame.size.height, width: self.scrollView.frame.size.width, height: ScreenSize.SCREEN_HEIGHT - self.viewNavigation.frame.size.height)
        }

//        if self.app.isEnglish == false
//        {
//            self.lblStep.text = "خطوة 1: التحقق من رقم الجوال"
//            self.lblEmail.text = "البريد الإلكتروني"
//            self.btnNewAccount.setTitle("ليس لديك حساب؟", for: .normal)
//        }
        self.lblStep.text = "Enter login data".localized
        self.lblEmail.text = "Mobile".localized
        self.btnNewAccount.setTitle("Do not have an account?".localized, for: .normal)

        if DeviceType.IS_IPHONE_5 {
            self.txtEmail.font = self.txtEmail.font!.withSize(self.txtEmail.font!.pointSize-1)
            self.txtPassword.font = self.txtPassword.font!.withSize(self.txtPassword.font!.pointSize-1)

            self.lblStep.font = self.lblStep.font.withSize(self.lblStep.font.pointSize-2)
            self.lblEmail.font = self.lblEmail.font.withSize(self.lblEmail.font.pointSize-2)
            self.lblPassword.font = self.lblPassword.font.withSize(self.lblPassword.font.pointSize-2)
            self.btnLogin.titleLabel!.font = self.btnLogin.titleLabel!.font.withSize(self.btnLogin.titleLabel!.font.pointSize-2)
            self.btnForgot.titleLabel!.font = self.btnForgot.titleLabel!.font.withSize(self.btnForgot.titleLabel!.font.pointSize-1)
            self.btnNewAccount.titleLabel!.font = self.btnNewAccount.titleLabel!.font.withSize(self.btnNewAccount.titleLabel!.font.pointSize-1)
        }

        if self.app.isEnglish {
            self.txtEmail.textAlignment = .left
            self.txtPassword.textAlignment = .left

            self.lblStep.textAlignment = .left
            self.lblEmail.textAlignment = .left
            self.lblPassword.textAlignment = .left
            self.lblTitle.textAlignment = .left
        } else {
            self.txtEmail.textAlignment = .right
            self.txtPassword.textAlignment = .right

            self.lblStep.textAlignment = .right
            self.lblEmail.textAlignment = .right
            self.lblPassword.textAlignment = .right
            self.lblTitle.textAlignment = .right
        }

        self.setTextfildDesign(txt: self.txtEmail)
        self.setTextfildDesign(txt: self.txtPassword)

        self.btnLogin.layer.cornerRadius = 5
        self.setScrollViewHeight()

//        self.lblEmail.text = "Sign Up/Log In".localized123
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if self.txtEmail == textField {
            guard let text = textField.text else {
                return true
            }
            let lastText = (text as NSString).replacingCharacters(in: range, with: string) as String
            if lastText.count == 1 {
                if !lastText.hasPrefix("0") {
                    self.getValidation()
                    return false
                }
            } else if lastText.count == 2 {
                if !lastText.hasPrefix("05") {
                    self.getValidation()
                    return false
                }
            } else {
                let ACCEPTABLE_CHARACTERS = "0123456789"
                let cs = NSCharacterSet(charactersIn: ACCEPTABLE_CHARACTERS).inverted
                let filtered = string.components(separatedBy: cs).joined(separator: "")

                return (string == filtered)
            }
        }
        return true
    }

    func getValidation() {
        let alertController = UIAlertController(title: "Yakrm", message: "Mobile Number Start with".localized + " \"05\"", preferredStyle: .alert)

        let cancelAction = UIAlertAction(title: "OK".localized, style: .default) { (_: UIAlertAction!) in
            print("you have pressed the Cancel button")
        }
        alertController.addAction(cancelAction)

        self.present(alertController, animated: true, completion: nil)
    }
    func setTextfildDesign(txt: UITextField) {
        txt.layer.borderWidth = 1
        txt.layer.borderColor = UIColor.darkGray.withAlphaComponent(0.5).cgColor
        txt.delegate = self
        let vv = UIView()
        vv.backgroundColor = UIColor.clear
        vv.frame = CGRect(x: 0, y: 0, width: 10, height: txt.frame.size.height)
        if self.app.isEnglish {
            if self.app.isLangEnglish {
                txt.setLeftPaddingPoints(vv)
            } else {
                txt.setRightPaddingPoints(vv)
            }
        } else {
            if self.app.isLangEnglish {
                txt.setRightPaddingPoints(vv)
            } else {
                txt.setLeftPaddingPoints(vv)
            }
        }
        txt.placeHolderColor = UIColor.darkGray.withAlphaComponent(0.5)
    }

    func setScrollViewHeight() {
        for viewAll: UIView in scrollView.subviews {
            if viewAll.tag == 100 {
                scrollView.contentSize = CGSize(width: CGFloat(scrollView.frame.size.width), height: CGFloat(viewAll.frame.origin.y + viewAll.frame.size.height + 15))
            }
        }
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField .resignFirstResponder()
        return true
    }

    @IBAction func btnBack(_ sender: UIButton) {
        if self.isRegisterd {
            let desiredViewController = self.navigationController!.viewControllers.filter { $0 is ViewController }.first!
            self.navigationController!.popToViewController(desiredViewController, animated: true)
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }

    @IBAction func btnAllAction(_ sender: UIButton) {
        if sender.tag == 1 {
            self.txtEmail.resignFirstResponder()
            self.txtPassword.resignFirstResponder()

            self.strEmail = self.txtEmail.text!
            self.strPassword = self.txtPassword.text!

            if self.strEmail.isEmpty {
                Toast(text: "Please Enter Mobile Number".localized).show()
            }
//                Please Enter Email
//            else if self.strEmail.isValidEmail() == false
//            {
//                Toast(text: "Please Enter Valid Email".localized).show()
//            }
            else if self.strPassword.isEmpty {
                Toast(text: "Please Enter Password".localized).show()
            } else {
                if self.app.isConnectedToInternet() {
                    self.getLoginAPI()
                } else {
                    Toast(text: self.app.InternetConnectionMessage.localized).show()
                }
            }
        } else if sender.tag == 2 {
            let VC = self.storyboard?.instantiateViewController(withIdentifier: "NewAccountView") as! NewAccountView
            self.navigationController?.pushViewController(VC, animated: true)
        } else {
            let VC = self.storyboard?.instantiateViewController(withIdentifier: "ForgotView") as! ForgotView
            self.navigationController?.pushViewController(VC, animated: true)
        }
    }

    // MARK: - Log In API
    func getLoginAPI() {

        let parameters: Parameters = ["phone": self.strEmail,
                                      "password": self.strPassword,
                                      "apn_id": self.app.strDeviceToken]
        print(JSON(parameters))

        AppWebservice.shared.request("\(self.app.BaseURL)login", method: .post, parameters: parameters, headers: nil, loader: true) { (statusCode, response, error) in
            
            if statusCode == 200 {
                        self.json = response!
                        print(self.json)

                        let strStatus: String = self.json["status"].stringValue
                        self.strMessage = self.json["message"].stringValue

                        if strStatus == "1" {
                            self.app.strUserID = self.json["user_id"].stringValue
                            self.app.strName = self.json["name"].stringValue
                            self.app.strEmail = self.json["email"].stringValue
                            self.app.strMobile = self.json["phone"].stringValue
                            self.app.strProfile = self.json["user_profile"].stringValue
                            self.app.strToken = self.json["token"].stringValue
                            self.app.strWallet = self.json["wallet"].stringValue
                            self.app.strUserType = self.json["user_type"].stringValue

                            self.app.defaults.setValue(self.app.strUserID, forKey: "user_id")

                            self.app.defaults.setValue(self.app.strName, forKey: "name")
                            self.app.defaults.setValue(self.app.strEmail, forKey: "email")
                            self.app.defaults.setValue(self.app.strMobile, forKey: "mobile")
                            self.app.defaults.setValue(self.app.strProfile, forKey: "profile")
                            self.app.defaults.setValue(self.app.strToken, forKey: "tokan")
                            self.app.defaults.setValue(self.app.strWallet, forKey: "wallet")
                            self.app.defaults.setValue(self.app.strUserType, forKey: "user_type")

                            self.app.defaults.synchronize()

                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "SidemenuView"), object: nil, userInfo: nil)
                            
                            if self.isDelivery {
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
                            }else {
                                if self.app.strUserType == "users" {
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
                                    
//                                    let VC = self.storyboard?.instantiateViewController(withIdentifier: "HomeView") as! HomeView
//                                    self.navigationController?.pushViewController(VC, animated: true)
                                } else {
                                    let VC = self.storyboard?.instantiateViewController(withIdentifier: "CouponView") as! CouponView
                                    self.navigationController?.pushViewController(VC, animated: true)
                                }
                            }
                            
                            
                        } else {
                            Toast(text: self.strMessage).show()
                        }
            } else {
                Toast(text: self.app.RequestTimeOut.localized).show()
            }
        }
    }

}
