//
//  VarifyNewView.swift
//  Yakrm
//
//  Created by Krutik V. Poojara on 06/12/18.
//  Copyright © 2018 Krutik V. Poojara. All rights reserved.
//

import UIKit
import PinCodeTextField
import Alamofire
import SwiftyJSON
import MBProgressHUD
import Toaster

class VarifyNewView: UIViewController,PinCodeTextFieldDelegate
{
    //MARK:- Outlet
    @IBOutlet var viewNavigation: UIView!
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var viewBorder: UIView!

    @IBOutlet var txtCode: PinCodeTextField!
    
    @IBOutlet var lblDetails: UILabel!
    @IBOutlet var btnCheck: UIButton!
    
    @IBOutlet var lblStep: UILabel!
    @IBOutlet var lblEnterSecret: UILabel!
    
    
    fileprivate lazy var allTextFields: [PinCodeTextField] = {
        let allTextFields: [PinCodeTextField] = [
        ]
        return allTextFields
    }()


    var loadingNotification : MBProgressHUD!
    var json : JSON!
    var strMessage : String!
    
    var app = AppDelegate()
    
    var strOTP = String()
    
    //MARK:-
    override func viewDidLoad()
    {
        super.viewDidLoad()
        app = UIApplication.shared.delegate as! AppDelegate

        self.viewNavigation.backgroundColor = UIColor.init(rgb: 0xEE4158)

        self.btnCheck.layer.cornerRadius = 5

        self.viewBorder.dropShadow(color: .lightGray, opacity: 1, offSet: CGSize(width: 0, height: 1), radius: 1, scale: true)

        if DeviceType.IS_IPHONE_X || DeviceType.IS_IPHONE_XR
        {
            self.viewNavigation.frame = CGRect(x:self.viewNavigation.frame.origin.x, y: self.viewNavigation.frame.origin.y, width:self.viewNavigation.frame.size.width, height: 88)
            self.scrollView.frame = CGRect(x:self.scrollView.frame.origin.x, y: self.viewNavigation.frame.origin.y + self.viewNavigation.frame.size.height, width:self.scrollView.frame.size.width, height: ScreenSize.SCREEN_HEIGHT - self.viewNavigation.frame.size.height)
        }
        
        if DeviceType.IS_IPHONE_5
        {
            self.lblStep.font = self.lblStep.font.withSize(self.lblStep.font.pointSize-2)
            self.lblEnterSecret.font = self.lblEnterSecret.font.withSize(self.lblEnterSecret.font.pointSize-2)
            self.lblDetails.font = self.lblDetails.font.withSize(self.lblDetails.font.pointSize-2)
            self.btnCheck.titleLabel!.font = self.btnCheck.titleLabel!.font.withSize(self.btnCheck.titleLabel!.font.pointSize-1)
        }
        
        if self.app.isEnglish
        {
            self.lblStep.textAlignment = .left
            self.lblEnterSecret.textAlignment = .left
            self.lblTitle.textAlignment = .left
        }
        else
        {
            self.lblStep.textAlignment = .right
            self.lblEnterSecret.textAlignment = .right
            self.lblTitle.textAlignment = .right
        }
        
        self.txtCode.layer.borderWidth = 1
        self.txtCode.layer.borderColor = UIColor.darkGray.withAlphaComponent(0.5).cgColor

        self.txtCode.keyboardType = .numberPad
        self.txtCode.delegate = self
        
        let flexibleButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel".localized, style: .plain, target: self, action: #selector(cancelClicked(_:)))
        
        let doneButton = UIBarButtonItem(title: "Done".localized, style: .plain, target: self, action: #selector(doneClicked(_:)))
        let toolbar = UIToolbar()
        toolbar.items = [cancelButton,flexibleButton, doneButton]
        
        toolbar.sizeToFit()
        
        self.allTextFields.append(txtCode)
        
        self.allTextFields.forEach { (textField) in
            textField.inputAccessoryView = toolbar
        }
        
        let strBy = NSMutableAttributedString(string: "You do not own this mobile ? Change the number".localized)
        strBy.setColorForText("Change the number".localized, with: UIColor.init(rgb: 0xEE4158))
        self.lblDetails.attributedText = strBy

        self.setScrollViewHeight()
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
    
    @IBAction func doneClicked(_ sender: Any)
    {
        self.txtCode.resignFirstResponder()
    }
    
    @IBAction func cancelClicked(_ sender: Any)
    {
        self.txtCode.resignFirstResponder()
    }
    
    @IBAction func btnCheck(_ sender: UIButton)
    {
        self.strOTP = self.txtCode.text!
        if self.strOTP.isEmpty
        {
            Toast(text: "Please Enter OTP").show()
        }
        else
        {
            if self.app.isConnectedToInternet()
            {
                self.VarifyOTPAPI()
            }
            else
            {
                Toast(text: self.app.InternetConnectionMessage).show()
            }
        }
    }
    
    //MARK:- Varify OTP API
    func VarifyOTPAPI()
    {
        loadingNotification = MBProgressHUD.showAdded(to: self.view, animated: false)
        loadingNotification.mode = MBProgressHUDMode.indeterminate
        loadingNotification.label.text = "Loading..."
//        loadingNotification.dimBackground = true
        
        let headers : HTTPHeaders = ["Authorization": self.app.strToken,
                                    "Content-Type": "application/json"]
        
        let parameters: Parameters = ["otp":self.strOTP]
        print(JSON(parameters))
        AF.request("\(self.app.BaseURL)verify_otp", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            debugPrint(response)
            
            self.loadingNotification.hide(animated: true)
            
            if response.response?.statusCode == 200
            {
                if response.result.isSuccess == true
                {
                    if let value = response.result.value
                    {
                        self.json = JSON(value)
                        print(self.json)
                        
                        let strStatus : String = self.json["status"].stringValue
                        self.strMessage = self.json["message"].stringValue
                        
                        if strStatus == "1"
                        {
//                            let VC = self.storyboard?.instantiateViewController(withIdentifier: "RegisterView") as! RegisterView
//                            self.navigationController?.pushViewController(VC, animated: true)
                        }
                        else if strStatus == "2"
                        {
                            let VC = self.storyboard?.instantiateViewController(withIdentifier: "RegisterView") as! RegisterView
                            self.navigationController?.pushViewController(VC, animated: true)
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
