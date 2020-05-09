//
//  AmountView.swift
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

class AmountView: UIViewController
{
    //MARK:- Outlet
    
    @IBOutlet var viewNavigation: UIView!
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var viewBorder: UIView!

    @IBOutlet var imgProfile: UIImageView!
    @IBOutlet var lblName: UILabel!
    @IBOutlet var lblPrice: UILabel!
//    @IBOutlet var lblYOUWILL: UILabel!
//    @IBOutlet var lblAHOWMUCH: UILabel!
//
//    @IBOutlet var txtPrice: UITextField!
    @IBOutlet var btnComplete: UIButton!
    
    @IBOutlet var lblGeneral: UILabel!
    @IBOutlet var lblTextDetails: UILabel!
    
    @IBOutlet var viewTop: UIView!
    @IBOutlet var imgTopProfile: UIImageView!
    @IBOutlet var lblTopName: UILabel!
    @IBOutlet var lblTopPrice: UILabel!

    @IBOutlet var lblWalletAmount: UILabel!
    @IBOutlet var lblTotal: UILabel!

    var app = AppDelegate()
    
    var strVoucherID = String()
    var strVoucherPaymentID = String()
    var strImage = String()
    var strName = String()
    var strPrice = String()

    var loadingNotification : MBProgressHUD!
    var json : JSON!
    var strMessage : String!
    
    var PayPrice = Float()
    var strReplaceVoucherID = String()

    //MARK:-
    override func viewDidLoad()
    {
        super.viewDidLoad()
        app = UIApplication.shared.delegate as! AppDelegate
        
        self.viewNavigation.backgroundColor = UIColor.init(rgb: 0xEE4158)
        
        if DeviceType.IS_IPHONE_X || DeviceType.IS_IPHONE_XR
        {
            self.viewNavigation.frame = CGRect(x:self.viewNavigation.frame.origin.x, y: self.viewNavigation.frame.origin.y, width:self.viewNavigation.frame.size.width, height: 88)
            self.scrollView.frame = CGRect(x:self.scrollView.frame.origin.x, y: self.viewNavigation.frame.origin.y + self.viewNavigation.frame.size.height, width:self.scrollView.frame.size.width, height: ScreenSize.SCREEN_HEIGHT - self.viewNavigation.frame.size.height)
        }

        if DeviceType.IS_IPHONE_5
        {
            self.lblTopName.font = self.lblTopName.font.withSize(15)
            self.lblTopPrice.font = self.lblTopPrice.font.withSize(15)

            self.lblName.font = self.lblName.font.withSize(15)
            self.lblPrice.font = self.lblPrice.font.withSize(15)

            self.lblTotal.font = self.lblTotal.font.withSize(self.lblTotal.font.pointSize-1)
            self.lblWalletAmount.font = self.lblWalletAmount.font.withSize(self.lblWalletAmount.font.pointSize-1)

            self.btnComplete.titleLabel?.font = self.btnComplete.titleLabel?.font.withSize(14)

            self.lblGeneral.font = self.lblGeneral.font.withSize(15)
            self.lblTextDetails.font = self.lblTextDetails.font.withSize(13)
        }
        
        self.viewTop.backgroundColor = UIColor.white
        self.viewBorder.backgroundColor = UIColor.white
        self.viewTop.dropShadow(color: .lightGray, opacity: 1, offSet: CGSize(width: 0, height: 1), radius: 1, scale: true)
        self.viewBorder.dropShadow(color: .lightGray, opacity: 1, offSet: CGSize(width: 0, height: 1), radius: 1, scale: true)

        if self.app.isEnglish
        {
            self.lblName.textAlignment = .left
            self.lblPrice.textAlignment = .left
            self.lblTopName.textAlignment = .left
            self.lblTopPrice.textAlignment = .left
//            self.lblYOUWILL.textAlignment = .left
//            self.lblYOUWILL.textAlignment = .left
            self.lblGeneral.textAlignment = .left
            self.lblTextDetails.textAlignment = .left
            self.lblTitle.textAlignment = .left
        }
        else
        {
            self.lblName.textAlignment = .right
            self.lblPrice.textAlignment = .right
            self.lblTopName.textAlignment = .right
            self.lblTopPrice.textAlignment = .right
//            self.lblYOUWILL.textAlignment = .right
//            self.lblYOUWILL.textAlignment = .right
            self.lblGeneral.textAlignment = .right
            self.lblTextDetails.textAlignment = .right
            self.lblTitle.textAlignment = .right
        }
        let TopPrice : Float = self.json["voucher_price"].floatValue
        self.strReplaceVoucherID = self.json["voucher_id"].stringValue
        self.lblTopName.text = self.json["brand_name"].stringValue
        self.lblTopPrice.text = "\(TopPrice) " + "SR".localized
        var strTopImage : String = self.json["brand_image"].stringValue
        strTopImage = strTopImage.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        self.imgTopProfile.sd_setImage(with: URL(string: "\(self.app.ImageURL)brand_images/\(strTopImage)"), placeholderImage: nil)
        
        self.imgProfile.sd_setImage(with: URL(string: "\(self.app.ImageURL)voucher_images/\(self.strImage)"), placeholderImage: nil)
        self.lblName.text = self.strName

        self.lblPrice.text = self.strPrice + " " + "SR".localized

        self.btnComplete.layer.cornerRadius = 5
        let strYouWill = "You Will Get The Amount Of".localized
        let strSROnly = "8.5 " + "SR Only".localized
        let strBy = NSMutableAttributedString(string: "\(strYouWill) \(strSROnly)")
        strBy.setColorForText(strSROnly, with: UIColor.init(rgb: 0xEE4158))
//        self.lblYOUWILL.attributedText = strBy
        
        var strText = "Here, You Find Vouchers sent By Your Friends".localized + " " + "You Can Transform It Into Wallet Cards And Use It In purchasing And Discount Process".localized
        strText = strText + " " + strText
        self.lblTextDetails.text = strText + "\n\n" + strText
        
//        self.txtPrice.layer.borderWidth = 1
//        self.txtPrice.layer.borderColor = UIColor.darkGray.withAlphaComponent(0.5).cgColor
//        self.txtPrice.placeHolderColor = UIColor.black
//        self.txtPrice.placeHolderColor = UIColor.darkGray.withAlphaComponent(0.5)

        let rectTitle = self.lblTextDetails.text!.boundingRect(with: CGSize(width: CGFloat(self.lblTextDetails.frame.size.width), height: CGFloat(50000)), options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: self.lblTextDetails.font], context: nil)
        
