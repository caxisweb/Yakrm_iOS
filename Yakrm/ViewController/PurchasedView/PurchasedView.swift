//
//  PurchasedView.swift
//  Yakrm
//
//  Created by Krutik V. Poojara on 15/12/18.
//  Copyright © 2018 Krutik V. Poojara. All rights reserved.
//

import UIKit

class PurchasedView: UIViewController
{
    //MARK:- Outlet
    @IBOutlet var viewNavigation: UIView!
    @IBOutlet var viewBorder: UIView!

    @IBOutlet var viewDetails: UIView!
    @IBOutlet var btnComplete: UIButton!
    @IBOutlet var lblBalance: UILabel!

    
    @IBOutlet var viewPurchase: UIView!
    @IBOutlet var viewSuccess: UIView!
    @IBOutlet var viewFail: UIView!

    //MARK:-
    override func viewDidLoad()
    {
        super.viewDidLoad()

        self.viewNavigation.backgroundColor = UIColor.init(rgb: 0xEE4158)

        if DeviceType.IS_IPHONE_X || DeviceType.IS_IPHONE_XR
        {
            self.viewNavigation.frame = CGRect(x:self.viewNavigation.frame.origin.x, y: self.viewNavigation.frame.origin.y, width:self.viewNavigation.frame.size.width, height: 88)
            self.viewDetails.frame = CGRect(x:self.viewDetails.frame.origin.x, y: self.viewNavigation.frame.origin.y + self.viewNavigation.frame.size.height, width:self.viewDetails.frame.size.width, height: ScreenSize.SCREEN_HEIGHT - self.viewNavigation.frame.size.height)
            self.viewPurchase.frame = self.viewDetails.frame
        }
        if DeviceType.IS_IPHONE_5
        {
            self.lblBalance.font = self.lblBalance.font.withSize(self.lblBalance.font.pointSize-2)
        }
        
        self.lblBalance.text = "Your Amount".localized + "100" + "Rs".localized

        self.viewBorder.dropShadow(color: .lightGray, opacity: 1, offSet: CGSize(width: 0, height: 1), radius: 1, scale: true)
        self.viewSuccess.dropShadow(color: .lightGray, opacity: 1, offSet: CGSize(width: 0, height: 1), radius: 1, scale: true)
        self.viewFail.dropShadow(color: .lightGray, opacity: 1, offSet: CGSize(width: 0, height: 1), radius: 1, scale: true)

        self.viewPurchase.isHidden = true
        self.btnComplete.layer.cornerRadius = 5
        
    }
    
    @IBAction func btnBack(_ sender: UIButton)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func btnComplete(_ sender: UIButton)
    {
        ProjectUtility.animatePopupView(viewPopup: self.viewPurchase, viewDetails: self.viewPurchase)
    }
    
    @IBAction func btnAllAction(_ sender: UIButton)
    {
        if sender.tag == 1
        {
            
        }
        else
        {
            
        }
        let VC = self.storyboard?.instantiateViewController(withIdentifier: "PaymentView") as! PaymentView
        self.navigationController?.pushViewController(VC, animated: true)
    }
    
    

}
