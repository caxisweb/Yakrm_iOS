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

class PaymentMethodView: UIViewController,UITextFieldDelegate
{
    //MARK:- Outlet
    
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

    @IBOutlet var webView: UIWebView!
    
    
    var loadingNotification : MBProgressHUD!
    var json : JSON!
    var strMessage : String!
    
    var app = AppDelegate()


    var strCardHolderName = String()
    var strCardHolderNumber = String()
    var strExpireyDate = String()
    var strCVV = String()
    
    var strFirstName = String()
    var strLastName = String()

    var strMonth = String()
    var strYear = String()

    //MARK:-
    override func viewDidLoad()
    {
        super.viewDidLoad()
        app = UIApplication.shared.delegate as! AppDelegate
        
        self.webView.isHidden = true
        
        self.viewNavigation.backgroundColor = UIColor.init(rgb: 0xEE4158)
        self.btnAdd.layer.cornerRadius = 5

        if DeviceType.IS_IPHONE_X || DeviceType.IS_IPHONE_XR
        {
            self.viewNavigation.frame = CGRect(x:self.viewNavigation.frame.origin.x, y: self.viewNavigation.frame.origin.y, width:self.viewNavigation.frame.size.width, height: 88)
            self.scrollView.frame = CGRect(x:self.scrollView.frame.origin.x, y: self.viewNavigation.frame.origin.y + self.viewNavigation.frame.size.height, width:self.scrollView.frame.size.width, height: ScreenSize.SCREEN_HEIGHT - self.viewNavigation.frame.size.height)
        }
        
        if self.app.isEnglish
        {
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
        }
        else
        {
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
        }
        
        self.setTextfildDesign(txt: self.txtCardHolderName)
        self.setTextfildDesign(txt: self.txtCardHolderNumber)
        self.setTextfildDesign(txt: self.txtExpireDate)
        self.setTextfildDesign(txt: self.txtSecurityNumber)
        
        self.viewTop.backgroundColor = UIColor.white
        self.viewBottom.backgroundColor = UIColor.white
        
        self.viewTop.dropShadow(color: .lightGray, opacity: 1, offSet: CGSize(width: 0, height: 1), radius: 1, scale: true)
        self.viewBottom.dropShadow(color: .lightGray, opacity: 1, offSet: CGSize(width: 0, height: 1), radius: 1, scale: true)
        self.setScrollViewHeight()
        
        self.txtCardHolderNumber.maxLength = 16
        self.txtCardHolderName.maxLength = 25
        self.txtSecurityNumber.maxLength = 3
        self.txtExpireDate.maxLength = 5
        self.txtCardHolderNumber.placeHolderColor = UIColor.darkGray.withAlphaComponent(0.5)
        
        self.txtCardHolderName.text = "Safvan Vhora"
        self.txtCardHolderNumber.text = "4000000000000002"
        self.txtExpireDate.text = "06/21"
        self.txtSecurityNumber.text = "123"
    }
    
    @IBAction func btnBack(_ sender: UIButton)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    func setScrollViewHeight()
    {
        for viewAll: UIView in scrollView.subviews
        {
            if viewAll.tag == 100
            {
                scrollView.contentSize = CGSize(width: CGFloat(scrollView.frame.size.width), height: CGFloat(viewAll.frame.origin.y + viewAll.frame.size.height + 15))
            }
        }
    }
    
    func setTextfildDesign(txt : UITextField)
    {
        txt.layer.borderWidth = 1
        txt.layer.borderColor = UIColor.darkGray.withAlphaComponent(0.5).cgColor
        txt.delegate = self
        let vv = UIView()
        vv.backgroundColor = UIColor.clear
        vv.frame = CGRect(x:0, y: 0, width:10, height: txt.frame.size.height)
        if self.app.isEnglish
        {
            if self.app.isLangEnglish
            {
                txt.setLeftPaddingPoints(vv)
            }
            else
            {
                txt.setRightPaddingPoints(vv)
            }
        }
        else
        {
            if self.app.isLangEnglish
            {
                txt.setRightPaddingPoints(vv)
            }
            else
            {
                txt.setLeftPaddingPoints(vv)
            }
        }
//        if !(txt.placeholder?.isEmpty)!
//        {
//            txt.placeHolderColor = UIColor.darkGray.withAlphaComponent(0.5)
//        }
        txt.backgroundColor = UIColor.white
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField .resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        guard let text = textField.text else
        {
            return true
        }
        let lastText = (text as NSString).replacingCharacters(in: range, with: string) as String
        
        if self.txtCardHolderName == textField
        {
            let ACCEPTABLE_CHARACTERS = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz "
            let cs = NSCharacterSet(charactersIn: ACCEPTABLE_CHARACTERS).inverted
            let filtered = string.components(separatedBy: cs).joined(separator: "")
            
            return (string == filtered)
        }
        else if self.txtCardHolderNumber == textField
        {
//            textField.text = lastText.format("nnnn nnnn nnnn nnnn", oldString: text)
            textField.text = lastText.format("nnnnnnnnnnnnnnnn", oldString: text)
            return false
        }
        else if self.txtExpireDate == textField
        {
            textField.text = lastText.format("nn/nn", oldString: text)
            return false
        }
        return true
    }
    