        self.lblTextDetails.frame = CGRect(x: self.lblTextDetails.frame.origin.x, y: self.lblTextDetails.frame.origin.y, width: self.lblTextDetails.frame.size.width, height: (rectTitle.size.height))
        
        self.setScrollViewHeight()
        
        var wallet = Float()
        if self.app.strWallet.isEmpty
        {
            wallet = 0
        }
        else
        {
            wallet = Float(self.app.strWallet)!
        }
        
        let PerPrice : Float = Float(self.strPrice)! * self.app.AdminProfitDiscount / 100
        let FinalValue : Float = Float(self.strPrice)! - PerPrice
        
        if FinalValue < TopPrice //190  300
        {
            PayPrice = TopPrice - FinalValue
            if wallet > 0
            {
                if wallet >= PayPrice
                {
                    PayPrice = 0
                }
                else
                {
                    PayPrice = PayPrice - wallet
                }
            }
        }
        
        self.lblWalletAmount.text = "Wallet amount is " + "\(wallet)" + " and the amount to be paid is :"
        self.lblTotal.text = "\(PayPrice) " + "SR".localized
        
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
    
    @IBAction func btnBack(_ sender: UIButton)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func btnComplete(_ sender: UIButton)
    {
        if self.app.isConnectedToInternet()
        {
            self.ReplaceVoucherAPI()
        }
        else
        {
            Toast(text: self.app.InternetConnectionMessage).show()
        }
    }
    
    //MARK:- Replace Voucher API
    func ReplaceVoucherAPI()
    {
        loadingNotification = MBProgressHUD.showAdded(to: self.view, animated: false)
        loadingNotification.mode = MBProgressHUDMode.indeterminate
        loadingNotification.label.text = "Loading..."
//        loadingNotification.dimBackground = true
        
        let headers : HTTPHeaders = ["Authorization": self.app.strToken,
                                     "Content-Type": "application/json"]
        print(JSON(headers))
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let myString = formatter.string(from: Date()) // string purpose I add here
        let yourDate = formatter.date(from: myString)
        formatter.dateFormat = "yyyyMMddHHmmss"
        let strTransactionID = formatter.string(from: yourDate!)
        
        let parameters: Parameters = ["replace_active_voucher_id":strVoucherID,
                                      "voucher_payment_detail_id":strVoucherPaymentID,
                                      "replace_voucher_id":strReplaceVoucherID,
                                      "transaction_id":strTransactionID,
                                      "transaction_price":self.PayPrice]
        print(JSON(parameters))
        
        AF.request("\(self.app.BaseURL)replace_voucher", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
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
                        
                        Toast(text: self.strMessage).show()
                        if strStatus == "1"
                        {
                            let desiredViewController = self.navigationController!.viewControllers.filter { $0 is HomeView }.first!
                            self.navigationController!.popToViewController(desiredViewController, animated: true)
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
