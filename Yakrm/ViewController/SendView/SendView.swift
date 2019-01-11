//
//  SendView.swift
//  Yakrm
//
//  Created by Krutik V. Poojara on 15/12/18.
//  Copyright © 2018 Krutik V. Poojara. All rights reserved.
//

import UIKit

class SendView: UIViewController,UITextFieldDelegate,UITextViewDelegate
{
    //MARK:- Outlet
    @IBOutlet var viewNavigation: UIView!
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var viewBorder: UIView!

    @IBOutlet var imgProfile: UIImageView!
    @IBOutlet var lblName: UILabel!
    @IBOutlet var lblPrice: UILabel!
    
    
    @IBOutlet var txtNumber: UITextField!
    @IBOutlet var viewSearch: UIView!
    
    @IBOutlet var lblFriendInfo: UILabel!
    @IBOutlet var lblFriendsName: UILabel!
    @IBOutlet var lblEmail: UILabel!
    
    
    @IBOutlet var txtSendingData: UITextField!
    @IBOutlet var txtMessage: UITextView!
    
    @IBOutlet var btnVideo: UIButton!
    
    @IBOutlet var btnComplete: UIButton!
    
    var app = AppDelegate()
    

    //MARK:-
    override func viewDidLoad()
    {
        super.viewDidLoad()
        app = UIApplication.shared.delegate as! AppDelegate
        
        self.viewNavigation.backgroundColor = UIColor.init(rgb: 0xEE4158)
        self.txtNumber.maxLength = 12

        if DeviceType.IS_IPHONE_X || DeviceType.IS_IPHONE_XR
        {
            self.viewNavigation.frame = CGRect(x:self.viewNavigation.frame.origin.x, y: self.viewNavigation.frame.origin.y, width:self.viewNavigation.frame.size.width, height: 88)
            self.scrollView.frame = CGRect(x:self.scrollView.frame.origin.x, y: self.viewNavigation.frame.origin.y + self.viewNavigation.frame.size.height, width:self.scrollView.frame.size.width, height: ScreenSize.SCREEN_HEIGHT - self.viewNavigation.frame.size.height)
        }
        
        self.viewBorder.dropShadow(color: .lightGray, opacity: 1, offSet: CGSize(width: 0, height: 1), radius: 1, scale: true)

        if self.app.isEnglish
        {
            self.lblName.textAlignment = .left
            self.lblPrice.textAlignment = .left

            self.lblFriendInfo.textAlignment = .left
            self.lblFriendsName.textAlignment = .left
            self.lblEmail.textAlignment = .left

            self.txtNumber.textAlignment = .left
            self.txtSendingData.textAlignment = .left
            self.txtMessage.textAlignment = .left
            self.lblTitle.textAlignment = .left
        }
        else
        {
            self.lblName.textAlignment = .right
            self.lblPrice.textAlignment = .right

            self.lblFriendInfo.textAlignment = .right
            self.lblFriendsName.textAlignment = .right
            self.lblEmail.textAlignment = .right

            self.txtNumber.textAlignment = .right
            self.txtSendingData.textAlignment = .right
            self.txtMessage.textAlignment = .right
            self.lblTitle.textAlignment = .right
        }
        if DeviceType.IS_IPHONE_5
        {
            self.lblName.font = self.lblName.font.withSize(15)
            self.lblPrice.font = self.lblPrice.font.withSize(15)
            
            self.txtNumber.font = self.txtNumber.font!.withSize(15)
            
            self.lblFriendInfo.font = self.lblFriendInfo.font.withSize(15)
            self.lblFriendsName.font = self.lblFriendsName.font.withSize(15)
            self.lblEmail.font = self.lblEmail.font.withSize(15)

            self.txtSendingData.font = self.txtSendingData.font!.withSize(15)
            self.txtMessage.font = self.txtMessage.font!.withSize(15)
            
            self.btnVideo.titleLabel?.font = self.btnVideo.titleLabel?.font.withSize(13)
            self.btnComplete.titleLabel?.font = self.btnComplete.titleLabel?.font.withSize(15)
        }
        
        self.lblPrice.text = "123 " + "Rs".localized
        self.lblFriendsName.text = "Name".localized + ":Mahmoud Abdel Mattal"
        self.lblEmail.text = "Email Address".localized + ":email@domain.dlt"
        
        self.txtMessage.text = "Hello Friend. I Am Sending You This Voucher To Express My Love And Gratitude For You As A Friend I Hope That You Will Be Happy During Every Single Moment Of Your Life".localized
        
        self.btnComplete.layer.cornerRadius = 5
        
        self.setTextfildDesign(txt: self.txtNumber, vv: self.viewSearch, addView: true)
        self.setTextfildDesign(txt: self.txtSendingData, vv: self.viewSearch, addView: false)

        self.txtMessage.layer.borderWidth = 1
        self.txtMessage.layer.borderColor = UIColor.darkGray.withAlphaComponent(0.5).cgColor
        self.txtMessage.delegate = self
        self.txtMessage.backgroundColor = UIColor.clear

        self.setScrollViewHeight()
    }
    
