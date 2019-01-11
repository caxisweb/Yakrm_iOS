
//
//  UpdateCouponView.swift
//  Yakrm
//
//  Created by Krutik V. Poojara on 15/12/18.
//  Copyright © 2018 Krutik V. Poojara. All rights reserved.
//

import UIKit

class UpdateCouponView: UIViewController,UITextFieldDelegate
{
    //MARK:- Outlet
    
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
    
    var app = AppDelegate()
    
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
        
        if self.app.isEnglish
        {
            self.lblTitle.textAlignment = .left
        }
        else
        {
            self.lblTitle.textAlignment = .right
        }
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
            txt.textAlignment = .left
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
            txt.textAlignment = .right
            if self.app.isLangEnglish
            {
                txt.setRightPaddingPoints(vv)
            }
            else
            {
                txt.setLeftPaddingPoints(vv)
            }
        }
//        txt.placeHolderColor = UIColor.black
        txt.placeHolderColor = UIColor.darkGray.withAlphaComponent(0.5)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField .resignFirstResponder()
        return true
    }
    
    @IBAction func btnAdd(_ sender: UIButton)
    {
        
    }
    
    
}
