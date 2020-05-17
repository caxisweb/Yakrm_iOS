//
//  PaymentView.swift
//  Yakrm
//
//  Created by Krutik V. Poojara on 15/12/18.
//  Copyright © 2018 Krutik V. Poojara. All rights reserved.
//

import UIKit
import SwiftyJSON

@available(iOS 11.0, *)
class PaymentView: UIViewController,UITableViewDelegate,UITableViewDataSource
{
    //MARK:- Outlet
    @IBOutlet var viewNavigation: UIView!
    @IBOutlet var viewTop: UIView!
    @IBOutlet var viewBottom: UIView!

    @IBOutlet var lblCURRENT: UILabel!
    @IBOutlet var lblTOTAL: UILabel!
    @IBOutlet var lblRS: UILabel!
    @IBOutlet var lblCHANGE: UILabel!
    @IBOutlet var viewDetails: UIView!
    @IBOutlet var lblPrice: UILabel!
    @IBOutlet var lblBalance: UILabel!
    
    @IBOutlet var lblCHANGEACC: UILabel!
    @IBOutlet var tblView: UITableView!
    
    var app = AppDelegate()
    
    var arrList = [["Title":"By Using Pay Pal".localized,"Detail":"email@domain.dlt","image":"paypal_icon.png"],              ["Title":"By Using Mada Card".localized,"Detail":"**** **** **** 5678","image":"payment_type_csmada_icon.png"],
        ["Title":"By Using Credit Card".localized,"Detail":"**** **** **** 1234","image":"payment_visa_icon.png"]]
    
    //MARK:-
    override func viewDidLoad()
    {
        super.viewDidLoad()
        app = UIApplication.shared.delegate as! AppDelegate
        
        self.viewNavigation.backgroundColor = UIColor.init(rgb: 0xEE4158)

        if DeviceType.IS_IPHONE_X || DeviceType.IS_IPHONE_XR
        {
            self.viewNavigation.frame = CGRect(x:self.viewNavigation.frame.origin.x, y: self.viewNavigation.frame.origin.y, width:self.viewNavigation.frame.size.width, height: 88)
            self.viewDetails.frame = CGRect(x:self.viewDetails.frame.origin.x, y: self.viewNavigation.frame.origin.y + self.viewNavigation.frame.size.height, width:self.viewDetails.frame.size.width, height: ScreenSize.SCREEN_HEIGHT - self.viewNavigation.frame.size.height)
        }
        if DeviceType.IS_IPHONE_5
        {
            self.lblBalance.font = self.lblBalance.font.withSize(self.lblBalance.font.pointSize-2)
            self.lblCURRENT.font = self.lblCURRENT.font.withSize(self.lblCURRENT.font.pointSize-2)
            self.lblBalance.font = self.lblBalance.font.withSize(self.lblBalance.font.pointSize-2)
            self.lblTOTAL.font = self.lblTOTAL.font.withSize(self.lblTOTAL.font.pointSize-2)
            self.lblPrice.font = self.lblPrice.font.withSize(self.lblPrice.font.pointSize-2)
            self.lblRS.font = self.lblRS.font.withSize(self.lblRS.font.pointSize-2)
            self.lblCHANGE.font = self.lblCHANGE.font.withSize(self.lblCHANGE.font.pointSize-2)
            self.lblCHANGEACC.font = self.lblCHANGEACC.font.withSize(self.lblCHANGEACC.font.pointSize-2)
        }
        
        if self.app.isEnglish
        {
            self.lblCHANGE.textAlignment = .left
        }
        else
        {
            self.lblCHANGE.textAlignment = .right
        }
        self.lblBalance.text = "Your Amount".localized + " 0 " + "SR".localized
        
        self.tblView.delegate = self
        self.tblView.dataSource = self
        
        self.lblCURRENT.layer.cornerRadius = 5
        self.lblCURRENT.clipsToBounds = true
        
        self.viewTop.dropShadow(color: .lightGray, opacity: 1, offSet: CGSize(width: 0, height: 1), radius: 1, scale: true)
        self.viewBottom.dropShadow(color: .lightGray, opacity: 1, offSet: CGSize(width: 0, height: 1), radius: 1, scale: true)
    }
    
    @IBAction func btnBack(_ sender: UIButton)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK:- Tablview
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return self.arrList.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        var cell : PaymentCell!
        cell = tblView.dequeueReusableCell(withIdentifier: "PaymentCell") as! PaymentCell?
        if cell == nil
        {
            cell = Bundle.main.loadNibNamed("PaymentCell", owner: self, options: nil)?[0] as! PaymentCell?
        }
        
        var arrValue  = JSON(self.arrList)
        
        if self.app.isEnglish
        {
            cell.lblName.textAlignment = .left
            cell.lblDetails.textAlignment = .left
        }
        else
        {
            cell.lblName.textAlignment = .right
            cell.lblDetails.textAlignment = .right
        }
        
        let strName : String = arrValue[indexPath.section]["Title"].stringValue
        let strDetails : String = arrValue[indexPath.section]["Detail"].stringValue
        let strImage : String = arrValue[indexPath.section]["image"].stringValue
        cell.lblName.text = strName
        cell.lblDetails.text = strDetails
        cell.imgProfile.image = UIImage(named: strImage)!

        if DeviceType.IS_IPHONE_5
        {
            cell.lblName.font = cell.lblName.font.withSize(10)
            cell.lblDetails.font = cell.lblName.font.withSize(10)
        }
        
        cell.selectionStyle = .none
        tblView.rowHeight = cell.frame.size.height
        
        cell.layer.borderWidth = 1
        cell.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.5).cgColor
        
        return cell
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView?
    {
        let viewFooter = UIView()
        viewFooter.backgroundColor = UIColor.clear
        
        return viewFooter
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat
    {
        return 10
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
//        let VC = self.storyboard?.instantiateViewController(withIdentifier: "ReceivedView") as! ReceivedView
//        self.navigationController?.pushViewController(VC, animated: true)
    }
    
}
