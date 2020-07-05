//
//  PaymentMethodView.swift
//  Yakrm
//
//  Created by Krutik V. Poojara on 07/02/19.
//  Copyright © 2019 Krutik V. Poojara. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import MBProgressHUD
import Toaster

@available(iOS 11.0, *)
class PaymentMethodView: UIViewController, UITextFieldDelegate {
    // MARK: - Outlet

    @IBOutlet var viewNavigation: UIView!
    @IBOutlet var lblTitle: UILabel!

    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var viewTop: UIView!
    @IBOutlet var lblTopLabel: UILabel!

    @IBOutlet var viewBottom: UIView!
    @IBOutlet var lblAddPayment: UILabel!
    @IBOutlet var lblCardHolderName: UILabel!
    @IBOutlet var lblCardHolderNumber: UILabel!
    @IBOutlet var lblSecurityNumber: UILabel!
    @IBOutlet var lblExpireDate: UILabel!

    @IBOutlet var txtCardHolderName: UITextField!
    @IBOutlet var txtCardHolderNumber: UITextField!
    @IBOutlet var txtSecurityNumber: UITextField!
    @IBOutlet var txtExpireDate: UITextField!

    @IBOutlet var btnAdd: UIButton!

    @IBOutlet var btnCSID: UIButton!
    @IBOutlet var btnVisa: UIButton!

//    @IBOutlet var webView: UIWebView!

    var loadingNotification: MBProgressHUD!
    var json: JSON!
    var strMessage: String!

    var app = AppDelegate()

    var strCardHolderName = String()
    var strCardHolderNumber = String()
    var strExpireyDate = String()
    var strCVV = String()

    var strFirstName = String()
    var strLastName = String()

    var strMonth = String()
    var strYear = String()

    var strPaymentMethod = "2"
    var strCardID = String()

    // MARK: -
    override func viewDidLoad() {//512.png
        super.viewDidLoad()
        app = UIApplication.shared.delegate as! AppDelegate

//        self.webView.isHidden = true

        self.viewNavigation.backgroundColor = UIColor.init(rgb: 0xEE4158)
        self.btnAdd.layer.cornerRadius = 5

        if DeviceType.IS_IPHONE_X || DeviceType.IS_IPHONE_XR {
            self.viewNavigation.frame = CGRect(x: self.viewNavigation.frame.origin.x, y: self.viewNavigation.frame.origin.y, width: self.viewNavigation.frame.size.width, height: 88)
            self.scrollView.frame = CGRect(x: self.scrollView.frame.origin.x, y: self.viewNavigation.frame.origin.y + self.viewNavigation.frame.size.height, width: self.scrollView.frame.size.width, height: ScreenSize.SCREEN_HEIGHT - self.viewNavigation.frame.size.height)
        }

        if self.app.isEnglish {
            self.lblTitle.textAlignment = .left

            self.txtCardHolderName.textAlignment = .left
            self.txtCardHolderNumber.textAlignment = .left
            self.txtExpireDate.textAlignment = .left
            self.txtSecurityNumber.textAlignment = .left

            self.lblTopLabel.textAlignment = .left

            self.lblAddPayment.textAlignment = .left
            self.lblCardHolderName.textAlignment = .left
            self.lblCardHolderNumber.textAlignment = .left
            self.lblExpireDate.textAlignment = .left
            self.lblSecurityNumber.textAlignment = .left
        } else {
            self.lblTitle.textAlignment = .right

            self.txtCardHolderName.textAlignment = .right
            self.txtCardHolderNumber.textAlignment = .right
            self.txtExpireDate.textAlignment = .right
            self.txtSecurityNumber.textAlignment = .right

            self.lblTopLabel.textAlignment = .right

            self.lblAddPayment.textAlignment = .right
            self.lblCardHolderName.textAlignment = .right
            self.lblCardHolderNumber.textAlignment = .right
            self.lblExpireDate.textAlignment = .right
            self.lblSecurityNumber.textAlignment = .right
//            self.lblTitle.text = "طرق الدفع"
//            self.lblCardHolderNumber.text = "رقم البطاقة"
//            self.lblExpireDate.text = "تاريخ الانتهاء"
        }
        self.lblTitle.text = "Payment Methods".localized
        self.lblCardHolderNumber.text = "Card Holder Number".localized
        self.lblExpireDate.text = "Expiry Date".localized

        self.setTextfildDesign(txt: self.txtCardHolderName)
        self.setTextfildDesign(txt: self.txtCardHolderNumber)
        self.setTextfildDesign(txt: self.txtExpireDate)
        self.setTextfildDesign(txt: self.txtSecurityNumber)

        self.viewTop.backgroundColor = UIColor.white
        self.viewBottom.backgroundColor = UIColor.white

        self.viewTop.dropShadow(color: .lightGray, opacity: 1, offSet: CGSize(width: 0, height: 1), radius: 1, scale: true)
        self.viewBottom.dropShadow(color: .lightGray, opacity: 1, offSet: CGSize(width: 0, height: 1), radius: 1, scale: true)

        self.txtCardHolderNumber.maxLength = 16
        self.txtCardHolderName.maxLength = 25
        self.txtSecurityNumber.maxLength = 3
        self.txtExpireDate.maxLength = 5
        self.txtCardHolderNumber.placeHolderColor = UIColor.darkGray.withAlphaComponent(0.5)

        if !self.strCardID.isEmpty {
            self.txtCardHolderName.text = self.strCardHolderName
            self.txtCardHolderNumber.text = self.strCardHolderNumber
            self.txtExpireDate.text = self.strExpireyDate
            self.txtSecurityNumber.text = self.strCVV
        }

        self.checkPaymentMethod()
        self.setScrollViewHeight()
    }

