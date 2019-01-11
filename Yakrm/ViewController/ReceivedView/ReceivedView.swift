
//
//  ReceivedView.swift
//  Yakrm
//
//  Created by Krutik V. Poojara on 15/12/18.
//  Copyright © 2018 Krutik V. Poojara. All rights reserved.
//

import UIKit

class ReceivedView: UIViewController,UITableViewDelegate,UITableViewDataSource
{
    //MARK:- Outlet

    @IBOutlet var viewNavigation: UIView!
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var tblView: UITableView!
    @IBOutlet var viewFooter: UIView!
    @IBOutlet var lblDetails: UILabel!

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
            self.tblView.frame = CGRect(x:self.tblView.frame.origin.x, y: self.viewNavigation.frame.origin.y + self.viewNavigation.frame.size.height + 20, width:self.tblView.frame.size.width, height: ScreenSize.SCREEN_HEIGHT - self.viewNavigation.frame.size.height - 20)
        }
        if self.app.isEnglish
        {
            self.lblTitle.textAlignment = .left
            self.lblDetails.textAlignment = .left
        }
        else
        {
            self.lblTitle.textAlignment = .right
            self.lblDetails.textAlignment = .right
        }
        self.tblView.delegate = self
        self.tblView.dataSource = self
        self.tblView.tableFooterView = self.viewFooter
    }
    
    @IBAction func btnBack(_ sender: UIButton)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK:- Tablview
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 6
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        var cell : ReceivedCell!
        cell = tblView.dequeueReusableCell(withIdentifier: "ReceivedCell") as! ReceivedCell!
        if cell == nil
        {
            cell = Bundle.main.loadNibNamed("ReceivedCell", owner: self, options: nil)?[0] as! ReceivedCell!
        }
        
        if self.app.isEnglish
        {
            cell.lblName.textAlignment = .left
            cell.lblDate.textAlignment = .left
            cell.lblPrice.textAlignment = .left
            cell.lblDiscount.textAlignment = .left
            cell.lblDiscountedPrice.textAlignment = .left

            cell.lblFriends.textAlignment = .left
            cell.lblDetails.textAlignment = .left
        }
        else
        {
            cell.lblName.textAlignment = .right
            cell.lblDate.textAlignment = .right
            cell.lblPrice.textAlignment = .right
            cell.lblDiscount.textAlignment = .right
            cell.lblDiscountedPrice.textAlignment = .right

            cell.lblFriends.textAlignment = .right
            cell.lblDetails.textAlignment = .right
        }
        
        cell.lblDate.text = "Ended In".localized + " ٢٠١٨/١٢/١٢"
        cell.lblPrice.text = "The Value".localized + ": 2500" + "Sr".localized
//        cell.lblDiscount.text = "Discount".localized + ":3%"
//        cell.lblDiscountedPrice.text = "The Price".localized
        let strPriceDec = "2500" + "Sr".localized

        let strDISCOUNT = "Discount".localized
        let strAttDiscount = NSMutableAttributedString(string: "\(strDISCOUNT) : \(indexPath.row + 1)%")
        strAttDiscount.setColorForText("\(indexPath.row + 1)%", with: UIColor.init(rgb: 0xEE4158))
        cell.lblDiscount.attributedText = strAttDiscount
        let strPRICE = "The Price".localized
        let strAttPrice = NSMutableAttributedString(string: "\(strPRICE) : \(strPriceDec)")
        strAttPrice.setColorForText(strPriceDec, with: UIColor.init(rgb: 0xEE4158))
        cell.lblDiscountedPrice.attributedText = strAttPrice
        
        cell.lblFriends.text = "Sent By Your Friend".localized + " : Mahmoud Abd El-Rahman"
        cell.lblDetails.text = "Hello Friend. I Am Sending You This Present To Express My Love And Gratitude For You As A Friend".localized + " " + "I Hope That You Will Be Happy During Every Single Moment Of Your Life".localized
        
        cell.lblAttached.text = "Attached Video".localized
        cell.btnPress.setTitle("Press To Watch".localized, for: .normal)
        
        if DeviceType.IS_IPHONE_5
        {
            cell.lblName.font = cell.lblName.font.withSize(9)
            cell.lblDate.font = cell.lblDate.font.withSize(8)
            cell.lblPrice.font = cell.lblPrice.font.withSize(9)
            cell.lblDiscount.font = cell.lblDiscount.font.withSize(9)
            cell.lblDiscountedPrice.font = cell.lblDiscountedPrice.font.withSize(9)
            
            cell.lblFriends.font = cell.lblFriends.font.withSize(9)
            cell.lblDetails.font = cell.lblDetails.font.withSize(9)

            cell.lblAttached.font = cell.lblAttached.font.withSize(9)
            cell.btnPress.titleLabel!.font = cell.btnPress.titleLabel!.font.withSize(9)
        }
        
        cell.btnWallet.addTarget(self, action:#selector(self.buttonClicked), for: .touchUpInside)

        cell.layer.cornerRadius = 1
        cell.frame.size.width = tblView.frame.size.width
        cell.layer.shadowOffset = CGSize(width: 0, height: 1.5)
        cell.layer.shadowRadius = 1
        cell.layer.shadowOpacity = 0.3
        cell.layer.shadowPath = UIBezierPath(roundedRect: cell.bounds, byRoundingCorners: .allCorners, cornerRadii: CGSize(width: 0, height: 3)).cgPath
        cell.layer.shouldRasterize = true
        cell.layer.rasterizationScale = UIScreen.main.scale
        
        cell.selectionStyle = .none
        tblView.rowHeight = cell.frame.size.height
        
        return cell
    }
    
    @objc func buttonClicked(sender : UIButton)
    {
        let VC = self.storyboard?.instantiateViewController(withIdentifier: "WalletView") as! WalletView
        self.navigationController?.pushViewController(VC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView?
    {
        let viewFooter = UIView()
        viewFooter.backgroundColor = UIColor.clear
        
        return viewFooter
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat
    {
        return 20
    }

}
