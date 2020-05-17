//
//  NewAccountView.swift
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
class NewAccountView: UIViewController, UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate, UIGestureRecognizerDelegate {
    // MARK: - Outlet

    @IBOutlet var viewNavigation: UIView!
    @IBOutlet var lblTitle: UILabel!

    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var viewBorder: UIView!

    @IBOutlet var txtCountry: UITextField!
    @IBOutlet var txtMobile: UITextField!

    @IBOutlet var lblDetails: UILabel!
    @IBOutlet var btnSend: UIButton!
    @IBOutlet var btnLogin: UIButton!
    @IBOutlet var viewCountry: UIView!

    @IBOutlet var lblStep: UILabel!
    @IBOutlet var lblChooseCountry: UILabel!
    @IBOutlet var lblCanYou: UILabel!

    let salutations = ["Saudi Arabia"]
    var arrCountry: [String] = []
    var arrCountryID: [String] = []

    var loadingNotification: MBProgressHUD!
    var json: JSON!
    var strMessage: String!

    var app = AppDelegate()

    var strCountryID = String()
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

//        if self.app.isEnglish == false
//        {
//            self.lblTitle.text = "حساب جديد"
//            self.lblStep.text = "خطوة 1: التحقق من رقم الجوال"
//            self.lblChooseCountry.text = "اختر الدولة"
//        }
        self.lblTitle.text = "New Account".localized
        self.lblStep.text = "Step 1 : Verify your mobile number".localized
        self.lblChooseCountry.text = "Choose the country".localized

        if DeviceType.IS_IPHONE_5 {
            self.txtCountry.font = self.txtCountry.font!.withSize(self.txtCountry.font!.pointSize-1)
            self.txtMobile.font = self.txtMobile.font!.withSize(self.txtMobile.font!.pointSize-1)

            self.lblStep.font = self.lblStep.font.withSize(self.lblStep.font.pointSize-2)
            self.lblChooseCountry.font = self.lblChooseCountry.font.withSize(self.lblChooseCountry.font.pointSize-2)
            self.lblCanYou.font = self.lblCanYou.font.withSize(self.lblCanYou.font.pointSize-2)
            self.lblDetails.font = self.lblDetails.font.withSize(self.lblDetails.font.pointSize-2)
            self.btnSend.titleLabel!.font = self.btnSend.titleLabel!.font.withSize(self.btnSend.titleLabel!.font.pointSize-1)
            if self.app.isEnglish {
                self.btnLogin.titleLabel!.font = self.btnLogin.titleLabel!.font.withSize(self.btnLogin.titleLabel!.font.pointSize-2)
            } else {
                self.btnLogin.titleLabel!.font = self.btnLogin.titleLabel!.font.withSize(self.btnLogin.titleLabel!.font.pointSize-3)
            }
        }
        self.txtMobile.maxLength = 12

        if self.app.isEnglish {
            self.txtCountry.textAlignment = .left
            self.txtMobile.textAlignment = .left

            self.lblStep.textAlignment = .left
            self.lblChooseCountry.textAlignment = .left
            self.lblCanYou.textAlignment = .left

            if self.app.isLangEnglish {
                self.txtCountry.setRightPaddingPoints(self.viewCountry)
            } else {
                self.txtCountry.setLeftPaddingPoints(self.viewCountry)
            }
            self.lblTitle.textAlignment = .left
        } else {
            self.txtCountry.textAlignment = .right
            self.txtMobile.textAlignment = .right

            self.lblStep.textAlignment = .right
            self.lblChooseCountry.textAlignment = .right
            self.lblCanYou.textAlignment = .right

            if self.app.isLangEnglish {
                self.txtCountry.setLeftPaddingPoints(self.viewCountry)
            } else {
                self.txtCountry.setRightPaddingPoints(self.viewCountry)
            }
            self.lblTitle.textAlignment = .right
        }

        let pickerView = UIPickerView()
        pickerView.delegate = self
        txtCountry.inputView = pickerView

        self.setTextfildDesign(txt: self.txtCountry)
        self.setTextfildDesign(txt: self.txtMobile)

        self.btnLogin.layer.cornerRadius = 5

        let strBy = NSMutableAttributedString(string: "When you register a new account, you are accepting usage agreement and the application privacy policy".localized)
        strBy.setColorForText("usage agreement".localized, with: UIColor.init(rgb: 0xEE4158))
        strBy.setColorForText("privacy policy".localized, with: UIColor.init(rgb: 0xEE4158))
        self.lblDetails.attributedText = strBy

