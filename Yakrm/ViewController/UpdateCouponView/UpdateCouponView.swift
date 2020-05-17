//
//  UpdateCouponView.swift
//  Yakrm
//
//  Created by Krutik V. Poojara on 15/12/18.
//  Copyright © 2018 Krutik V. Poojara. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import MBProgressHUD
import Toaster

@available(iOS 11.0, *)
class UpdateCouponView: UIViewController, UITextFieldDelegate {
    // MARK: - Outlet

    @IBOutlet var viewNavigation: UIView!
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var viewBorder: UIView!

    @IBOutlet var imgProfile: UIImageView!
    @IBOutlet var lblName: UILabel!

    @IBOutlet var txtVoucherNumber: UITextField!
    @IBOutlet var txtPinNumber: UITextField!
    @IBOutlet var txtPrice: UITextField!
    @IBOutlet var txtDate: UITextField!

    @IBOutlet var btnAdd: UIButton!

    var json: JSON!
    var strMessage: String!

    var app = AppDelegate()

    var strVoucherNumber = String()
    var strBrandID = String()
    var strName = String()
    var strImage = String()

    // MARK: -
    override func viewDidLoad() {
        super.viewDidLoad()
        app = UIApplication.shared.delegate as! AppDelegate

        self.viewNavigation.backgroundColor = UIColor.init(rgb: 0xEE4158)

        if json != nil {
            self.strBrandID = json["id"].stringValue
            self.strName = json["brand_name"].stringValue
            self.strImage = json["brand_image"].stringValue
            let strIMAGE: String = strImage.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
            self.imgProfile.sd_setImage(with: URL(string: "\(self.app.ImageURL)brand_images/\(strIMAGE)"), placeholderImage: nil)
        }

        self.lblName.text = strName

        if DeviceType.IS_IPHONE_X || DeviceType.IS_IPHONE_XR {
            self.viewNavigation.frame = CGRect(x: self.viewNavigation.frame.origin.x, y: self.viewNavigation.frame.origin.y, width: self.viewNavigation.frame.size.width, height: 88)
            self.scrollView.frame = CGRect(x: self.scrollView.frame.origin.x, y: self.viewNavigation.frame.origin.y + self.viewNavigation.frame.size.height, width: self.scrollView.frame.size.width, height: ScreenSize.SCREEN_HEIGHT - self.viewNavigation.frame.size.height)
        }

        if DeviceType.IS_IPHONE_5 {
            self.lblName.font = self.lblName.font.withSize(self.lblName.font.pointSize-2)

            self.txtVoucherNumber.font = self.txtVoucherNumber.font!.withSize(self.txtVoucherNumber.font!.pointSize-2)
            self.txtPinNumber.font = self.txtPinNumber.font!.withSize(self.txtPinNumber.font!.pointSize-2)
            self.txtPrice.font = self.txtPrice.font!.withSize(self.txtPrice.font!.pointSize-2)
            self.txtDate.font = self.txtDate.font!.withSize(self.txtDate.font!.pointSize-2)

            self.btnAdd.titleLabel!.font = self.btnAdd.titleLabel!.font.withSize(self.btnAdd.titleLabel!.font.pointSize-2)
        }
        self.viewBorder.dropShadow(color: .lightGray, opacity: 1, offSet: CGSize(width: 0, height: 1), radius: 1, scale: true)

        self.btnAdd.layer.cornerRadius = 5

        self.setTextfildDesign(txt: self.txtVoucherNumber)
        self.setTextfildDesign(txt: self.txtPinNumber)
        self.setTextfildDesign(txt: self.txtPrice)
        self.setTextfildDesign(txt: self.txtDate)

        self.setScrollViewHeight()

        if self.app.isEnglish {
            self.lblTitle.textAlignment = .left
        } else {
            self.lblTitle.textAlignment = .right
//            self.btnAdd.setTitle("إضافة إلى محفظتي", for: .normal)
        }
        self.btnAdd.setTitle("Adding To My Notecase".localized, for: .normal)

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
            txt.textAlignment = .left
            if self.app.isLangEnglish {
                txt.setLeftPaddingPoints(vv)
            } else {
                txt.setRightPaddingPoints(vv)
            }
        } else {
            txt.textAlignment = .right
            if self.app.isLangEnglish {
                txt.setRightPaddingPoints(vv)
            } else {
                txt.setLeftPaddingPoints(vv)
            }
        }
//        txt.placeHolderColor = UIColor.black
        txt.placeHolderColor = UIColor.darkGray.withAlphaComponent(0.5)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField .resignFirstResponder()
        return true
    }

    @IBAction func btnAdd(_ sender: UIButton) {
        self.txtVoucherNumber.resignFirstResponder()
        self.strVoucherNumber = self.txtVoucherNumber.text!
        if self.strVoucherNumber.isEmpty {
            Toast(text: "Please Enter Voucher Number".localized).show()
        } else {
            if self.app.isConnectedToInternet() {
                self.VoucherScanAPI()
            } else {
                Toast(text: self.app.InternetConnectionMessage.localized).show()
            }
        }

    }

    // MARK: - Voucher Scan API
    func VoucherScanAPI() {

        let Char = self.strVoucherNumber.last
        let strLastChar: String = String(Char!)
        var strAddString = String()
        var VoucherNumber = self.strVoucherNumber

        if strLastChar.lowercased() == "g" {
            VoucherNumber = String(VoucherNumber.dropLast())
            strAddString = "@gift_voucher"
        } else if strLastChar.lowercased() == "r" {
            VoucherNumber = String(VoucherNumber.dropLast())
            strAddString = "@replace_voucher"
        } else if strLastChar.lowercased() == "p" {
            VoucherNumber = String(VoucherNumber.dropLast())
            strAddString = "@purchase_voucher"
        }
        VoucherNumber = VoucherNumber + strAddString + "@\(strBrandID)"

        let parameters: Parameters = ["scan_code": VoucherNumber]
        print(JSON(parameters))

        let headers: HTTPHeaders = ["Authorization": self.app.strToken,
                                     "Content-Type": "application/json"]
        print(JSON(headers))
            
        AppWebservice.shared.request("\(self.app.SalesURL)voucher_scan", method: .post, parameters: parameters, headers: headers, loader: true) { (statusCode, response, error) in
            
            if statusCode == 200 {
                        let json = response!
                        print(json)

                        let strStatus: String = json["status"].stringValue
                        self.strMessage = json["message"].stringValue

                        if strStatus == "1" {
                            Toast(text: self.strMessage).show()

                            let VC = self.storyboard?.instantiateViewController(withIdentifier: "AddCouponView") as! AddCouponView
                            VC.strImage = self.strImage
                            VC.strName = self.strName
                            VC.strNumber = self.strVoucherNumber
                            VC.strPinNumber = json["pin_code"].stringValue
                            VC.strPrice = json["voucher_price"].stringValue
                            VC.strDate = json["expired_at"].stringValue
                            self.navigationController?.pushViewController(VC, animated: true)
                            //
                            //                            let desiredViewController = self.navigationController!.viewControllers.filter { $0 is CouponView }.first!
                            //                            self.navigationController!.popToViewController(desiredViewController, animated: true)
                        } else {
                            let alertController = UIAlertController(title: "Yakrm", message: self.strMessage, preferredStyle: .alert)

                            let cancelAction = UIAlertAction(title: "OK", style: .cancel) { (_: UIAlertAction!) in
                                print("you have pressed the Cancel button")
                                //                                self.setupView()
                            }
                            alertController.addAction(cancelAction)
                            self.present(alertController, animated: true, completion: nil)
                        }
            } else {
                Toast(text: self.app.RequestTimeOut.localized).show()
            }
        }
    }

}
