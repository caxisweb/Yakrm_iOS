//
//  MyAuctionView.swift
//  Yakrm
//
//  Created by Krutik V. Poojara on 17/12/18.
//  Copyright © 2018 Krutik V. Poojara. All rights reserved.
//

import UIKit

class MyAuctionView: UIViewController,UITableViewDelegate,UITableViewDataSource
{
    //MARK:- Outlet
    @IBOutlet var tblView: UITableView!
    
    @IBOutlet var btnSegment: UISegmentedControl!
    
    var app = AppDelegate()
    
    //MARK:-
    override func viewDidLoad()
    {
        super.viewDidLoad()
        app = UIApplication.shared.delegate as! AppDelegate
        
        
        self.tblView.delegate = self
        self.tblView.dataSource = self
    }
    
    
    @IBAction func btnSegmentAction(_ sender: UISegmentedControl)
    {
        self.tblView.reloadData()
    }
    
    //MARK:- Tablview
    func numberOfSections(in tableView: UITableView) -> Int
    {
        if self.btnSegment.selectedSegmentIndex == 0
        {
            return 2
        }
        else
        {
            return 2
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        var cell : OtherAuctionCell!
        cell = tblView.dequeueReusableCell(withIdentifier: "OtherAuctionCell") as! OtherAuctionCell!
        if cell == nil
        {
            if self.btnSegment.selectedSegmentIndex == 0
            {
                
                cell = Bundle.main.loadNibNamed("OtherAuctionCell", owner: self, options: nil)?[2] as! OtherAuctionCell!
                
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
                if DeviceType.IS_IPHONE_5
                {
                    cell.lblName.font = cell.lblName.font.withSize(11)
                    cell.lblDetails.font = cell.lblDetails.font.withSize(9)

                    cell.lblLastBid.font = cell.lblLastBid.font.withSize(10)
                    cell.lblBidDetails.font = cell.lblBidDetails.font.withSize(10)
                }
                cell.lblDetails.text = "Discount Voucher".localized + " 25" + "SR".localized
                
                let strAvailable = "Last Auction:".localized + "25" + "SR".localized
                let strFor = "The Number Of The Auctions".localized + ": 18".localized
                let strBy = NSMutableAttributedString(string: "\(strAvailable)  \(strFor)")
                strBy.setColorForText(strAvailable, with: UIColor.init(rgb: 0xEE4158))
                cell.lblLastBid.attributedText = strBy
                
                cell.lblBidDetails.text = "Remaining 15 H 25 M".localized
            }
            else //if self.btnSegment.selectedSegmentIndex == 1
            {
                cell = Bundle.main.loadNibNamed("OtherAuctionCell", owner: self, options: nil)?[3] as! OtherAuctionCell!
                
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
                if DeviceType.IS_IPHONE_5
                {
                    cell.lblName.font = cell.lblName.font.withSize(11)
                    cell.lblDetails.font = cell.lblDetails.font.withSize(9)
                    cell.lblBidDetails.font = cell.lblBidDetails.font.withSize(10)
                }
                cell.lblDetails.text = "Discount Voucher".localized + " 25" + "SR".localized
                
                var color = UIColor()
                if indexPath.section == 0
                {
                    color = UIColor.init(rgb: 0xEE4158)
                    cell.lblBidDetails.text = "Abed El-Rahman Fawzi" + "Wins The Auction.".localized + "The Value is".localized + "65" + "SR".localized
                }
                else
                {
                    color = UIColor.darkGray
                    cell.lblBidDetails.text = "Sorry, No One Participates In This Auction".localized
                }
                cell.lblBidDetails.textColor = color
            }
        }
        
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
    
    
}
