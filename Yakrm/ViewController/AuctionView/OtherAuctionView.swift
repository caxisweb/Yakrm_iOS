//
//  OtherAuctionView.swift
//  Yakrm
//
//  Created by Krutik V. Poojara on 17/12/18.
//  Copyright © 2018 Krutik V. Poojara. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

class OtherAuctionView: UIViewController,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UIPickerViewDataSource, UIPickerViewDelegate
{
    //MARK:- Outlet
    @IBOutlet var tblView: UITableView!

    @IBOutlet var btnSegment: UISegmentedControl!
    
    var app = AppDelegate()

    var arrNumber : [String] = []
    var arrSelected : [String] = []
    
    var strText = String()
    //MARK:-
    override func viewDidLoad()
    {
        super.viewDidLoad()

        app = UIApplication.shared.delegate as! AppDelegate
        
       
        for i in 1...100
        {
            self.arrNumber.append("\(i)")
        }
        for i in 0...19
        {
            self.arrSelected.append("30")
        }
        
        self.tblView.delegate = self
        self.tblView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        IQKeyboardManager.shared.shouldResignOnTouchOutside = false
    }
    
    override func viewWillDisappear(_ animated: Bool)
    {
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
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
            return 20
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
                
                cell = Bundle.main.loadNibNamed("OtherAuctionCell", owner: self, options: nil)?[0] as! OtherAuctionCell!
                
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
                    
                    cell.lblPrice.font = cell.lblName.font.withSize(10)
                    cell.lblTime.font = cell.lblName.font.withSize(10)
                }
                
                cell.txtQue.layer.borderWidth = 1
                cell.txtQue.layer.borderColor = UIColor.darkGray.withAlphaComponent(0.5).cgColor
                cell.txtQue.delegate = self
                if self.app.isEnglish
                {
                    if self.app.isLangEnglish
                    {
                        cell.txtQue.setRightPaddingPoints(cell.viewQue)
                    }
                    else
                    {
                        cell.txtQue.setLeftPaddingPoints(cell.viewQue)
                    }
                }
                else
                {
                    if self.app.isLangEnglish
                    {
                        cell.txtQue.setLeftPaddingPoints(cell.viewQue)
                    }
                    else
                    {
                        cell.txtQue.setRightPaddingPoints(cell.viewQue)
                    }
                }

//                cell.txtQue.placeHolderColor = UIColor.black
                cell.txtQue.placeHolderColor = UIColor.darkGray.withAlphaComponent(0.5)
                cell.txtQue.tag = indexPath.section
                
                let strAvailable = "STABUCKSCARD"
                let strFor = "Valdi Till".localized + "13/13/2018"
                let strBy = NSMutableAttributedString(string: "\(strAvailable) \(strFor)")
                strBy.setColorForText(strFor, with: UIColor.init(rgb: 0xEE4158))
                cell.lblName.attributedText = strBy
                
                cell.lblLastBid.text = "Last Auction:".localized + "12 " + "SR".localized
                cell.lblBidDetails.text = "Introduce Your Auction With Value:".localized
                cell.lblPrice.text = "Auction With Value".localized + "30" + "SR".localized
                cell.lblTime.text = "Auction Number".localized + ":12" + "   " + "Remaining 15 H 25 M".localized
                
                let pickerView = UIPickerView()
                pickerView.delegate = self
                cell.txtQue.inputView = pickerView
                cell.txtQue.text = self.arrSelected[indexPath.section]
                
//                cell.lblPrice.layer.cornerRadius = 4
//                cell.lblPrice.clipsToBounds = true
            }
            else //if self.btnSegment.selectedSegmentIndex == 1
            {
                cell = Bundle.main.loadNibNamed("OtherAuctionCell", owner: self, options: nil)?[1] as! OtherAuctionCell!
                
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
                if self.btnSegment.selectedSegmentIndex == 1
                {
                    cell.lblLastBid.text = "You Win This Voucher With Amount Of".localized + "65" + "SR".localized
                    cell.lblBidDetails.text = "The Voucher Is Transferred Into Your Wallet".localized
                }
                else
                {
                    cell.lblLastBid.text = "Abed El-Rahman Fawzi" + "Wins The Auction.".localized + "The Value is".localized + "65" + "SR".localized
                    cell.lblBidDetails.text = "Your Auction's Value Was".localized + "65" + "SR".localized
                }
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
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        self.arrSelected[textField.tag] = self.strText
        textField .resignFirstResponder()
//        let contentOffset = self.tblView.contentOffset
//        self.tblView.reloadData()
//        self.tblView.setContentOffset(contentOffset, animated: false)
        let indexPath = IndexPath(item: 0, section: textField.tag)
        self.tblView.reloadRows(at: [indexPath], with: .automatic)

        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField)
    {
        if self.strText.isEmpty
        {
            self.strText = "1"
        }
        self.arrSelected[textField.tag] = self.strText
        self.tblView.reloadData()
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int
    {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        return self.arrNumber.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        return self.arrNumber[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        self.strText = self.arrNumber[row]
    }
    
    
}
