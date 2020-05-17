//
//  ChangePasswordView.swift
//  Yakrm
//
//  Created by Krutik V. Poojara on 28/02/19.
//  Copyright © 2019 Krutik V. Poojara. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import MBProgressHUD
import Toaster

@available(iOS 11.0, *)
class ChangePasswordView: UIViewController, UITextFieldDelegate {
    // MARK: - Outlet

    @IBOutlet var viewNavigation: UIView!
    @IBOutlet var lblTitle: UILabel!

    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var viewBorder: UIView!

    @IBOutlet var txtOld: UITextField!
    @IBOutlet var txtNew: UITextField!
    @IBOutlet var txtConfirm: UITextField!

    @IBOutlet var btnChange: UIButton!

    @IBOutlet var lblOld: UILabel!
    @IBOutlet var lblNew: UILabel!
    @IBOutlet var lblConfirm: UILabel!

    var loadingNotification: MBProgressHUD!
    var json: JSON!
    var strMessage: String!
    var arabMessage: String!

    var app = AppDelegate()

    var strOld = String()
    var strNew = String()
    var strConfirm = String()

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
            self.txtOld.font = self.txtOld.font!.withSize(self.txtOld.font!.pointSize-1)
            self.txtNew.font = self.txtNew.font!.withSize(self.txtNew.font!.pointSize-1)
            self.txtConfirm.font = self.txtConfirm.font!.withSize(self.txtConfirm.font!.pointSize-1)

            self.lblOld.font = self.lblOld.font.withSize(self.lblOld.font.pointSize-1)
            self.lblNew.font = self.lblNew.font.withSize(self.lblNew.font.pointSize-1)
            self.lblConfirm.font = self.lblConfirm.font.withSize(self.lblConfirm.font.pointSize-1)
        }

        if self.app.isEnglish {
            self.txtOld.textAlignment = .left
            self.txtNew.textAlignment = .left
            self.txtConfirm.textAlignment = .left

            self.lblOld.textAlignment = .left
            self.lblNew.textAlignment = .left
            self.lblConfirm.textAlignment = .left
            self.lblTitle.textAlignment = .left
        } else {
            self.txtOld.textAlignment = .right
            self.txtNew.textAlignment = .right
            self.txtConfirm.textAlignment = .right

            self.lblOld.textAlignment = .right
            self.lblNew.textAlignment = .right
            self.lblConfirm.textAlignment = .right
            self.lblTitle.textAlignment = .right

//            self.lblTitle.text = "تغير كلمة المرور"
//            self.lblOld.text = "أدخل كلمة المرور القديمة"
//            self.lblNew.text = "أدخل كلمة مرور جديدة"
//            self.lblConfirm.text = "أدخل تأكيد كلمة المرور"
//            self.btnChange.setTitle("تغير كلمة المرور", for: .normal)
        }
        self.lblTitle.text = "Change Password".localized
        self.lblOld.text = "Enter Old Password".localized
        self.lblNew.text = "Enter New Password".localized
        self.lblConfirm.text = "Enter Confirm Password".localized
        let change = "Change Password".localized
        self.btnChange.setTitle(change.uppercased(), for: .normal)

        self.setTextfildDesign(txt: self.txtOld)
        self.setTextfildDesign(txt: self.txtNew)
        self.setTextfildDesign(txt: self.txtConfirm)

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
        self.txtOld.resignFirstResponder()
        self.txtNew.resignFirstResponder()
        self.txtConfirm.resignFirstResponder()

        self.strOld = self.txtOld.text!
        self.strNew = self.txtNew.text!
        self.strConfirm = self.txtConfirm.text!

        if self.strOld.isEmpty {
            Toast(text: "Please Enter Old Password".localized).show()
        } else if self.strNew.isEmpty {
            Toast(text: "Please Enter New Password".localized).show()
        } else if self.strNew.count < 6 {
            Toast(text: "Password should be minimum of 6 characters".localized).show()
        } else if self.strConfirm.isEmpty {
            Toast(text: "Please Enter Confirm Password".localized).show()
        } else if self.strNew.count < 6 {
            Toast(text: "Password should be minimum of 6 characters".localized).show()
        } else if self.strNew != self.strConfirm {
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
        let headers: HTTPHeaders = ["Authorization": self.app.strToken,
                                     "Content-Type": "application/json"]

        let parameters: Parameters = ["old_password": self.strOld,
                                      "new_password": self.strNew]
        print(JSON(parameters))

        
            
        AppWebservice.shared.request("\(self.app.BaseURL)change_password", method: .post, parameters: parameters, headers: headers, loader: true) { (statusCode, response, error) in

            if statusCode == 200 {
                        self.json = response!
                        print(self.json)

                        let strStatus: String = self.json["status"].stringValue
                        self.strMessage = self.json["message"].stringValue
                        self.arabMessage = self.json["arab_message"].stringValue
                        if self.app.strLanguage == "ar" {
                            self.app.isEnglish = false
                            Toast(text: self.arabMessage.localized).show()
                        } else {
                            self.app.isEnglish = true
                            Toast(text: self.strMessage).show()
                        }
                       // Toast(text: self.strMessage).show()

                        if strStatus == "1" {
                            self.navigationController?.popViewController(animated: true)
                        }
            } else {
                Toast(text: self.app.RequestTimeOut.localized).show()
            }
        }
    }

}
