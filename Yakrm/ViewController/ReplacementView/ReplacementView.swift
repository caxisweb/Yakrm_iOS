//
//  ReplacementView.swift
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
class ReplacementView: UIViewController {
    // MARK: - Outlet

    @IBOutlet var viewNavigation: UIView!
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var viewBorder: UIView!

    @IBOutlet var lblTop: UILabel!
    @IBOutlet var lblMiddle: UILabel!
    @IBOutlet var lblBottom: UILabel!
    @IBOutlet var lblRetuern: UILabel!

    @IBOutlet var viewPopup: UIView!
    @IBOutlet var viewDetails: UIView!

    @IBOutlet var btnOK: UIButton!

    @IBOutlet var imgProfile: UIImageView!
    @IBOutlet var lblName: UILabel!

    @IBOutlet var viewReturnPopup: UIView!
    @IBOutlet var viewReturnDetails: UIView!

    @IBOutlet var imgReturnProfile: UIImageView!
    @IBOutlet var lblReturnName: UILabel!
    @IBOutlet var lblReturnPrice: UILabel!
    @IBOutlet var lblReturnWallet: UILabel!

    @IBOutlet var lblReturn: UILabel!
    @IBOutlet var btnReturn: UIButton!

    var app = AppDelegate()
    var json: JSON!
    var strMessage: String!
    var arabMessage: String!
    var strVoucherID = String()
    var strNewVoucherID = String()
    var strVoucherPaymentID = String()
    var strImage = String()
    var strName = String()
    var strPrice = String()
    var strScanVoucherType = String()
    var strScanCode = String()

