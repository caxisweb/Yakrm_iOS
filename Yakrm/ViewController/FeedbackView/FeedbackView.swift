//
//  FeedbackView.swift
//  Yakrm
//
//  Created by Krutik V. Poojara on 17/12/18.
//  Copyright © 2018 Krutik V. Poojara. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import MBProgressHUD
import Toaster

@available(iOS 11.0, *)
@available(iOS 11.0, *)
class FeedbackView: UIViewController, UITextFieldDelegate, UITextViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate {
    // MARK: - Outlet
    @IBOutlet var viewNavigation: UIView!
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var viewBorder: UIView!

    @IBOutlet var txtEmail: UITextField!
    @IBOutlet var txtSubject: UITextField!
    @IBOutlet var viewSubject: UIView!
    @IBOutlet var txtMessage: UITextView!

    @IBOutlet var btnSend: UIButton!

    @IBOutlet var lblQUE: UILabel!
    @IBOutlet var lblEMAIL: UILabel!
    @IBOutlet var lblTITLE: UILabel!
    @IBOutlet var lblDETAILS: UILabel!

    var loadingNotification: MBProgressHUD!
    var json: JSON!
    var strMessage: String!

    var app = AppDelegate()

    let salutations = ["New Ideas", "New Ideas", "New Ideas", "New Ideas"]

    var strEmail = String()
    var strSubject = String()
    var strDetails = String()

    // MARK: -
    override func viewDidLoad() {
        super.viewDidLoad()
        app = UIApplication.shared.delegate as! AppDelegate

        self.viewNavigation.backgroundColor = UIColor.init(rgb: 0xEE4158)

        self.txtEmail.text = self.app.strEmail

        if DeviceType.IS_IPHONE_X || DeviceType.IS_IPHONE_XR {
            self.viewNavigation.frame = CGRect(x: self.viewNavigation.frame.origin.x, y: self.viewNavigation.frame.origin.y, width: self.viewNavigation.frame.size.width, height: 88)
            self.scrollView.frame = CGRect(x: self.scrollView.frame.origin.x, y: self.viewNavigation.frame.origin.y + self.viewNavigation.frame.size.height, width: self.scrollView.frame.size.width, height: ScreenSize.SCREEN_HEIGHT - self.viewNavigation.frame.size.height)
        }

        if DeviceType.IS_IPHONE_5 {
            self.lblQUE.font = self.lblQUE.font.withSize(self.lblQUE.font.pointSize-2)
            self.lblEMAIL.font = self.lblEMAIL.font.withSize(self.lblEMAIL.font.pointSize-1)
            self.lblTITLE.font = self.lblTITLE.font.withSize(self.lblDETAILS.font.pointSize-1)
            self.lblDETAILS.font = self.lblDETAILS.font.withSize(self.lblDETAILS.font.pointSize-1)

            self.txtEmail.font = self.txtEmail.font!.withSize(self.txtEmail.font!.pointSize-2)
            self.txtSubject.font = self.txtSubject.font!.withSize(self.txtSubject.font!.pointSize-2)
            self.txtMessage.font = self.txtMessage.font!.withSize(self.txtMessage.font!.pointSize-2)

            self.btnSend.titleLabel!.font = self.btnSend.titleLabel!.font.withSize(self.btnSend.titleLabel!.font.pointSize-2)
        }

        self.viewBorder.dropShadow(color: .lightGray, opacity: 1, offSet: CGSize(width: 0, height: 1), radius: 1, scale: true)

        if self.app.isEnglish {
            self.lblEMAIL.textAlignment = .left
            self.lblTITLE.textAlignment = .left
            self.lblDETAILS.textAlignment = .left

            self.txtEmail.textAlignment = .left
            self.txtSubject.textAlignment = .left
            self.txtMessage.textAlignment = .left
            self.lblTitle.textAlignment = .left
        } else {
            self.lblEMAIL.textAlignment = .right
            self.lblTITLE.textAlignment = .right
            self.lblDETAILS.textAlignment = .right

            self.txtEmail.textAlignment = .right
            self.txtSubject.textAlignment = .right
            self.txtMessage.textAlignment = .right
            self.lblTitle.textAlignment = .right

//            self.lblTitle.text = "التواصل والدعم"
        }
        self.lblTitle.text = "Contact And Support".localized

        self.btnSend.layer.cornerRadius = 5

        self.setTextfildDesign(txt: self.txtEmail, vv: self.viewSubject, addView: false)
        self.setTextfildDesign(txt: self.txtSubject, vv: self.viewSubject, addView: false)
        self.viewSubject.isHidden = true

        self.txtMessage.layer.borderWidth = 1
        self.txtMessage.layer.borderColor = UIColor.darkGray.withAlphaComponent(0.5).cgColor
        self.txtMessage.delegate = self
        self.txtMessage.backgroundColor = UIColor.clear

//        let pickerView = UIPickerView()
//        pickerView.delegate = self
//        self.txtSubject.inputView = pickerView

        self.setScrollViewHeight()
    }