    func checkPaymentMethod() {
        self.btnVisa.layer.cornerRadius = 2
        self.btnCSID.layer.cornerRadius = 2
        self.btnVisa.layer.borderColor = UIColor.darkGray.withAlphaComponent(0.5).cgColor
        self.btnCSID.layer.borderColor = UIColor.darkGray.withAlphaComponent(0.5).cgColor

        if self.strPaymentMethod == "2" {
            self.btnVisa.backgroundColor = UIColor.init(rgb: 0xE7EAED)
            self.btnCSID.backgroundColor = UIColor.white
            self.btnVisa.layer.borderWidth = 0
            self.btnCSID.layer.borderWidth = 1
        } else {
            self.btnVisa.backgroundColor = UIColor.white
            self.btnCSID.backgroundColor = UIColor.init(rgb: 0xE7EAED)
            self.btnVisa.layer.borderWidth = 1
            self.btnCSID.layer.borderWidth = 0
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
        txt.backgroundColor = UIColor.white
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField .resignFirstResponder()
        return true
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else {
            return true
        }
        let lastText = (text as NSString).replacingCharacters(in: range, with: string) as String

        if self.txtCardHolderName == textField {
            let ACCEPTABLE_CHARACTERS = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz "
            let cs = NSCharacterSet(charactersIn: ACCEPTABLE_CHARACTERS).inverted
            let filtered = string.components(separatedBy: cs).joined(separator: "")

            return (string == filtered)
        } else if self.txtCardHolderNumber == textField {
//            textField.text = lastText.format("nnnn nnnn nnnn nnnn", oldString: text)
            textField.text = lastText.format("nnnnnnnnnnnnnnnn", oldString: text)
            return false
        } else if self.txtExpireDate == textField {
            if lastText.isEmpty {
                return true
            }
            let firstchar: String = String(lastText.first!)
            if firstchar == "0" || firstchar == "1" {
                if lastText.count == 1 {
                    return true
                } else if lastText.count == 2 {
                    if firstchar == "0" && string == "0" {
                        return false
                    }
                    if firstchar == "0" {
                        return true
                    }
                    if string == "3" || string == "4" || string == "5" || string == "6" || string == "7" || string == "8" || string == "9" {
                        return false
                    }
                }
            } else {
                return false
            }
//            else if  firstchar != "1"
//            {
//                return false
//            }
            textField.text = lastText.format("nn/nn", oldString: text)
            return false
        }
        return true
    }

    @IBAction func btnCompleteAction(_ sender: UIButton) {
        self.txtCardHolderName.resignFirstResponder()
        self.txtCardHolderNumber.resignFirstResponder()
        self.txtExpireDate.resignFirstResponder()
        self.txtSecurityNumber.resignFirstResponder()

        self.strCardHolderName = self.txtCardHolderName.text!
        self.strCardHolderNumber = self.txtCardHolderNumber.text!
        self.strExpireyDate = self.txtExpireDate.text!
        self.strCVV = self.txtSecurityNumber.text!

        self.strCardHolderNumber = self.strCardHolderNumber.trimmingCharacters(in: .whitespaces)

        let arrFullName = self.strCardHolderName.components(separatedBy: " ")

        if self.strCardHolderName.isEmpty {
            Toast(text: "Please Enter Name".localized).show()
        } else if arrFullName.count < 2 {
            Toast(text: "Please Enter Full Name".localized).show()
        } else if self.strCardHolderNumber.isEmpty {
            Toast(text: "Please Enter Card Number".localized).show()
        } else if self.strCardHolderNumber.count != 16 {
            Toast(text: "Please Enter Correct Card No".localized).show()
        } else if self.strExpireyDate.isEmpty || self.strExpireyDate.count != 5 {
            Toast(text: "Please Enter Card Expiry date".localized).show()
        }
//        else if self.strExpireyDate.count != 5
//        {
//            Toast(text: "Please Enter Valid Expirey Date").show()
//        }
        else if self.strCVV.isEmpty {
            Toast(text: "Please Enter Security Number".localized).show()
        } else if self.strCVV.count != 3 {
            Toast(text: "Please Enter Correct Security Number".localized).show()
        } else {
//        print(self.strCardHolderName,self.strCardHolderNumber,self.strExpireyDate,self.strCVV)
//            self.strFirstName = arrFullName[0]
//            self.strLastName = arrFullName[1]
//
//            let arrFullDate = self.strExpireyDate.components(separatedBy: "/")
//            self.strMonth = arrFullDate[0]
//            self.strYear = arrFullDate[1]

            if self.app.isConnectedToInternet() {
                if self.strCardID.isEmpty {
                    self.AddPaymentCardsAPI()
                } else {
                    self.UpdatePaymentCardsAPI()
                }
            } else {
                Toast(text: self.app.InternetConnectionMessage.localized).show()
            }
        }
    }

    func VoucherPurchaseAPI() {
        
        let parameters: Parameters = ["secret_key": "ex2SHCqdgtJlrF2gp5fGCis3tUGh5EkjcmcTZD7g6RCxwEOWJ3Cml4qOY664KroXOBQNeY3lPFTlkHh4KUq6YQVXW22HtrFh2w4g",
                                      "merchant_email": "ahmed@yakrm.com",
                                      "amount": "123.00",
                                      "title": "Paytabs",
                                      "cc_first_name": self.strFirstName,
                                      "cc_last_name": self.strLastName,
                                      "card_exp": "\(self.strYear)\(self.strMonth)",
                                      "cvv": strCVV,
                                      "card_number": self.strCardHolderNumber,
                                      "original_assignee_code": "SDK",
                                      "currency": "SAR",
                                      "email": "ahmed@yakrm.com",
                                      "skip_email": "1",
                                      "phone_number": "00966551432252",
                                      "order_id": "123456",
                                      "product_name": "Product 1, Product 2",
                                      "customer_email": "jaypokarjdp@gmail.com",
                                      "country_billing": "BHR",
                                      "address_billing": "Flat 1,Building 123, Road 2345",
                                      "city_billing": "Manama",
                                      "state_billing": "Manama",
                                      "postal_code_billing": "00973",
                                      "country_shipping": "BHR",
                                      "address_shipping": "Flat 1,Building 123, Road 2345",
                                      "city_shipping": "Manama",
                                      "state_shipping": "Manama",
                                      "postal_code_shipping": "00973",
                                      "exchange_rate": "1",
                                      "is_tokenization": "TRUE",
                                      "is_existing_customer": "no",
                                      "pt_token": "null",
                                      "pt_customer_email": "null",
                                      "pt_customer_password": "null"]
        print(JSON(parameters))
            
        AppWebservice.shared.request("https://www.paytabs.com/apiv3/prepare_transaction", method: .post, parameters: parameters, headers: nil, loader: true) { (statusCode, response, error) in
            debugPrint(response)

            self.loadingNotification.hide(animated: true)

            if statusCode == 200 {
                        self.json = response!
                        
                        let strStatus: String = self.json["response_code"].stringValue
                        self.strMessage = self.json["result"].stringValue

                        if strStatus == "0900" {
//                            self.webView.isHidden = false

                        } else {
                            Toast(text: self.strMessage).show()
                        }
            } else {
                Toast(text: self.app.RequestTimeOut.localized).show()
            }
        }
    }

    @IBAction func btnAllAction(_ sender: UIButton) {
        if sender.tag == 1 {
            self.strPaymentMethod = "2"
        } else {
            self.strPaymentMethod = "3"
        }
        self.checkPaymentMethod()
    }

    // MARK: - Add Payment Cards API
    func AddPaymentCardsAPI() {
        
        let headers: HTTPHeaders = ["Authorization": self.app.strToken,
                                     "Content-Type": "application/json"]
        print(JSON(headers))

        let parameters: Parameters = ["payment_method": self.strPaymentMethod,
                                      "holder_name": self.strCardHolderName,
                                      "card_number": self.strCardHolderNumber,
                                      "expiry_date": self.strExpireyDate,
                                      "security_number": self.strCVV]
        print(JSON(parameters))

        
        
        AppWebservice.shared.request("\(self.app.BaseURL)add_payment_cards", method: .post, parameters: parameters, headers: headers, loader: true) { (statusCode, response, error) in
            
            if statusCode == 200 {
                        self.json = response!
                        print(self.json)

                        let strStatus: String = self.json["status"].stringValue
                        self.strMessage = self.json["message"].stringValue

                        Toast(text: self.strMessage).show()

                        if strStatus == "1" {
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "CartView"), object: nil, userInfo: nil)

                            self.navigationController?.popViewController(animated: true)
                        }
            } else {
                Toast(text: self.app.RequestTimeOut.localized).show()
            }
        }
    }

    // MARK: - Update Payment Cards API
    func UpdatePaymentCardsAPI() {
        
        let headers: HTTPHeaders = ["Authorization": self.app.strToken,
                                     "Content-Type": "application/json"]
        print(JSON(headers))

        let parameters: Parameters = ["card_id": self.strCardID,
                                      "payment_method": self.strPaymentMethod,
                                      "holder_name": self.strCardHolderName,
                                      "card_number": self.strCardHolderNumber,
                                      "expiry_date": self.strExpireyDate,
                                      "security_number": self.strCVV]
        print(JSON(parameters))

        
            
        AppWebservice.shared.request("\(self.app.BaseURL)edit_card_of_users", method: .post, parameters: parameters, headers: headers, loader: true) { (statusCode, response, error) in
            
            if statusCode == 200 {
                        self.json = response!
                        print(self.json)

                        let strStatus: String = self.json["status"].stringValue
                        self.strMessage = self.json["message"].stringValue

                        Toast(text: self.strMessage).show()

                        if strStatus == "1" {
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "CartView"), object: nil, userInfo: nil)

                            self.navigationController?.popViewController(animated: true)
                        }
            } else {
                Toast(text: self.app.RequestTimeOut.localized).show()
            }
        }
    }

}
