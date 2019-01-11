//
//  ActiveVoucherView.swift
//  Yakrm
//
//  Created by Krutik V. Poojara on 26/12/18.
//  Copyright © 2018 Krutik V. Poojara. All rights reserved.
//

import UIKit

class ActiveVoucherView: UIViewController,UITableViewDelegate,UITableViewDataSource
{
    //MARK:- Outlet
    @IBOutlet var viewNavigation: UIView!
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var tblView: UITableView!
    

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
            self.tblView.frame = CGRect(x:self.tblView.frame.origin.x, y: self.viewNavigation.frame.origin.y + self.viewNavigation.frame.size.height, width:self.tblView.frame.size.width, height: ScreenSize.SCREEN_HEIGHT - self.viewNavigation.frame.size.height)
        }
        if self.app.isEnglish
        {
            self.lblTitle.textAlignment = .left
        }
        else
        {
            self.lblTitle.textAlignment = .right
        }
        self.tblView.delegate = self
        self.tblView.dataSource = self
    }

    @IBAction func btnBack(_ sender: UIButton)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK:- Tablview
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 20
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        var cell : PaymentCell!
        cell = tblView.dequeueReusableCell(withIdentifier: "PaymentCell") as! PaymentCell!
        if cell == nil
        {
            cell = Bundle.main.loadNibNamed("PaymentCell", owner: self, options: nil)?[1] as! PaymentCell!
        }
        
        if self.app.isEnglish
        {
            cell.lblName.textAlignment = .left
            cell.lblDetails.textAlignment = .left
            cell.lblDate.textAlignment = .left
        }
        else
        {
            cell.lblName.textAlignment = .right
            cell.lblDetails.textAlignment = .right
            cell.lblDate.textAlignment = .right
        }
        
        if DeviceType.IS_IPHONE_5
        {
            cell.lblName.font = cell.lblName.font.withSize(9)
            cell.lblDetails.font = cell.lblDetails.font.withSize(9)
            cell.lblDate.font = cell.lblDate.font.withSize(9)
            cell.lblPrice.font = cell.lblPrice.font.withSize(9)
        }
        
        cell.lblDetails.text = "\(indexPath.section + 1) " + "Voucher For Discount".localized
        cell.lblDate.text = "Active Till".localized + " 14/12/2018"
        cell.lblPrice.text = "\(indexPath.row) " + "Rs".localized
        
        cell.layer.cornerRadius = 1
        cell.frame.size.width = tblView.frame.size.width
        cell.layer.shadowOffset = CGSize(width: 0, height: 1.5)
        cell.layer.shadowRadius = 1
        cell.layer.shadowOpacity = 0.2
        cell.layer.shadowPath = UIBezierPath(roundedRect: cell.bounds, byRoundingCorners: .allCorners, cornerRadii: CGSize(width: -1, height: 1.5)).cgPath
        cell.layer.shouldRasterize = true
        cell.layer.rasterizationScale = UIScreen.main.scale
        
        cell.selectionStyle = .none
        tblView.rowHeight = cell.frame.size.height
        
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
        let VC = self.storyboard?.instantiateViewController(withIdentifier: "StarbucksCardView") as! StarbucksCardView
        self.navigationController?.pushViewController(VC, animated: true)
    }
    
    
    
}
