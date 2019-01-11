//
//  CartView.swift
//  Yakrm
//
//  Created by Krutik V. Poojara on 10/12/18.
//  Copyright © 2018 Krutik V. Poojara. All rights reserved.
//

import UIKit

class CartView: UIViewController,UITableViewDelegate,UITableViewDataSource
{
    //MARK:- Outlet
    
    @IBOutlet var viewNavigation: UIView!
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var tblView: UITableView!
    
    @IBOutlet var btnPay: UIButton!
    @IBOutlet var lblTotal: UILabel!
    
    @IBOutlet var viewEmpty: UIView!
    @IBOutlet var btnPurchase: UIButton!
    
    var app = AppDelegate()
    
    var empty = Bool()
    //MARK:-
    override func viewDidLoad()
    {
        super.viewDidLoad()
        app = UIApplication.shared.delegate as! AppDelegate
        
        self.viewNavigation.backgroundColor = UIColor.init(rgb: 0xEE4158)

        if DeviceType.IS_IPHONE_X || DeviceType.IS_IPHONE_XR
        {
            self.viewNavigation.frame = CGRect(x:self.viewNavigation.frame.origin.x, y: self.viewNavigation.frame.origin.y, width:self.viewNavigation.frame.size.width, height: 88)
            self.viewEmpty.frame = CGRect(x:self.viewEmpty.frame.origin.x, y: self.viewNavigation.frame.origin.y + self.viewNavigation.frame.size.height, width:self.viewEmpty.frame.size.width, height: ScreenSize.SCREEN_HEIGHT - self.viewNavigation.frame.size.height)
            self.tblView.frame = CGRect(x:self.tblView.frame.origin.x, y: self.viewNavigation.frame.origin.y + self.viewNavigation.frame.size.height, width:self.tblView.frame.size.width, height: ScreenSize.SCREEN_HEIGHT - self.viewNavigation.frame.size.height - 89)
        }
        
        if DeviceType.IS_IPHONE_5
        {
            self.lblTotal.font = self.lblTotal.font.withSize(self.lblTotal.font.pointSize-1)

            self.btnPurchase.titleLabel!.font = self.btnPurchase.titleLabel!.font.withSize(self.btnPurchase.titleLabel!.font.pointSize-1)
            self.btnPay.titleLabel!.font = self.btnPay.titleLabel!.font.withSize(self.btnPay.titleLabel!.font.pointSize-1)
        }
        
        self.tblView.delegate = self
        self.tblView.dataSource = self
        
        self.btnPay.layer.cornerRadius = 5
        self.btnPurchase.layer.cornerRadius = 5

        if self.empty
        {
            self.viewEmpty.isHidden = false
            self.tblView.isHidden = true
            self.btnPay.isHidden = true
            self.lblTotal.isHidden = true
        }
        else
        {
            self.viewEmpty.isHidden = true
            self.tblView.isHidden = false
            self.btnPay.isHidden = false
            self.lblTotal.isHidden = false
        }
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
        var cell : FavoritesCell!
        cell = tblView.dequeueReusableCell(withIdentifier: "FavoritesCell") as! FavoritesCell!
        if cell == nil
        {
            cell = Bundle.main.loadNibNamed("FavoritesCell", owner: self, options: nil)?[1] as! FavoritesCell!
        }
        
        var img = UIImage()
        if indexPath.section % 2 == 0
        {
            img = UIImage(named: "Screenshot 2018-12-11 at 3.53.07 PM.png")!
        }
        else
        {
            img = UIImage(named: "Screenshot 2018-12-11 at 3.53.18 PM.png")!
        }
        cell.imgProfile.image = img
        if self.app.isEnglish
        {
            cell.lblName.textAlignment = .left
            cell.lblDate.textAlignment = .left
            cell.lblPrice.textAlignment = .left
            cell.lblDiscount.textAlignment = .left
            cell.lblDiscountedPrice.textAlignment = .left
        }
        else
        {
            cell.lblName.textAlignment = .right
            cell.lblDate.textAlignment = .right
            cell.lblPrice.textAlignment = .right
            cell.lblDiscount.textAlignment = .right
            cell.lblDiscountedPrice.textAlignment = .right
        }
        if DeviceType.IS_IPHONE_5
        {
            cell.lblName.font = cell.lblName.font.withSize(10)
            cell.lblDate.font = cell.lblDiscount.font.withSize(9)
            cell.lblPrice.font = cell.lblPrice.font.withSize(10)
            cell.lblDiscount.font = cell.lblDiscount.font.withSize(10)
            cell.lblDiscountedPrice.font = cell.lblDiscountedPrice.font.withSize(10)
        }
        
        let strPriceDec = "2500" + "Sr".localized
        
        let strDISCOUNT = "Discount".localized
        let strAttDiscount = NSMutableAttributedString(string: "\(strDISCOUNT) : \(indexPath.row + 1)%")
        strAttDiscount.setColorForText("\(indexPath.row + 1)%", with: UIColor.init(rgb: 0xEE4158))
        cell.lblDiscount.attributedText = strAttDiscount
        let strPRICE = "The Price".localized
        let strAttPrice = NSMutableAttributedString(string: "\(strPRICE) : \(strPriceDec)")
        strAttPrice.setColorForText(strPriceDec, with: UIColor.init(rgb: 0xEE4158))
        cell.lblDiscountedPrice.attributedText = strAttPrice

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
        return 15
    }
    
    @IBAction func btnPay(_ sender: UIButton)
    {
        let VC = self.storyboard?.instantiateViewController(withIdentifier: "PurchasedView") as! PurchasedView
        self.navigationController?.pushViewController(VC, animated: true)
    }
    
    
}