    func setTextfildDesign(txt : UITextField, vv : UIView, addView : Bool)
    {
        txt.layer.borderWidth = 1
        txt.layer.borderColor = UIColor.darkGray.withAlphaComponent(0.5).cgColor
        txt.delegate = self
        let VV = UIView()
        VV.backgroundColor = UIColor.clear
        VV.frame = CGRect(x:0, y: 0, width:10, height: txt.frame.size.height)
        if self.app.isEnglish
        {
            txt.textAlignment = .left
            if self.app.isLangEnglish
            {
                if addView
                {
                    txt.setRightPaddingPoints(vv)
                }
                txt.setLeftPaddingPoints(VV)
            }
            else
            {
                if addView
                {
                    txt.setLeftPaddingPoints(vv)
                }
                txt.setRightPaddingPoints(VV)
            }
        }
        else
        {
            if self.app.isLangEnglish
            {
                if addView
                {
                    txt.setLeftPaddingPoints(vv)
                }
                txt.setRightPaddingPoints(VV)
            }
            else
            {
                if addView
                {
                    txt.setRightPaddingPoints(vv)
                }
                txt.setLeftPaddingPoints(VV)
            }
            txt.textAlignment = .right
        }
//        txt.placeHolderColor = UIColor.black
        txt.placeHolderColor = UIColor.darkGray.withAlphaComponent(0.5)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField .resignFirstResponder()
        return true
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool
    {
        if(text == "\n")
        {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
//    func textViewDidChange(_ textView: UITextView)
//    {
//        if self.txtMessage.text.isEmpty
//        {
//            self.txtMessage.text = "Hello Friend. I Am Sending You This Voucher To Express My Love And Gratitude For You As A Friend I Hope That You Will Be Happy During Every Single Moment Of Your Life".localized
//        }
//        else
//        {
//
//        }
//    }
    func textViewDidBeginEditing(_ textView: UITextView)
    {
        if self.txtMessage.text == "Hello Friend. I Am Sending You This Voucher To Express My Love And Gratitude For You As A Friend I Hope That You Will Be Happy During Every Single Moment Of Your Life".localized
        {
            self.txtMessage.text = ""
        }
    }

    func textViewDidEndEditing(_ textView: UITextView)
    {
        if self.txtMessage.text.isEmpty
        {
            self.txtMessage.text = "Hello Friend. I Am Sending You This Voucher To Express My Love And Gratitude For You As A Friend I Hope That You Will Be Happy During Every Single Moment Of Your Life".localized
        }
    }
    
    func setScrollViewHeight()
    {
        for viewAll: UIView in scrollView.subviews
        {
            if viewAll.tag == 101
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

    }
    
    
    
}
