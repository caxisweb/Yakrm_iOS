//
//  StarbucksCardView.swift
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
class StarbucksCardView: UIViewController
{
    //MARK:- Outlet
    @IBOutlet var viewNavigation: UIView!
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var viewBorder: UIView!

    @IBOutlet var imgProfile: UIImageView!
    @IBOutlet var lblDate: UILabel!
    @IBOutlet var lblPrice: UILabel!

    @IBOutlet var lblVoucherNumber: UILabel!
    @IBOutlet var lblPinNumber: UILabel!
    @IBOutlet var imgBarcode: UIImageView!

    @IBOutlet var lblDetails: UILabel!
    @IBOutlet var lblGeneral: UILabel!

    @IBOutlet var btnReplaceVoucher: UIButton!
    
    @IBOutlet var lblVoucherDesc: UILabel!
    @IBOutlet var imgLogo: UIImageView!
    //    var loadingNotification : MBProgressHUD!
    var json : JSON!
    var strMessage : String!
    
    var app = AppDelegate()
    
    var strVoucherID = String()
    var strNewVoucherID = String()
    var strVoucherPaymentID = String()
    var strImage = String()
    var strName = String()
    var strPrice = String()
    var strScanVoucherType = String()
    var strScanCode = String()
    
    var isReceived = Bool()
    //MARK:-
    override func viewDidLoad()
    {
        super.viewDidLoad()
        app = UIApplication.shared.delegate as! AppDelegate

        self.viewNavigation.backgroundColor = UIColor.init(rgb: 0xEE4158)
        self.btnReplaceVoucher.layer.cornerRadius = 5

        if DeviceType.IS_IPHONE_X || DeviceType.IS_IPHONE_XR
        {
            self.viewNavigation.frame = CGRect(x:self.viewNavigation.frame.origin.x, y: self.viewNavigation.frame.origin.y, width:self.viewNavigation.frame.size.width, height: 88)
            self.scrollView.frame = CGRect(x:self.scrollView.frame.origin.x, y: self.viewNavigation.frame.origin.y + self.viewNavigation.frame.size.height, width:self.scrollView.frame.size.width, height: ScreenSize.SCREEN_HEIGHT - self.viewNavigation.frame.size.height)
        }
        
        if DeviceType.IS_IPHONE_5
        {
            self.lblDate.font = self.lblDate.font.withSize(12)
            self.lblPrice.font = self.lblPrice.font.withSize(12)
            
            self.lblVoucherNumber.font = self.lblVoucherNumber.font.withSize(15)
            self.lblPinNumber.font = self.lblPinNumber.font.withSize(12)

            self.lblGeneral.font = self.lblGeneral.font.withSize(14)
            self.lblDetails.font = self.lblDetails.font.withSize(12)
            self.btnReplaceVoucher.titleLabel!.font = self.btnReplaceVoucher.titleLabel!.font.withSize(self.btnReplaceVoucher.titleLabel!.font.pointSize-1)
        }
        
        if self.app.isEnglish
        {
            self.lblGeneral.textAlignment = .left
            self.lblDetails.textAlignment = .left
            self.lblTitle.textAlignment = .left
        }
        else
        {
            self.lblGeneral.textAlignment = .right
            self.lblDetails.textAlignment = .right
            self.lblTitle.textAlignment = .right
            
//            self.lblGeneral.text = "تعليمات عامة"
//            self.btnReplaceVoucher.setTitle("استبدل القسيمة", for: .normal)
            self.lblDetails.text = "هنا تجد قسائم الخصم المرسلة من أصدقائك" + "ويمكنك نقلها إلى محفظة الكروت واستغلالها في الشراء والخصومات"
        }
        self.lblGeneral.text = "General instructions".localized
        self.btnReplaceVoucher.setTitle("Replace Voucher".localized, for: .normal)
//        self.lblDetails.text = "هنا تجد قسائم الخصم المرسلة من أصدقائك" + "ويمكنك نقلها إلى محفظة الكروت واستغلالها في الشراء والخصومات"

        print(self.json)
        
        self.strImage = json["voucher_image"].stringValue
        let strDate : String = json["created_at"].stringValue
        self.strPrice = json["voucher_price"].stringValue
        self.strScanCode = json["scan_code"].stringValue
        var strScanVoucherType : String = json["scan_voucher_type"].stringValue
        self.strScanVoucherType = json["scan_voucher_type"].stringValue
        
        self.strVoucherID = json["voucher_id"].stringValue
        self.strNewVoucherID = json["new_voucher_id"].stringValue
        self.strVoucherPaymentID = json["voucher_payment_detail_id"].stringValue
        let strVoucherDesc = json["voucher_description"].stringValue

        if strScanVoucherType.lowercased() == "gift_voucher"
        {
            strScanVoucherType = "g"
//            self.isReceived = true
        }
        else if strScanVoucherType.lowercased() == "replace_voucher"
        {
            strScanVoucherType = "r"
            self.strVoucherID = json["new_voucher_id"].stringValue
            self.strVoucherPaymentID = json["replace_voucher_payment_id"].stringValue
        }
        else if strScanVoucherType.lowercased() == "purchase_voucher"
        {
            strScanVoucherType = "p"
        }
        let strPinNumber : String = json["pin_code"].stringValue

        self.strName = json["brand_name"].stringValue
        let arabName : String = self.json["brand_name_arab"].stringValue
        
        if self.app.strLanguage == "ar"
        {
            self.app.isEnglish = false
            self.lblTitle.text = arabName
                       
            if arabName.isEmpty{
                           self.lblTitle.text = strName
            }
        }else
        {
            self.app.isEnglish = true
            self.lblTitle.text = strName
        }
        
       // self.lblTitle.text = self.strName
        
        self.strImage = self.strImage.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        
        self.imgProfile.sd_setImage(with: URL(string: "\(self.app.ImageURL)voucher_images/\(strImage)"), placeholderImage: nil)

        self.imgBarcode.image = Barcode.fromString(string: "\(strScanCode)\(strScanVoucherType)")

        self.lblDate.text = "Voucher Till".localized + " \(self.getDateStringFormate(strDate: strDate))"
        self.lblPrice.text = "\(strPrice) " + "SR".localized

        self.lblVoucherNumber.text = "Voucher Number".localized + ": \(strScanCode)\(strScanVoucherType)"
        self.lblPinNumber.text = "Pin Number".localized + ": \(strPinNumber)"
        self.lblVoucherDesc.text = strVoucherDesc

        var Y = self.lblPinNumber.frame.origin.y + self.lblPinNumber.frame.size.height + 5
        if self.lblVoucherDesc.text!.isEmpty
        {
            Y = Y + 5
        }
        else
        {
            let rectDesc = self.lblVoucherDesc.text!.boundingRect(with: CGSize(width: self.lblVoucherDesc.frame.size.width, height: CGFloat(50000)), options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: self.lblVoucherDesc.font], context: nil)
            self.lblVoucherDesc.frame = CGRect(x: self.lblVoucherDesc.frame.origin.x, y: Y, width: self.lblVoucherDesc.frame.size.width, height: rectDesc.height)
            Y = self.lblVoucherDesc.frame.origin.y + self.lblVoucherDesc.frame.size.height + 10
        }
        self.imgBarcode.frame = CGRect(x: self.imgBarcode.frame.origin.x, y: Y, width: self.imgBarcode.frame.size.width, height: self.imgBarcode.frame.size.height)