    // MARK: - Outlet
    override func viewDidLoad() {
        super.viewDidLoad()
        app = UIApplication.shared.delegate as! AppDelegate

        self.imgProfile.sd_setImage(with: URL(string: "\(self.app.ImageURL)voucher_images/\(self.strImage)"), placeholderImage: nil)
        self.lblName.text = self.strName

        self.imgReturnProfile.sd_setImage(with: URL(string: "\(self.app.ImageURL)voucher_images/\(self.strImage)"), placeholderImage: nil)
        self.lblReturnName.text = self.strName

        let Price: Float = Float(self.strPrice)!
        self.lblReturnPrice.text = "\(Price) " + "SR".localized
        let Discount = Price * self.app.AdminProfitDiscount / 100
        let DiscountedPrice = Price - Discount
        self.lblReturn.text = "\(DiscountedPrice) " + "SR".localized

        self.viewNavigation.backgroundColor = UIColor.init(rgb: 0xEE4158)

        if DeviceType.IS_IPHONE_X || DeviceType.IS_IPHONE_XR {
            self.viewNavigation.frame = CGRect(x: self.viewNavigation.frame.origin.x, y: self.viewNavigation.frame.origin.y, width: self.viewNavigation.frame.size.width, height: 88)
            self.scrollView.frame = CGRect(x: self.scrollView.frame.origin.x, y: self.viewNavigation.frame.origin.y + self.viewNavigation.frame.size.height, width: self.scrollView.frame.size.width, height: ScreenSize.SCREEN_HEIGHT - self.viewNavigation.frame.size.height)
        }

        self.viewBorder.dropShadow(color: .lightGray, opacity: 1, offSet: CGSize(width: 0, height: 1), radius: 1, scale: true)

        if self.app.isEnglish {
            self.lblTop.textAlignment = .left
            self.lblMiddle.textAlignment = .left
            self.lblBottom.textAlignment = .left
            self.lblTitle.textAlignment = .left
            self.lblRetuern.textAlignment = .left
        } else {
            self.lblTop.textAlignment = .right
            self.lblMiddle.textAlignment = .right
            self.lblBottom.textAlignment = .right
            self.lblTitle.textAlignment = .right
            self.lblRetuern.textAlignment = .right
//            self.lblRetuern.text = "عودة قسيمة وإضافة المبلغ على رصيدك"
//            self.lblReturnWallet.text = "تتلقى هذا المبلغ في محفظتك عن طريق إعادة هذه القسيمة"
        }

        self.btnReturn.setTitle("Return".localized, for: .normal)
        self.lblRetuern.text = "Return Voucher And Add The Amount On Your Balance".localized
        self.lblReturnWallet.text = "You receive this amount in your Wallet by returning this voucher".localized

        if DeviceType.IS_IPHONE_5 {
            self.lblTop.font = self.lblTop.font.withSize(15)
            self.lblMiddle.font = self.lblMiddle.font.withSize(15)
            self.lblBottom.font = self.lblBottom.font.withSize(15)
            self.lblRetuern.font = self.lblBottom.font.withSize(15)
        }

        self.btnOK.layer.cornerRadius = 5
        self.viewPopup.isHidden = true
        self.viewDetails.center = self.view.center

        self.btnReturn.layer.cornerRadius = 5
        self.viewReturnPopup.isHidden = true
        self.viewReturnDetails.center = self.view.center

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

    @IBAction func btnAllAction(_ sender: UIButton) {
        if sender.tag == 1 {
            let VC = self.storyboard?.instantiateViewController(withIdentifier: "SendView") as! SendView
            VC.strVoucherID = self.strVoucherID
            VC.strVoucherPaymentID = self.strVoucherPaymentID
            VC.strImage = self.strImage
            VC.strName = self.strName
            VC.strPrice = self.strPrice
            VC.strScanVoucherType = self.strScanVoucherType
            self.navigationController?.pushViewController(VC, animated: true)
        } else if sender.tag == 2 {
            if strScanVoucherType.lowercased() == "replace_voucher" {
                let alertController = UIAlertController(title: "Yakrm", message: "Voucher already been replaced, You can't replace it again".localized, preferredStyle: .alert)

                let cancelAction = UIAlertAction(title: "OK".localized, style: .default) { (_: UIAlertAction!) in
                    print("you have pressed the Cancel button")
                }
                alertController.addAction(cancelAction)
                self.present(alertController, animated: true, completion: nil)
            }
//            if self.strVoucherID.isEmpty
//            {
//                let alertController = UIAlertController(title: "Yakrm", message: "Voucher already been replaced, You can't replace it again", preferredStyle: .alert)
//                
//                let cancelAction = UIAlertAction(title: "OK", style: .default)
//                { (action:UIAlertAction!) in
//                    print("you have pressed the Cancel button")
//                }
//                alertController.addAction(cancelAction)
//                self.present(alertController, animated: true, completion:nil)
//            }
            else {
                let VC = self.storyboard?.instantiateViewController(withIdentifier: "ExchangeView") as! ExchangeView
                VC.strVoucherID = self.strVoucherID
                VC.strVoucherPaymentID = self.strVoucherPaymentID
                VC.strImage = self.strImage
                VC.strName = self.strName
                VC.strPrice = self.strPrice
                self.navigationController?.pushViewController(VC, animated: true)
            }
        } else if sender.tag == 3 {
            self.viewPopup.frame.origin.y = 0
            ProjectUtility.animatePopupView(viewPopup: self.viewPopup, viewDetails: self.viewDetails)
        } else {
            self.viewReturnPopup.frame.origin.y = 0
            ProjectUtility.animatePopupView(viewPopup: self.viewReturnPopup, viewDetails: self.viewReturnDetails)
//            let VC = self.storyboard?.instantiateViewController(withIdentifier: "ReturnVoucherView") as! ReturnVoucherView
//            self.navigationController?.pushViewController(VC, animated: true)
        }
    }

    @IBAction func btnCancel(_ sender: UIButton) {
        if sender.tag == 1 {
            self.viewPopup.isHidden = true

            let VC = self.storyboard?.instantiateViewController(withIdentifier: "AuctionView") as! AuctionView
            VC.isMyAuction = true
            self.navigationController?.pushViewController(VC, animated: true)
        } else {
            self.viewPopup.isHidden = true
        }
    }

    @IBAction func btnTermsAction(_ sender: UIButton) {
        self.viewPopup.isHidden = true
        let VC = self.storyboard?.instantiateViewController(withIdentifier: "TermsView") as! TermsView
        self.navigationController?.pushViewController(VC, animated: true)
    }

    @IBAction func btnReturnCancel(_ sender: UIButton) {
        self.viewReturnPopup.isHidden = true
    }

    @IBAction func btnReturn(_ sender: UIButton) {
        if self.app.isConnectedToInternet() {
            self.ReplaceVoucherAPI()
        } else {
            Toast(text: self.app.InternetConnectionMessage.localized).show()
        }
    }

    // MARK: - Replace Voucher API
    func ReplaceVoucherAPI() {

        let headers: HTTPHeaders = ["Authorization": self.app.strToken,
                                     "Content-Type": "application/json"]
        print(JSON(headers))

        let parameters: Parameters = ["scan_voucher_type": self.strScanVoucherType,
                                      "scan_code": self.strScanCode]
        print(JSON(parameters))
    
        AppWebservice.shared.request("\(self.app.BaseURL)voucher_return", method: .post, parameters: parameters, headers: headers, loader: true) { (statusCode, response, error) in

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
                        //Toast(text: self.strMessage).show()
                        if strStatus == "1" {
                            self.app.strWallet = self.json["wallet"].stringValue
                            self.app.defaults.setValue(self.app.strWallet, forKey: "wallet")
                            self.app.defaults.synchronize()

                            let VC = self.storyboard?.instantiateViewController(withIdentifier: "WalletView") as! WalletView
                            VC.isHome = true
                            self.navigationController?.pushViewController(VC, animated: true)
                        }
            } else {
                Toast(text: self.app.RequestTimeOut.localized).show()
            }
        }
    }

}