    @IBAction func btnCompleteAction(_ sender: UIButton)
    {
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

        if self.strCardHolderName.isEmpty
        {
            Toast(text: "Please Enter Name").show()
        }
        else if arrFullName.count < 2
        {
            Toast(text: "Please Enter Full Name").show()
        }
        else if self.strCardHolderNumber.isEmpty
        {
            Toast(text: "Please Enter Card Number").show()
        }
        else if self.strCardHolderNumber.characters.count != 16
        {
            Toast(text: "Please Enter Valid Card Number").show()
        }
        else if self.strExpireyDate.isEmpty
        {
            Toast(text: "Please Enter Expirey Date").show()
        }
        else if self.strExpireyDate.characters.count != 5
        {
            Toast(text: "Please Enter Valid Expirey Date").show()
        }
        else if self.strCVV.isEmpty
        {
            Toast(text: "Please Enter CVV").show()
        }
        else if self.strCVV.characters.count != 3
        {
            Toast(text: "Please Enter Valid CVV").show()
        }
        else
        {
        print(self.strCardHolderName,self.strCardHolderNumber,self.strExpireyDate,self.strCVV)
            self.strFirstName = arrFullName[0]
            self.strLastName = arrFullName[1]
            
            let arrFullDate = self.strExpireyDate.components(separatedBy: "/")
            self.strMonth = arrFullDate[0]
            self.strYear = arrFullDate[1]

            if self.app.isConnectedToInternet()
            {
                self.VoucherPurchaseAPI()
            }
            else
            {
                Toast(text: self.app.InternetConnectionMessage).show()
            }
        }
    }
    
    func VoucherPurchaseAPI()
    {
        loadingNotification = MBProgressHUD.showAdded(to: self.view, animated: false)
        loadingNotification.mode = MBProgressHUDMode.indeterminate
        loadingNotification.label.text = "Loading..."
        loadingNotification.dimBackground = true
        
        let parameters: Parameters = ["secret_key":"ex2SHCqdgtJlrF2gp5fGCis3tUGh5EkjcmcTZD7g6RCxwEOWJ3Cml4qOY664KroXOBQNeY3lPFTlkHh4KUq6YQVXW22HtrFh2w4g",
                                      "merchant_email":"ahmed@yakrm.com",
                                      "amount":"200.00",
                                      "title":"Paytabs",
                                      "cc_first_name":self.strFirstName,
                                      "cc_last_name":self.strLastName,
                                      "card_exp":"\(self.strYear)\(self.strMonth)",
                                      "cvv":strCVV,
                                      "card_number":self.strCardHolderNumber,
                                      "original_assignee_code":"SDK",
                                      "currency":"SAR",
                                      "email":"ahmed@yakrm.com",
                                      "skip_email":"1",
                                      "phone_number":"00966551432252",
                                      "order_id":"123456",
                                      "product_name":"Product 1, Product 2",
                                      "customer_email":"jaypokarjdp@gmail.com",
                                      "country_billing":"BHR",
                                      "address_billing":"Flat 1,Building 123, Road 2345",
                                      "city_billing":"Manama",
                                      "state_billing":"Manama",
                                      "postal_code_billing":"00973",
                                      "country_shipping":"BHR",
                                      "address_shipping":"Flat 1,Building 123, Road 2345",
                                      "city_shipping":"Manama",
                                      "state_shipping":"Manama",
                                      "postal_code_shipping":"00973",
                                      "exchange_rate":"1",
                                      "is_tokenization":"TRUE",
                                      "is_existing_customer":"no",
                                      "pt_token":"null",
                                      "pt_customer_email":"null",
                                      "pt_customer_password":"null"]
        print(JSON(parameters))
        
        Alamofire.request("https://www.paytabs.com/apiv3/prepare_transaction", method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { response in
            debugPrint(response)
            
            self.loadingNotification.hide(animated: true)
            
            if response.response?.statusCode == 200
            {
                if response.result.isSuccess == true
                {
                    if let value = response.result.value
                    {
                        self.json = JSON(value)
                        print(JSON(value))
                        
                        let strStatus : String = self.json["response_code"].stringValue
                        self.strMessage = self.json["result"].stringValue
                        
                        if strStatus == "0900"
                        {
                            self.webView.isHidden = false
                            
                            
                        }
                        else
                        {
                            Toast(text: self.strMessage).show()
                        }
                    }
                }
                else
                {
                    Toast(text: "Request time out.").show()
                }
            }
            else
            {
                print(response.result.error.debugDescription)
                Toast(text: "Request time out.").show()
            }
        }
    }
    

}
