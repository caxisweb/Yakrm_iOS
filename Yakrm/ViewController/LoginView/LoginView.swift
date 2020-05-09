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

class LoginView: UIViewController,UITextFieldDelegate
{
    //MARK:- Outlet
    
    @IBOutlet var viewNavigation: UIView!
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var viewBorder: UIView!

    @IBOutlet var txtEmail: UITextField!
    @IBOutlet var txtPassword: UITextField!
    @IBOutlet var btnLogin: UIButton!
    @IBOutlet var btnForgot: UIButton!
    @IBOutlet var btnNewAccount: UIButton!

    
    @IBOutlet var lblStep: UILabel!
    @IBOutlet var lblEmail: UILabel!
    @IBOutlet var lblPassword: UILabel!
    
    
    var loadingNotification : MBProgressHUD!
    var json : JSON!
    var strMessage : String!
    
    var app = AppDelegate()
    
    var strEmail = String()
    var strPassword = String()
    
    var isRegisterd = Bool()
    
    //MARK:-
    override func viewDidLoad()
    {
        super.viewDidLoad()
        app = UIApplication.shared.delegate as! AppDelegate
        
        self.viewNavigation.backgroundColor = UIColor.init(rgb: 0xEE4158)

        self.viewBorder.dropShadow(color: .lightGray, opacity: 1, offSet: CGSize(width: 0, height: 1), radius: 1, scale: true)

        if DeviceType.IS_IPHONE_X || DeviceType.IS_IPHONE_XR
        {
            self.viewNavigation.frame = CGRect(x:self.viewNavigation.frame.origin.x, y: self.viewNavigation.frame.origin.y, width:self.viewNavigation.frame.size.width, height: 88)
            self.scrollView.frame = CGRect(x:self.scrollView.frame.origin.x, y: self.viewNavigation.frame.origin.y + self.viewNavigation.frame.size.height, width:self.scrollView.frame.size.width, height: ScreenSize.SCREEN_HEIGHT - self.viewNavigation.frame.size.height)
        }
        
        if DeviceType.IS_IPHONE_5
        {
            self.txtEmail.font = self.txtEmail.font!.withSize(self.txtEmail.font!.pointSize-1)
            self.txtPassword.font = self.txtPassword.font!.withSize(self.txtPassword.font!.pointSize-1)
            
            self.lblStep.font = self.lblStep.font.withSize(self.lblStep.font.pointSize-2)
            self.lblEmail.font = self.lblEmail.font.withSize(self.lblEmail.font.pointSize-2)
            self.lblPassword.font = self.lblPassword.font.withSize(self.lblPassword.font.pointSize-2)
            self.btnLogin.titleLabel!.font = self.btnLogin.titleLabel!.font.withSize(self.btnLogin.titleLabel!.font.pointSize-2)
            self.btnForgot.titleLabel!.font = self.btnForgot.titleLabel!.font.withSize(self.btnForgot.titleLabel!.font.pointSize-1)
            self.btnNewAccount.titleLabel!.font = self.btnNewAccount.titleLabel!.font.withSize(self.btnNewAccount.titleLabel!.font.pointSize-1)
        }
        
        if self.app.isEnglish
        {
            self.txtEmail.textAlignment = .left
            self.txtPassword.textAlignment = .left
            
            self.lblStep.textAlignment = .left
            self.lblEmail.textAlignment = .left
            self.lblPassword.textAlignment = .left
            self.lblTitle.textAlignment = .left
        }
        else
        {
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
        txt.placeHolderColor = UIColor.darkGray.withAlphaComponent(0.5)
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
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField .resignFirstResponder()
        return true
    }
    
    @IBAction func btnBack(_ sender: UIButton)
    {
        if self.isRegisterd
        {
            let desiredViewController = self.navigationController!.viewControllers.filter { $0 is ViewController }.first!
            self.navigationController!.popToViewController(desiredViewController, animated: true)
        }
        else
        {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func btnAllAction(_ sender: UIButton)
    {
        if sender.tag == 1
        {
            self.txtEmail.resignFirstResponder()
            self.txtPassword.resignFirstResponder()
            
            self.strEmail = self.txtEmail.text!
            self.strPassword = self.txtPassword.text!
            
            if self.strEmail.isEmpty
            {
                Toast(text: "Please Enter Email").show()
            }
            else if self.strEmail.isValidEmail() == false
            {
                Toast(text: "Please Enter Valid Email").show()
            }
            else if self.strPassword.isEmpty
            {
                Toast(text: "Please Enter Password").show()
            }
            else
            {
                if self.app.isConnectedToInternet()
                {
                    self.getLoginAPI()
                }
                else
                {
                    Toast(text: self.app.InternetConnectionMessage).show()
                }
            }
        }
        else if sender.tag == 2
        {
            let VC = self.storyboard?.instantiateViewController(withIdentifier: "NewAccountView") as! NewAccountView
            self.navigationController?.pushViewController(VC, animated: true)
        }
        else
        {

        }
    }
    
    //MARK:- Log In API
    func getLoginAPI()
    {
        loadingNotification = MBProgressHUD.showAdded(to: self.view, animated: false)
        loadingNotification.mode = MBProgressHUDMode.indeterminate
        loadingNotification.label.text = "Loading..."
//        loadingNotification.dimBackground = true
        
        let parameters: Parameters = ["email":self.strEmail,
                                      "password":self.strPassword]
        print(JSON(parameters))
        
        AF.request("\(self.app.BaseURL)login", method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { response in
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
                            self.app.strUserID = self.json["user_id"].stringValue
                            self.app.strName = self.json["name"].stringValue
                            self.app.strEmail = self.json["email"].stringValue
                            self.app.strMobile = self.json["phone"].stringValue
                            self.app.strProfile = self.json["user_profile"].stringValue
                            self.app.strToken = self.json["token"].stringValue
                            self.app.strWallet = self.json["wallet"].stringValue

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
