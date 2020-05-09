//
//  RegisterView.swift
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

class RegisterView: UIViewController, UITextFieldDelegate {
    // MARK: - Outlet

    @IBOutlet var viewNavigation: UIView!
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var viewBorder: UIView!

    @IBOutlet var txtName: UITextField!
    @IBOutlet var txtEmail: UITextField!
    @IBOutlet var txtPassword: UITextField!

    @IBOutlet var btnRegister: UIButton!
    @IBOutlet var btnLogin: UIButton!

    @IBOutlet var lblStep: UILabel!
    @IBOutlet var lblName: UILabel!
    @IBOutlet var lblEmail: UILabel!
    @IBOutlet var lblPassword: UILabel!

    var loadingNotification: MBProgressHUD!
    var json: JSON!
    var strMessage: String!

    var app = AppDelegate()

    var strName = String()
    var strEmail = String()
    var strPassword = String()

    // MARK: -
    override func viewDidLoad() {
        super.viewDidLoad()
        app = UIApplication.shared.delegate as! AppDelegate

        self.viewNavigation.backgroundColor = UIColor.init(rgb: 0xEE4158)

        self.viewBorder.dropShadow(color: .lightGray, opacity: 1, offSet: CGSize(width: 0, height: 1), radius: 1, scale: true)

        if DeviceType.IS_IPHONE_X || DeviceType.IS_IPHONE_XR {
            self.viewNavigation.frame = CGRect(x: self.viewNavigation.frame.origin.x, y: self.viewNavigation.frame.origin.y, width: self.viewNavigation.frame.size.width, height: 88)
            self.scrollView.frame = CGRect(x: self.scrollView.frame.origin.x, y: self.viewNavigation.frame.origin.y + self.viewNavigation.frame.size.height, width: self.scrollView.frame.size.width, height: ScreenSize.SCREEN_HEIGHT - self.viewNavigation.frame.size.height)
        }
        if DeviceType.IS_IPHONE_5 {
            self.txtName.font = self.txtName.font!.withSize(self.txtName.font!.pointSize-1)
            self.txtEmail.font = self.txtEmail.font!.withSize(self.txtEmail.font!.pointSize-1)
            self.txtPassword.font = self.txtPassword.font!.withSize(self.txtPassword.font!.pointSize-1)

            self.lblStep.font = self.lblStep.font.withSize(self.lblStep.font.pointSize-3)
            self.lblName.font = self.lblName.font.withSize(self.lblName.font.pointSize-2)
            self.lblEmail.font = self.lblEmail.font.withSize(self.lblEmail.font.pointSize-2)
            self.lblPassword.font = self.lblPassword.font.withSize(self.lblPassword.font.pointSize-2)
            self.btnLogin.titleLabel!.font = self.btnLogin.titleLabel!.font.withSize(self.btnLogin.titleLabel!.font.pointSize-2)
            self.btnRegister.titleLabel!.font = self.btnRegister.titleLabel!.font.withSize(self.btnRegister.titleLabel!.font.pointSize-2)
        }
        if self.app.isEnglish {
            self.txtName.textAlignment = .left
            self.txtEmail.textAlignment = .left
            self.txtPassword.textAlignment = .left

            self.lblStep.textAlignment = .left
            self.lblName.textAlignment = .left
            self.lblEmail.textAlignment = .left
            self.lblPassword.textAlignment = .left
            self.lblTitle.textAlignment = .left
        } else {
            self.txtName.textAlignment = .right
            self.txtEmail.textAlignment = .right
            self.txtPassword.textAlignment = .right

            self.lblStep.textAlignment = .right
            self.lblName.textAlignment = .right
            self.lblEmail.textAlignment = .right
            self.lblPassword.textAlignment = .right
            self.lblTitle.textAlignment = .right
        }

        let strBy = NSMutableAttributedString(string: "You Have already have an account? log in".localized)
        strBy.setColorForText("log in".localized, with: UIColor.init(rgb: 0xEE4158))
        self.btnLogin.setAttributedTitle(strBy, for: .normal)

        self.setTextfildDesign(txt: self.txtName)
        self.setTextfildDesign(txt: self.txtEmail)
        self.setTextfildDesign(txt: self.txtPassword)

        self.btnRegister.layer.cornerRadius = 5
        self.setScrollViewHeight()
    }

