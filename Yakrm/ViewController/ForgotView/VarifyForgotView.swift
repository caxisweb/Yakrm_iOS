//
//  VarifyForgotView.swift
//  Yakrm
//
//  Created by Apple on 20/05/19.
//  Copyright © 2019 Krutik V. Poojara. All rights reserved.
//

import UIKit
import PinCodeTextField
import Alamofire
import SwiftyJSON
import MBProgressHUD
import Toaster

@available(iOS 11.0, *)
class VarifyForgotView: UIViewController, PinCodeTextFieldDelegate {
    // MARK: - Outlet
    @IBOutlet var viewNavigation: UIView!
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var viewBorder: UIView!

    @IBOutlet var txtCode: PinCodeTextField!

    @IBOutlet var btnVarify: UIButton!

    @IBOutlet var lblStep: UILabel!
    @IBOutlet var lblDetails: UILabel!

    @IBOutlet var lblCount: UILabel!
    @IBOutlet var btnResend: UIButton!

    fileprivate lazy var allTextFields: [PinCodeTextField] = {
        let allTextFields: [PinCodeTextField] = [
        ]
        return allTextFields
    }()

    var loadingNotification: MBProgressHUD!
    var json: JSON!
    var strMessage: String!

    var app = AppDelegate()

    var strOTP = String()
    var strToken = String()
    var strVarify = String()

    var timer = Timer()
    var counter = 60
    var strMobile = String()

