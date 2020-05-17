//
//  VarifyPasswordView.swift
//  Yakrm
//
//  Created by Apple on 21/05/19.
//  Copyright © 2019 Krutik V. Poojara. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import MBProgressHUD
import Toaster

@available(iOS 11.0, *)
class VarifyPasswordView: UIViewController, UITextFieldDelegate {
    // MARK: - Outlet

    @IBOutlet var viewNavigation: UIView!
    @IBOutlet var lblTitle: UILabel!

    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var viewBorder: UIView!

    @IBOutlet var txtNewPassword: UITextField!
    @IBOutlet var txtConfirmPassword: UITextField!

    @IBOutlet var btnChange: UIButton!

    @IBOutlet var lblNewPassword: UILabel!
    @IBOutlet var lblConfirmPassword: UILabel!

    var loadingNotification: MBProgressHUD!
    var json: JSON!
    var strMessage: String!

    var app = AppDelegate()

    var strNewPassword = String()
    var strConfirmPassword = String()
    var strToken = String()
    var strOTP = String()

    // MARK: -
    override func viewDidLoad() {
        super.viewDidLoad()
        app = UIApplication.shared.delegate as! AppDelegate

        self.viewNavigation.backgroundColor = UIColor.init(rgb: 0xEE4158)

        self.btnChange.layer.cornerRadius = 5

        self.viewBorder.dropShadow(color: .lightGray, opacity: 1, offSet: CGSize(width: 0, height: 1), radius: 1, scale: true)

        if DeviceType.IS_IPHONE_X || DeviceType.IS_IPHONE_XR {
            self.viewNavigation.frame = CGRect(x: self.viewNavigation.frame.origin.x, y: self.viewNavigation.frame.origin.y, width: self.viewNavigation.frame.size.width, height: 88)
            self.scrollView.frame = CGRect(x: self.scrollView.frame.origin.x, y: self.viewNavigation.frame.origin.y + self.viewNavigation.frame.size.height, width: self.scrollView.frame.size.width, height: ScreenSize.SCREEN_HEIGHT - self.viewNavigation.frame.size.height)
        }

        if DeviceType.IS_IPHONE_5 {
            self.txtNewPassword.font = self.txtNewPassword.font!.withSize(self.txtNewPassword.font!.pointSize-1)
            self.txtConfirmPassword.font = self.txtConfirmPassword.font!.withSize(self.txtConfirmPassword.font!.pointSize-1)

            self.lblNewPassword.font = self.lblNewPassword.font.withSize(self.lblNewPassword.font.pointSize-1)
            self.lblConfirmPassword.font = self.lblConfirmPassword.font.withSize(self.lblConfirmPassword.font.pointSize-1)
        }

        if self.app.isEnglish {
            self.txtNewPassword.textAlignment = .left
            self.txtConfirmPassword.textAlignment = .left

            self.lblNewPassword.textAlignment = .left
            self.lblConfirmPassword.textAlignment = .left
            self.lblTitle.textAlignment = .left
        } else {
            self.txtNewPassword.textAlignment = .right
            self.txtConfirmPassword.textAlignment = .right

            self.lblNewPassword.textAlignment = .right
            self.lblConfirmPassword.textAlignment = .right
            self.lblTitle.textAlignment = .right

//            self.lblTitle.text = "تغير كلمة المرور"
//            self.lblNewPassword.text = "أدخل كلمة مرور جديدة"
//            self.lblConfirmPassword.text = "أدخل تأكيد كلمة المرور"
//            self.btnChange.setTitle("تغير كلمة المرور", for: .normal)
        }
        self.lblTitle.text = "Change Password".localized
        self.lblNewPassword.text = "Enter New Password".localized
        self.lblConfirmPassword.text = "Enter Confirm Password".localized
        let change = "Change Password".localized
        self.btnChange.setTitle(change.uppercased(), for: .normal)

        self.setTextfildDesign(txt: self.txtNewPassword)
        self.setTextfildDesign(txt: self.txtConfirmPassword)

        self.setScrollViewHeight()
    }

    func setScrollViewHeight() {
        for viewAll: UIView in scrollView.subviews {
            if viewAll.tag == 100 {
                scrollView.contentSize = CGSize(width: CGFloat(scrollView.frame.size.width), height: CGFloat(viewAll.frame.origin.y + viewAll.frame.size.height + 15))
            }
        }
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
    }

    @IBAction func btnBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func btnChange(_ sender: UIButton) {
        self.txtNewPassword.resignFirstResponder()
        self.txtConfirmPassword.resignFirstResponder()

        self.strNewPassword = self.txtNewPassword.text!
        self.strConfirmPassword = self.txtConfirmPassword.text!

        if self.strNewPassword.isEmpty {
            Toast(text: "Please Enter Password".localized).show()
        } else if self.strNewPassword.count < 6 {
            Toast(text: "Password should be minimum of 6 characters".localized).show()
        } else if self.strConfirmPassword.isEmpty {
            Toast(text: "Please Enter Confirm Password".localized).show()
        } else if self.strConfirmPassword.count < 6 {
            Toast(text: "Password should be minimum of 6 characters".localized).show()
        } else if self.strConfirmPassword != self.strNewPassword {
            Toast(text: "Password not Match!".localized).show()
        } else {
            if self.app.isConnectedToInternet() {
                self.ChangePasswordAPI()
            } else {
                Toast(text: self.app.InternetConnectionMessage.localized).show()
            }
        }
    }

    // MARK: - Change Password API
    func ChangePasswordAPI() {
        let headers: HTTPHeaders = ["Authorization": self.strToken,
                                     "Content-Type": "application/json"]

        let parameters: Parameters = ["password": self.strNewPassword,
                                      "otp": self.strOTP]
        print(JSON(parameters))

        
            
        AppWebservice.shared.request("\(self.app.BaseURL)forgot_and_change_new_password", method: .post, parameters: parameters, headers: headers, loader: true) { (statusCode, response, error) in


            if statusCode == 200 {
                        self.json = response!
                        print(self.json)

                        let strStatus: String = self.json["status"].stringValue
                        self.strMessage = self.json["message"].stringValue

                        Toast(text: self.strMessage).show()

                        if strStatus == "1" {
                            let desiredViewController = self.navigationController!.viewControllers.filter { $0 is LoginView }.first!
                            self.navigationController!.popToViewController(desiredViewController, animated: true)
                        }
            } else {
                Toast(text: self.app.RequestTimeOut.localized).show()
            }
        }
    }

}