    func setTextfildDesign(txt: UITextField, vv: UIView, addView: Bool) {
        txt.layer.borderWidth = 1
        txt.layer.borderColor = UIColor.darkGray.withAlphaComponent(0.5).cgColor
        txt.delegate = self
        let VV = UIView()
        VV.backgroundColor = UIColor.clear
        VV.frame = CGRect(x: 0, y: 0, width: 10, height: txt.frame.size.height)
        if self.app.isEnglish {
            if self.app.isLangEnglish {
                if addView {
                    txt.setRightPaddingPoints(vv)
                }
                txt.setLeftPaddingPoints(VV)
            } else {
                if addView {
                    txt.setLeftPaddingPoints(vv)
                }
                txt.setRightPaddingPoints(VV)
            }
            txt.textAlignment = .left
        } else {
            if self.app.isLangEnglish {
                if addView {
                    txt.setLeftPaddingPoints(vv)
                }
                txt.setRightPaddingPoints(VV)
            } else {
                if addView {
                    txt.setRightPaddingPoints(vv)
                }
                txt.setLeftPaddingPoints(VV)
            }
            txt.textAlignment = .right
        }
//        txt.placeHolderColor = UIColor.black
        txt.placeHolderColor = UIColor.darkGray.withAlphaComponent(0.5)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField .resignFirstResponder()
        return true
    }

    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        return true
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

    @available(iOS 11.0, *)
    @IBAction func btnSend(_ sender: UIButton) {
        self.txtEmail.resignFirstResponder()
        self.txtSubject.resignFirstResponder()
        self.txtMessage.resignFirstResponder()

        self.strEmail = self.txtEmail.text!
        self.strSubject = self.txtSubject.text!
        self.strMessage = self.txtMessage.text!

        if self.strEmail.isEmpty {
            Toast(text: "Please Enter Email".localized).show()
        } else if self.strEmail.isValidEmail() == false {
            Toast(text: "Please Enter Valid Email".localized).show()
        } else if self.strSubject.isEmpty {
            Toast(text: "Please Enter Message Title".localized).show()
        } else if self.strMessage.isEmpty {
            Toast(text: "Please Enter Message Details".localized).show()
        } else {
            if self.app.isConnectedToInternet() {
                self.AddFeedbackAPI()
            } else {
                Toast(text: self.app.InternetConnectionMessage.localized).show()
            }
        }
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return salutations.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return salutations[row]
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.txtSubject.text = salutations[row]
    }

    // MARK: - Sign Up API
    @available(iOS 11.0, *)
    func AddFeedbackAPI() {

        let headers: HTTPHeaders = ["Authorization": self.app.strToken,
                                     "Content-Type": "application/json"]

        let parameters: Parameters = ["email": self.strEmail,
                                      "title": self.strSubject,
                                      "description": self.strMessage]
        print(JSON(parameters))

        
        AppWebservice.shared.request("\(self.app.BaseURL)add_feedback", method: .post, parameters: parameters, headers: headers, loader: true) { (statusCode, response, error) in


            if statusCode == 200 {
                        self.json = response!
                        print(self.json)

                        let strStatus: String = self.json["status"].stringValue
                        self.strMessage = self.json["message"].stringValue

                        Toast(text: self.strMessage).show()

                        if strStatus == "1" {
                            let desiredViewController = self.navigationController!.viewControllers.filter { $0 is HomeView }.first!
                            self.navigationController!.popToViewController(desiredViewController, animated: true)
                        }
            } else {
                Toast(text: self.app.RequestTimeOut.localized).show()
            }
        }
    }

}