    // MARK: -
    override func viewDidLoad() {
        super.viewDidLoad()
        app = UIApplication.shared.delegate as! AppDelegate

        self.viewNavigation.backgroundColor = UIColor.init(rgb: 0xEE4158)

        self.btnVarify.layer.cornerRadius = 5

        self.viewBorder.dropShadow(color: .lightGray, opacity: 1, offSet: CGSize(width: 0, height: 1), radius: 1, scale: true)

        if DeviceType.IS_IPHONE_X || DeviceType.IS_IPHONE_XR {
            self.viewNavigation.frame = CGRect(x: self.viewNavigation.frame.origin.x, y: self.viewNavigation.frame.origin.y, width: self.viewNavigation.frame.size.width, height: 88)
            self.scrollView.frame = CGRect(x: self.scrollView.frame.origin.x, y: self.viewNavigation.frame.origin.y + self.viewNavigation.frame.size.height, width: self.scrollView.frame.size.width, height: ScreenSize.SCREEN_HEIGHT - self.viewNavigation.frame.size.height)
        }

        if DeviceType.IS_IPHONE_5 {
            self.lblStep.font = self.lblStep.font.withSize(self.lblStep.font.pointSize-2)
            self.btnVarify.titleLabel!.font = self.btnVarify.titleLabel!.font.withSize(self.btnVarify.titleLabel!.font.pointSize-1)
            self.btnResend.titleLabel!.font = self.btnResend.titleLabel!.font.withSize(self.btnResend.titleLabel!.font.pointSize-1)
        }

        if self.app.isEnglish {
            self.lblStep.textAlignment = .left
            self.lblTitle.textAlignment = .left

//            let txt = UITextField()
//            txt.textAlignment =
        } else {
            self.lblStep.textAlignment = .right
            self.lblTitle.textAlignment = .right

//            self.lblTitle.text = "تحقق من المستخدم"
//            self.lblStep.text = "أدخل الكود السري المرسل إليك"
//            self.btnVarify.setTitle("تحقق", for: .normal)
        }
        self.lblTitle.text = "Varify User".localized
        self.lblStep.text = "Enter the secret code which is sent to you ".localized
        self.btnVarify.setTitle("Verify".localized, for: .normal)
        self.btnResend.setTitle("Resend".localized, for: .normal)

        self.btnResend.layer.cornerRadius = self.btnResend.frame.size.height / 2
        self.btnResend.clipsToBounds = true
        self.btnResend.layer.borderWidth = 1
        self.btnResend.layer.borderColor = UIColor.init(rgb: 0xE8385A).cgColor

        self.txtCode.layer.borderWidth = 1
        self.txtCode.layer.borderColor = UIColor.darkGray.withAlphaComponent(0.5).cgColor

        self.txtCode.keyboardType = .numberPad
        self.txtCode.delegate = self

        let flexibleButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel".localized, style: .plain, target: self, action: #selector(cancelClicked(_:)))

        let doneButton = UIBarButtonItem(title: "Done".localized, style: .plain, target: self, action: #selector(doneClicked(_:)))
        let toolbar = UIToolbar()
        toolbar.items = [cancelButton, flexibleButton, doneButton]

        toolbar.sizeToFit()

        self.allTextFields.append(txtCode)

        self.allTextFields.forEach { (textField) in
            textField.inputAccessoryView = toolbar
        }

        let strBy = NSMutableAttributedString(string: "You do not own this mobile ? Change the number".localized)
        strBy.setColorForText("Change the number".localized, with: UIColor.init(rgb: 0xEE4158))
        self.lblDetails.attributedText = strBy

        self.setScrollViewHeight()

        self.setTimer()
    }

    func setTimer() {
        if DeviceType.IS_SIMULATOR {
            counter = 10
        }
        self.btnResend.isEnabled = false
        self.btnResend.alpha = 0.7

        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateCounter), userInfo: nil, repeats: true)
    }

    @objc func updateCounter() {
        if counter > 0 {
            counter -= 1
            print("\(counter) seconds to the end of the world")
            if counter > 9 {
                self.lblCount.text = "00 : \(self.counter)"
            } else {
                self.lblCount.text = "00 : 0\(self.counter)"
            }
        } else {
            self.counter = 60
            self.lblCount.text = "00 : 00"
            self.btnResend.isEnabled = true
            self.btnResend.alpha = 1.0
            self.timer.invalidate()
        }
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

    @IBAction func doneClicked(_ sender: Any) {
        self.txtCode.resignFirstResponder()
    }

    @IBAction func cancelClicked(_ sender: Any) {
        self.txtCode.resignFirstResponder()
    }

    @IBAction func btnVarify(_ sender: UIButton) {
        if self.txtCode.text == nil//!.isEmpty
        {
            Toast(text: "Please Enter OTP".localized).show()
            return
        }
        self.strOTP = self.txtCode.text!
        if self.strOTP.isEmpty {
            Toast(text: "Please Enter OTP".localized).show()
        } else {
            if self.strVarify == self.strOTP {
                let VC = self.storyboard?.instantiateViewController(withIdentifier: "VarifyPasswordView") as! VarifyPasswordView
                VC.strToken = self.strToken
                VC.strOTP = self.strOTP
                self.navigationController?.pushViewController(VC, animated: true)
            } else {
                Toast(text: "OTP not Varify".localized).show()
            }
        }
    }

    // MARK: - Varify OTP API
    func VarifyOTPAPI() {
        
        let headers: HTTPHeaders = ["Authorization": self.strToken,
                                     "Content-Type": "application/json"]

        let parameters: Parameters = ["otp": self.strOTP]
        print(JSON(parameters))
        
        AppWebservice.shared.request("\(self.app.BaseURL)verify_otp", method: .post, parameters: parameters, headers: headers, loader: true) { (statusCode, response, error) in
        
            if statusCode == 200 {
                        self.json = response!
                        print(self.json)

                        let strStatus: String = self.json["status"].stringValue
                        self.strMessage = self.json["message"].stringValue

                        if strStatus == "1" {
                            //                            let VC = self.storyboard?.instantiateViewController(withIdentifier: "RegisterView") as! RegisterView
                            //                            self.navigationController?.pushViewController(VC, animated: true)
                        } else if strStatus == "2" {
                            let VC = self.storyboard?.instantiateViewController(withIdentifier: "RegisterView") as! RegisterView
                            self.navigationController?.pushViewController(VC, animated: true)
                        } else {
                            Toast(text: self.strMessage).show()
                        }
            } else {
                Toast(text: self.app.RequestTimeOut.localized).show()
            }
        }
    }

    @IBAction func btnResend(_ sender: UIButton) {
        if self.app.isConnectedToInternet() {
            self.ResendOTPAPI()
        } else {
            Toast(text: self.app.InternetConnectionMessage.localized).show()
        }
    }

    // MARK: - Log In API
    func ResendOTPAPI() {
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
                            self.strToken = self.json["token"].stringValue
                            self.strVarify = self.json["otp"].stringValue
                            self.setTimer()
                        } else {
                            Toast(text: self.strMessage).show()
                        }
            } else {
                Toast(text: self.app.RequestTimeOut.localized).show()
            }
        }
    }

}
