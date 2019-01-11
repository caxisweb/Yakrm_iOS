//
//  OprationlogView.swift
//  Yakrm
//
//  Created by Krutik V. Poojara on 17/12/18.
//  Copyright © 2018 Krutik V. Poojara. All rights reserved.
//

import UIKit

class OprationlogView: UIViewController,UITableViewDelegate,UITableViewDataSource
{
    //MARK:- Outlet
    @IBOutlet var viewNavigation: UIView!
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var tblView: UITableView!
    @IBOutlet var viewHeader: UIView!
    @IBOutlet var lblPrice: UILabel!
    
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
        
        if DeviceType.IS_IPHONE_5
        {
            self.lblPrice.font = self.lblPrice.font.withSize(19)
        }
        
        self.setShadowonView(vv: self.viewHeader)
        self.tblView.delegate = self
        self.tblView.dataSource = self
        self.tblView.tableHeaderView = self.viewHeader
        
        if self.app.isEnglish
        {
            self.lblTitle.textAlignment = .left
        }
        else
        {
            self.lblTitle.textAlignment = .right
        }
    }
    
    func setShadowonView(vv :UIView)
    {
        vv.layer.shadowColor = UIColor.lightGray.cgColor
        vv.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        vv.layer.shadowOpacity = 1.0
        vv.layer.shadowRadius = 1.0
        //        vv.layer.masksToBounds = false
        vv.layer.cornerRadius = 10.0
        vv.backgroundColor = UIColor.white
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
        var cell : OprationlogCell!
        cell = tblView.dequeueReusableCell(withIdentifier: "OprationlogCell") as! OprationlogCell!
        if cell == nil
        {
            cell = Bundle.main.loadNibNamed("OprationlogCell", owner: self, options: nil)?[0] as! OprationlogCell!
        }
        
        var color = UIColor()
        if indexPath.section % 2 == 0
        {
            color = UIColor.init(rgb: 0xEE4158)
        }
        else
        {
            color = UIColor.init(rgb: 0x309A4E)
        }
        cell.viewLine.backgroundColor = color
        cell.lblPrice.textColor = color
        
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
        cell.lblPrice.text = "50" + "SR".localized
        cell.lblDetails.text = "Mohammed Abd Allah Al-'amdi".localized
        
        if DeviceType.IS_IPHONE_5
        {
            cell.lblName.font = cell.lblName.font.withSize(13)
            cell.lblDetails.font = cell.lblDate.font.withSize(10)
            cell.lblDate.font = cell.lblDate.font.withSize(9)
            cell.lblPrice.font = cell.lblPrice.font.withSize(21)
        }
        
        cell.layer.shadowColor = UIColor.lightGray.cgColor
        cell.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        cell.layer.shadowOpacity = 1.0
        cell.layer.shadowRadius = 1.0
        //        vv.layer.masksToBounds = false
        cell.layer.cornerRadius = 1.0
        cell.backgroundColor = UIColor.white

        cell.selectionStyle = .none
        tblView.rowHeight = cell.frame.size.height
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        let viewHeader = UIView()
        viewHeader.backgroundColor = UIColor.clear
        
        return viewHeader
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        return 10
    }
    
    
    
}
