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
    
    //    var loadingNotification : MBProgressHUD!
    var json : JSON!
    var strMessage : String!
    
    var app = AppDelegate()
    
    var strVoucherID = String()
    var strVoucherPaymentID = String()
    var strImage = String()
    var strName = String()
    var strPrice = String()

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
        }
        self.viewBorder.dropShadow(color: .lightGray, opacity: 1, offSet: CGSize(width: 0, height: 1), radius: 1, scale: true)

        self.strImage = json["voucher_image"].stringValue
        let strDate : String = json["created_at"].stringValue
        self.strPrice = json["voucher_price"].stringValue
        let strVoucherNumber : String = json["scan_code"].stringValue
        let strPinNumber : String = json["pin_code"].stringValue
        self.strVoucherID = json["voucher_id"].stringValue
        self.strVoucherPaymentID = json["voucher_payment_detail_id"].stringValue
        self.strName = json["brand_name"].stringValue

        self.strImage = self.strImage.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        
        self.imgProfile.sd_setImage(with: URL(string: "\(self.app.ImageURL)voucher_images/\(strImage)"), placeholderImage: nil)

        self.imgBarcode.image = Barcode.fromString(string: strVoucherNumber)

        self.lblDate.text = "Voucher Till".localized + " \(self.getDateStringFormate(strDate: strDate))"
        self.lblPrice.text = "\(strPrice) " + "SR".localized

        self.lblVoucherNumber.text = "Voucher Number".localized + ": \(strVoucherNumber)"
        self.lblPinNumber.text = "Pin Number".localized + ": \(strPinNumber)"

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
        self.navigationController?.pushViewController(VC, animated: true)
    }
    

}
