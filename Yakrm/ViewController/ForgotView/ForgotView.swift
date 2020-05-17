//
//  ForgotView.swift
//  Yakrm
//
//  Created by Apple on 20/05/19.
//  Copyright © 2019 Krutik V. Poojara. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import MBProgressHUD
import Toaster

@available(iOS 11.0, *)
class ForgotView: UIViewController, UITextFieldDelegate {
    // MARK: - Outlet

    @IBOutlet var viewNavigation: UIView!
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var lblStep: UILabel!

    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var viewBorder: UIView!

    @IBOutlet var txtMobile: UITextField!
    @IBOutlet var btnSend: UIButton!

    var loadingNotification: MBProgressHUD!
    var json: JSON!
    var strMessage: String!

    var app = AppDelegate()

    var strMobile = String()

    // MARK: -
    override func viewDidLoad() {
        super.viewDidLoad()
        app = UIApplication.shared.delegate as! AppDelegate

        self.viewNavigation.backgroundColor = UIColor.init(rgb: 0xEE4158)
        self.btnSend.layer.cornerRadius = 5

        self.viewBorder.dropShadow(color: .lightGray, opacity: 1, offSet: CGSize(width: 0, height: 1), radius: 1, scale: true)

        UIApplication.shared.statusBarStyle = .lightContent

        if DeviceType.IS_IPHONE_X || DeviceType.IS_IPHONE_XR {
            self.viewNavigation.frame = CGRect(x: self.viewNavigation.frame.origin.x, y: self.viewNavigation.frame.origin.y, width: self.viewNavigation.frame.size.width, height: 88)
            self.scrollView.frame = CGRect(x: self.scrollView.frame.origin.x, y: self.viewNavigation.frame.origin.y + self.viewNavigation.frame.size.height, width: self.scrollView.frame.size.width, height: ScreenSize.SCREEN_HEIGHT - self.viewNavigation.frame.size.height)
        }

        if DeviceType.IS_IPHONE_5 {
            self.txtMobile.font = self.txtMobile.font!.withSize(self.txtMobile.font!.pointSize-1)
        }

        if self.app.isEnglish {
            self.txtMobile.textAlignment = .left

            self.lblStep.textAlignment = .left
            self.lblTitle.textAlignment = .left
        } else {
            self.txtMobile.textAlignment = .right

            self.lblStep.textAlignment = .right
            self.lblTitle.textAlignment = .right

//            self.lblTitle.text = "هل نسيت كلمة المرور"
//            self.lblStep.text = "من فضلك أدخل رقم الجوال الخاص بك"
//            self.btnSend.setTitle("ارسال", for: .normal)
        }
        self.lblTitle.text = "Forgot Password".localized
        self.lblStep.text = "Can you enter your mobile number, please? ".localized
        self.btnSend.setTitle("Send".localized, for: .normal)

        self.txtMobile.maxLength = 12

        self.setTextfildDesign(txt: self.txtMobile)
        self.setScrollViewHeight()
    }

    @IBAction func btnBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
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
        txt.placeHolderColor = UIColor.darkGray.withAlphaComponent(0.5)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField .resignFirstResponder()
        return true
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if self.txtMobile == textField {
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

    @IBAction func btnSend(_ sender: UIButton) {
        self.txtMobile.resignFirstResponder()
        self.strMobile = self.txtMobile.text!

        if self.strMobile.isEmpty {
            Toast(text: "Please Enter Mobile Number".localized).show()
        } else if self.strMobile.count < 10 {
            Toast(text: "Mobile Number should be minimum of 10 characters".localized).show()
        } else {
            if self.app.isConnectedToInternet() {
                self.getLoginAPI()
            } else {
                Toast(text: self.app.InternetConnectionMessage.localized).show()
            }
        }
    }

    // MARK: - Log In API
    func getLoginAPI() {
        
        let headers: HTTPHeaders = ["Content-Type": "application/json"]

        let parameters: Parameters = ["phone": self.strMobile]
        print(JSON(parameters))
        
        AppWebservice.shared.request("\(self.app.BaseURL)checked_mobile_for_forgetpassword", method: .post, parameters: parameters, headers: headers, loader: true) { (statusCode, response, error) in

            if statusCode == 200 {
                        self.json = response!
                        print(self.json)

                        let strStatus: String = self.json["status"].stringValue
                        self.strMessage = self.json["message"].stringValue

                        if strStatus == "3" {
                            let VC = self.storyboard?.instantiateViewController(withIdentifier: "VarifyForgotView") as! VarifyForgotView
                            VC.strToken = self.json["token"].stringValue
                            VC.strVarify = self.json["otp"].stringValue
                            VC.strMobile = self.strMobile
                            self.navigationController?.pushViewController(VC, animated: true)
                        } else {
                            Toast(text: self.strMessage).show()
                        }
            } else {
                Toast(text: self.app.RequestTimeOut.localized).show()
            }
        }
    }

}