    func setScrollViewHeight() {
        for viewAll: UIView in scrollView.subviews {
            if viewAll.tag == 100 {
                scrollView.contentSize = CGSize(width: CGFloat(scrollView.frame.size.width), height: CGFloat(viewAll.frame.origin.y + viewAll.frame.size.height + 15))
            }
        }
    }

    @IBAction func btnBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
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

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField .resignFirstResponder()
        return true
    }

    @IBAction func btnAllAction(_ sender: UIButton) {
        if sender.tag == 1 {
            self.txtName.resignFirstResponder()
            self.txtEmail.resignFirstResponder()
            self.txtPassword.resignFirstResponder()

            self.strName = self.txtName.text!
            self.strEmail = self.txtEmail.text!
            self.strPassword = self.txtPassword.text!

            if self.strName.isEmpty {
                Toast(text: "Please Enter Name").show()
            } else if self.strName.count < 3 {
                Toast(text: "Name should be minimum of 3 characters").show()
            } else if self.strEmail.isEmpty {
                Toast(text: "Please Enter Email").show()
            } else if self.strEmail.isValidEmail() == false {
                Toast(text: "Please Enter Valid Email").show()
            } else if self.strPassword.isEmpty {
                Toast(text: "Please Enter Password").show()
            } else if self.strPassword.count < 6 {
                Toast(text: "Password should be minimum of 6 characters").show()
            } else {
                if self.app.isConnectedToInternet() {
                    self.getSignUpAPI()
                } else {
                    Toast(text: self.app.InternetConnectionMessage).show()
                }
            }
        } else if sender.tag == 2 {
            let VC = self.storyboard?.instantiateViewController(withIdentifier: "LoginView") as! LoginView
            self.navigationController?.pushViewController(VC, animated: true)
        }
    }

    // MARK: - Sign Up API
    func getSignUpAPI() {
        loadingNotification = MBProgressHUD.showAdded(to: self.view, animated: false)
        loadingNotification.mode = MBProgressHUDMode.indeterminate
        loadingNotification.label.text = "Loading..."
//        loadingNotification.dimBackground = true

        let headers: HTTPHeaders = ["Authorization": self.app.strToken,
                                     "Content-Type": "application/json"]

        let parameters: Parameters = ["name": self.strName,
                                      "email": self.strEmail,
                                      "password": self.strPassword]
        print(JSON(parameters))

        AppWebservice.shared.request("\(self.app.BaseURL)registration_step_2", method: .post, parameters: parameters, headers: headers, loader: true) { (statusCode, response, error) in

            if statusCode == 200 {
                self.json = response!
                print(self.json)

                let strStatus: String = self.json["status"].stringValue
                self.strMessage = self.json["message"].stringValue
                Toast(text: self.strMessage).show()

                if strStatus == "1" {
                    self.app.strUserID = self.json["user_id"].stringValue
                    self.app.strName = self.json["name"].stringValue
                    self.app.strEmail = self.json["email"].stringValue
                    self.app.strMobile = self.json["phone"].stringValue
                    self.app.strProfile = self.json["user_profile"].stringValue
                    self.app.strToken = self.json["token"].stringValue
                    self.app.strWallet = "0"

                    self.app.defaults.setValue(self.app.strUserID, forKey: "user_id")

                    self.app.defaults.setValue(self.app.strName, forKey: "name")
                    self.app.defaults.setValue(self.app.strEmail, forKey: "email")
                    self.app.defaults.setValue(self.app.strMobile, forKey: "mobile")
                    self.app.defaults.setValue(self.app.strProfile, forKey: "profile")
                    self.app.defaults.setValue(self.app.strToken, forKey: "tokan")
                    self.app.defaults.setValue(self.app.strWallet, forKey: "wallet")

                    self.app.defaults.synchronize()

                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "SidemenuView"), object: nil, userInfo: nil)

                    let VC = self.storyboard?.instantiateViewController(withIdentifier: "HomeView") as! HomeView
                    self.navigationController?.pushViewController(VC, animated: true)
                }
            } else {
                Toast(text: error?.localizedDescription).show()
            }

        }
    }

}
