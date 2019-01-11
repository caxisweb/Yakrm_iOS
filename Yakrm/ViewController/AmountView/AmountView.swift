//
//  AmountView.swift
//  Yakrm
//
//  Created by Krutik V. Poojara on 15/12/18.
//  Copyright © 2018 Krutik V. Poojara. All rights reserved.
//

import UIKit

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
    @IBOutlet var lblYOUWILL: UILabel!
    @IBOutlet var lblAHOWMUCH: UILabel!
    
    @IBOutlet var txtPrice: UITextField!
    @IBOutlet var btnComplete: UIButton!
    
    @IBOutlet var lblGeneral: UILabel!
    @IBOutlet var lblTextDetails: UILabel!
    
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
            self.lblName.font = self.lblName.font.withSize(15)
            self.lblPrice.font = self.lblPrice.font.withSize(15)
            
            self.lblAHOWMUCH.font = self.lblAHOWMUCH.font.withSize(12)
            self.lblYOUWILL.font = self.lblYOUWILL.font.withSize(12)

            self.txtPrice.font = self.txtPrice.font!.withSize(15)
            
            self.btnComplete.titleLabel?.font = self.btnComplete.titleLabel?.font.withSize(15)

            self.lblGeneral.font = self.lblGeneral.font.withSize(15)
            self.lblTextDetails.font = self.lblTextDetails.font.withSize(13)
        }
        self.viewBorder.dropShadow(color: .lightGray, opacity: 1, offSet: CGSize(width: 0, height: 1), radius: 1, scale: true)

        if self.app.isEnglish
        {
            self.lblName.textAlignment = .left
            self.lblPrice.textAlignment = .left
            self.lblYOUWILL.textAlignment = .left
            self.lblYOUWILL.textAlignment = .left
            self.lblGeneral.textAlignment = .left
            self.lblTextDetails.textAlignment = .left
            self.lblTitle.textAlignment = .left
        }
        else
        {
            self.lblName.textAlignment = .right
            self.lblPrice.textAlignment = .right
            self.lblYOUWILL.textAlignment = .right
            self.lblYOUWILL.textAlignment = .right
            self.lblGeneral.textAlignment = .right
            self.lblTextDetails.textAlignment = .right
            self.lblTitle.textAlignment = .right
        }
        self.lblPrice.text = "50" + "SR".localized

        self.btnComplete.layer.cornerRadius = 5
        let strYouWill = "You Will Get The Amount Of".localized
        let strSROnly = "8.5 " + "SR Only".localized
        let strBy = NSMutableAttributedString(string: "\(strYouWill) \(strSROnly)")
        strBy.setColorForText(strSROnly, with: UIColor.init(rgb: 0xEE4158))
        self.lblYOUWILL.attributedText = strBy
        
        var strText = "Here, You Find Vouchers sent By Your Friends".localized + " " + "You Can Transform It Into Wallet Cards And Use It In purchasing And Discount Process".localized
        strText = strText + " " + strText
        self.lblTextDetails.text = strText + "\n\n" + strText
        
        self.txtPrice.layer.borderWidth = 1
        self.txtPrice.layer.borderColor = UIColor.darkGray.withAlphaComponent(0.5).cgColor
//        self.txtPrice.placeHolderColor = UIColor.black
        self.txtPrice.placeHolderColor = UIColor.darkGray.withAlphaComponent(0.5)

        let rectTitle = self.lblTextDetails.text!.boundingRect(with: CGSize(width: CGFloat(self.lblTextDetails.frame.size.width), height: CGFloat(50000)), options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: self.lblTextDetails.font], context: nil)
        
        self.lblTextDetails.frame = CGRect(x: self.lblTextDetails.frame.origin.x, y: self.lblTextDetails.frame.origin.y, width: self.lblTextDetails.frame.size.width, height: (rectTitle.size.height))
        
        self.setScrollViewHeight()
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
        
    }
    

}