        self.btnReplaceVoucher.frame = CGRect(x: self.btnReplaceVoucher.frame.origin.x, y: self.imgBarcode.frame.origin.y + self.imgBarcode.frame.size.height + 20, width: self.btnReplaceVoucher.frame.size.width, height: self.btnReplaceVoucher.frame.size.height)

        self.imgLogo.frame = CGRect(x: self.imgLogo.frame.origin.x, y: self.btnReplaceVoucher.frame.origin.y + self.btnReplaceVoucher.frame.size.height + 10, width: self.imgLogo.frame.size.width, height: self.imgLogo.frame.size.height)

        self.viewBorder.frame = CGRect(x: self.viewBorder.frame.origin.x, y: self.viewBorder.frame.origin.y, width: self.viewBorder.frame.size.width, height: self.imgLogo.frame.origin.y + self.imgLogo.frame.size.height + 10)

        self.lblGeneral.frame = CGRect(x: self.lblGeneral.frame.origin.x, y: self.viewBorder.frame.origin.y + self.viewBorder.frame.size.height + 15, width: self.lblGeneral.frame.size.width, height: self.lblGeneral.frame.size.height)
        
        let rectDetails = self.lblDetails.text!.boundingRect(with: CGSize(width: self.lblDetails.frame.size.width, height: CGFloat(50000)), options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: self.lblDetails.font], context: nil)
        
        var DetailsHeight = self.lblDetails.frame.size.height
        if rectDetails.height > DetailsHeight
        {
            DetailsHeight = rectDetails.height
        }
        self.lblDetails.frame = CGRect(x: self.lblDetails.frame.origin.x, y: self.lblGeneral.frame.origin.y + self.lblGeneral.frame.size.height + 5, width: self.lblDetails.frame.size.width, height: DetailsHeight)
        
        if self.isReceived
        {
            self.btnReplaceVoucher.isUserInteractionEnabled = false
            self.btnReplaceVoucher.alpha = 0.7
        }
        
        self.viewBorder.dropShadow(color: .lightGray, opacity: 1, offSet: CGSize(width: 0, height: 1), radius: 1, scale: true)
        
        self.setScrollViewHeight()
    }
    
    func getDateStringFormate(strDate : String) -> String
    {
        var strFullDate = String()
        if strDate.isEmpty
        {
            return strFullDate
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = dateFormatter.date(from: strDate)
        if date != nil
        {
            dateFormatter.dateFormat = "dd MMMM yyyy"
            strFullDate = dateFormatter.string(from: date!)
        }
        
        return strFullDate
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
    
    @IBAction func btnAllAction(_ sender: UIButton)
    {
        let VC = self.storyboard?.instantiateViewController(withIdentifier: "ReplacementView") as! ReplacementView
        VC.strVoucherID = self.strVoucherID
        VC.strVoucherPaymentID = self.strVoucherPaymentID
        VC.strImage = self.strImage
        VC.strName = self.strName
        VC.strPrice = self.strPrice
        VC.strScanVoucherType = self.strScanVoucherType
        VC.strScanCode = self.strScanCode
        self.navigationController?.pushViewController(VC, animated: true)
    }
    

}
