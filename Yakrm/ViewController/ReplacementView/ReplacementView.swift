
//
//  ReplacementView.swift
//  Yakrm
//
//  Created by Krutik V. Poojara on 15/12/18.
//  Copyright © 2018 Krutik V. Poojara. All rights reserved.
//

import UIKit

class ReplacementView: UIViewController
{
    //MARK:- Outlet
    
    @IBOutlet var viewNavigation: UIView!
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var viewBorder: UIView!

    @IBOutlet var lblTop: UILabel!
    @IBOutlet var lblMiddle: UILabel!
    @IBOutlet var lblBottom: UILabel!

    @IBOutlet var viewPopup: UIView!
    @IBOutlet var viewDetails: UIView!
    
    @IBOutlet var btnOK: UIButton!
    
    @IBOutlet var imgProfile: UIImageView!
    @IBOutlet var lblName: UILabel!

    var app = AppDelegate()
    
    var strVoucherID = String()
    var strVoucherPaymentID = String()
    var strImage = String()
    var strName = String()
    var strPrice = String()

    //MAEK: -
    override func viewDidLoad()
    {
        super.viewDidLoad()
        app = UIApplication.shared.delegate as! AppDelegate
        
        self.imgProfile.sd_setImage(with: URL(string: "\(self.app.ImageURL)voucher_images/\(self.strImage)"), placeholderImage: nil)
        self.lblName.text = self.strName
        
        self.viewNavigation.backgroundColor = UIColor.init(rgb: 0xEE4158)
        
        if DeviceType.IS_IPHONE_X || DeviceType.IS_IPHONE_XR
        {
            self.viewNavigation.frame = CGRect(x:self.viewNavigation.frame.origin.x, y: self.viewNavigation.frame.origin.y, width:self.viewNavigation.frame.size.width, height: 88)
            self.scrollView.frame = CGRect(x:self.scrollView.frame.origin.x, y: self.viewNavigation.frame.origin.y + self.viewNavigation.frame.size.height, width:self.scrollView.frame.size.width, height: ScreenSize.SCREEN_HEIGHT - self.viewNavigation.frame.size.height)
        }
        
        self.viewBorder.dropShadow(color: .lightGray, opacity: 1, offSet: CGSize(width: 0, height: 1), radius: 1, scale: true)

        if self.app.isEnglish
        {
            self.lblTop.textAlignment = .left
            self.lblMiddle.textAlignment = .left
            self.lblBottom.textAlignment = .left
            self.lblTitle.textAlignment = .left
        }
        else
        {
            self.lblTop.textAlignment = .right
            self.lblMiddle.textAlignment = .right
            self.lblBottom.textAlignment = .right
            self.lblTitle.textAlignment = .right
        }
        if DeviceType.IS_IPHONE_5
        {
            self.lblTop.font = self.lblTop.font.withSize(15)
            self.lblMiddle.font = self.lblMiddle.font.withSize(15)
            self.lblBottom.font = self.lblBottom.font.withSize(15)
        }
        
        self.btnOK.layer.cornerRadius = 5
        self.viewPopup.isHidden = true
        self.viewDetails.center = self.view.center
    }
    
    @IBAction func btnBack(_ sender: UIButton)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnAllAction(_ sender: UIButton)
    {
        if sender.tag == 1
        {
            let VC = self.storyboard?.instantiateViewController(withIdentifier: "SendView") as! SendView
            VC.strVoucherID = self.strVoucherID
            VC.strVoucherPaymentID = self.strVoucherPaymentID
            VC.strImage = self.strImage
            VC.strName = self.strName
            VC.strPrice = self.strPrice
            self.navigationController?.pushViewController(VC, animated: true)
        }
        else if sender.tag == 2
        {
            let VC = self.storyboard?.instantiateViewController(withIdentifier: "ExchangeView") as! ExchangeView
            VC.strVoucherID = self.strVoucherID
            VC.strVoucherPaymentID = self.strVoucherPaymentID
            VC.strImage = self.strImage
            VC.strName = self.strName
            VC.strPrice = self.strPrice
            self.navigationController?.pushViewController(VC, animated: true)
//            let VC = self.storyboard?.instantiateViewController(withIdentifier: "AmountView") as! AmountView
//            self.navigationController?.pushViewController(VC, animated: true)
        }
        else
        {
            self.viewPopup.frame.origin.y = 0
            ProjectUtility.animatePopupView(viewPopup: self.viewPopup, viewDetails: self.viewDetails)
        }
    }
    
    @IBAction func btnCancel(_ sender: UIButton)
    {
        if sender.tag == 1
        {
            let VC = self.storyboard?.instantiateViewController(withIdentifier: "AuctionView") as! AuctionView
            VC.isMyAuction = true
            self.navigationController?.pushViewController(VC, animated: true)
        }
        else
        {
            self.viewPopup.isHidden = true
        }
    }
    
    @IBAction func btnTermsAction(_ sender: UIButton)
    {
        self.viewPopup.isHidden = true
        let VC = self.storyboard?.instantiateViewController(withIdentifier: "TermsView") as! TermsView
        self.navigationController?.pushViewController(VC, animated: true)
    }
    
    
}