        let strLogin = NSMutableAttributedString(string: "Already have an account? log in".localized)
        strLogin.setColorForText("log in".localized, with: UIColor.init(rgb: 0xEE4158))
        self.btnLogin.setAttributedTitle(strLogin, for: .normal)

        self.setScrollViewHeight()

        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        tap.delegate = self // This is not required
        tap.numberOfTouchesRequired = 1
        self.lblDetails.isUserInteractionEnabled = true

        self.lblDetails.addGestureRecognizer(tap)

        if self.app.isConnectedToInternet() {
            self.getAllCountryAPI()
        } else {
            Toast(text: self.app.InternetConnectionMessage.localized).show()
        }

    }

    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        let VC = self.storyboard?.instantiateViewController(withIdentifier: "TermsView") as! TermsView
        self.navigationController?.pushViewController(VC, animated: true)
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

    @IBAction func btnMenu(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
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

//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
//    {
//        if self.txtMobile == textField
//        {
//            let ACCEPTABLE_CHARACTERS = "0123456789"
//            let cs = NSCharacterSet(charactersIn: ACCEPTABLE_CHARACTERS).inverted
//            let filtered = string.components(separatedBy: cs).joined(separator: "")
//
//            return (string == filtered)
//        }
//        return true
//    }

    // MARK: - Picker View
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.arrCountry.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.arrCountry[row]
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.txtCountry.text = self.arrCountry[row]
        self.strCountryID = self.arrCountryID[row]
    }

    @IBAction func btnAllAction(_ sender: UIButton) {
        if sender.tag == 1 {
            self.txtMobile.resignFirstResponder()
            self.strMobile = self.txtMobile.text!

            if self.strCountryID.isEmpty {
                Toast(text: "Please Select Country").show()
            } else if self.strMobile.isEmpty {
                Toast(text: "Please Enter Mobile Number".localized).show()
            } else if self.strMobile.count < 10 {
                Toast(text: "Mobile Number should be minimum of 10 characters".localized).show()
            } else {
                if self.app.isConnectedToInternet() {
                    self.getSignUpAPI()
                } else {
                    Toast(text: self.app.InternetConnectionMessage.localized).show()
                }
            }
        } else if sender.tag == 2 {
            let VC = self.storyboard?.instantiateViewController(withIdentifier: "LoginView") as! LoginView
            self.navigationController?.pushViewController(VC, animated: true)
        }
    }

    // MARK: - Sign Up API
    func getSignUpAPI() {

        let headers: HTTPHeaders = ["Content-Type": "application/json"]

        let parameters: Parameters = ["country_id": self.strCountryID,
                                      "phone": self.strMobile]
        print(JSON(parameters))

        AppWebservice.shared.request("\(self.app.BaseURL)registration_step_1", method: .post, parameters: parameters, headers: headers, loader: true) { (statusCode, response, error) in

            if statusCode == 200 {
                        self.json = response!
                        print(self.json)

                        let strStatus: String = self.json["status"].stringValue
                        self.strMessage = self.json["message"].stringValue

                        if strStatus == "1" {
//                            self.app.strUserID = self.json["user_id"].stringValue
                            self.app.strToken = self.json["token"].stringValue
                            self.app.strMobile = self.strMobile

                            let VC = self.storyboard?.instantiateViewController(withIdentifier: "VarifyNewView") as! VarifyNewView
                            VC.strMobile = self.strMobile
                            VC.strCountryID = self.strCountryID
                            self.navigationController?.pushViewController(VC, animated: true)
                        } else {
                            Toast(text: self.strMessage).show()
                        }
            } else {
                Toast(text: self.app.RequestTimeOut.localized).show()
            }
        }
    }

    // MARK: - Get All Country API
    func getAllCountryAPI() {
        AppWebservice.shared.request("\(self.app.BaseURL)get_all_country", method: .get, parameters: nil, headers: nil, loader: true) { (statusCode, response, error) in
            
            if statusCode == 200 {
                self.json = response!
                print(self.json)
                
                let strStatus: String = self.json["status"].stringValue
                self.strMessage = self.json["message"].stringValue
                
                if strStatus == "1" {
                    let data = self.json["data"]
                    if data.count > 0 {
                        for i in 0...data.count-1 {
                            let strID = data[i]["id"].stringValue
                            let strName = data[i]["country_name"].stringValue
                            
                            self.strCountryID = data[0]["id"].stringValue
                            self.txtCountry.text = data[0]["country_name"].stringValue
                            
                            self.arrCountry.append(strName)
                            self.arrCountryID.append(strID)
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
