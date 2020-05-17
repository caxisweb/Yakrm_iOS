//
//  OprationlogView.swift
//  Yakrm
//
//  Created by Krutik V. Poojara on 17/12/18.
//  Copyright © 2018 Krutik V. Poojara. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import MBProgressHUD
import Toaster

@available(iOS 11.0, *)
@available(iOS 11.0, *)
class OprationlogView: UIViewController, UITableViewDelegate, UITableViewDataSource {
    // MARK: - Outlet
    @IBOutlet var viewNavigation: UIView!
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var tblView: UITableView!
    @IBOutlet var viewHeader: UIView!
    @IBOutlet var lblPrice: UILabel!

    var loadingNotification: MBProgressHUD!
    var json: JSON!
    var strMessage: String!

    var app = AppDelegate()

    var arrTransaction: [Any] = []

    var strByVisa = "By Visa"
    var strByWallet = "By Wallet"
    var strCredited = "CREDITED"
    var strDebited = "DEBITED"

    // MARK: -
    override func viewDidLoad() {
        super.viewDidLoad()
        app = UIApplication.shared.delegate as! AppDelegate

        self.viewNavigation.backgroundColor = UIColor.init(rgb: 0xEE4158)

        if DeviceType.IS_IPHONE_X || DeviceType.IS_IPHONE_XR {
            self.viewNavigation.frame = CGRect(x: self.viewNavigation.frame.origin.x, y: self.viewNavigation.frame.origin.y, width: self.viewNavigation.frame.size.width, height: 88)
            self.tblView.frame = CGRect(x: self.tblView.frame.origin.x, y: self.viewNavigation.frame.origin.y + self.viewNavigation.frame.size.height, width: self.tblView.frame.size.width, height: ScreenSize.SCREEN_HEIGHT - self.viewNavigation.frame.size.height)
        }

        if DeviceType.IS_IPHONE_5 {
            self.lblPrice.font = self.lblPrice.font.withSize(19)
        }

        self.setShadowonView(vv: self.viewHeader)
        self.tblView.delegate = self
        self.tblView.dataSource = self
        self.tblView.tableHeaderView = self.viewHeader

        if self.app.isEnglish {
            self.lblTitle.textAlignment = .left
            self.lblPrice.textAlignment = .left
        } else {
            self.lblTitle.textAlignment = .right
            self.lblPrice.textAlignment = .right
//            self.strByVisa = "بواسطة فيزا"
//            self.strByWallet = "بواسطة محفظة"
//
//            self.strCredited = "الفضل"
//            self.strDebited = "خصم"
        }

        if self.app.isConnectedToInternet() {
            self.getAllUserTransactionAPI()
        } else {
            Toast(text: self.app.InternetConnectionMessage.localized).show()
        }

        self.lblPrice.text = "\(self.app.strWallet) " + "SAR".localized + "\n" + "Your current balance".localized

    }

    func setShadowonView(vv: UIView) {
        vv.layer.shadowColor = UIColor.lightGray.cgColor
        vv.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        vv.layer.shadowOpacity = 1.0
        vv.layer.shadowRadius = 1.0
        //        vv.layer.masksToBounds = false
        vv.layer.cornerRadius = 10.0
        vv.backgroundColor = UIColor.white
    }

    @IBAction func btnBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }

    // MARK: - Tablview
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.arrTransaction.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: OprationlogCell!
        cell = tblView.dequeueReusableCell(withIdentifier: "OprationlogCell") as! OprationlogCell?
        if cell == nil {
            cell = Bundle.main.loadNibNamed("OprationlogCell", owner: self, options: nil)?[0] as! OprationlogCell?
        }

        var arrValue = JSON(self.arrTransaction)

//        let strName : String = arrValue[indexPath.section]["brand_name"].stringValue
//        let strVenderName : String = arrValue[indexPath.section]["vendor_name"].stringValue
//        let strDate : String = arrValue[indexPath.section]["created_at"].stringValue
//        let strPrice : String = arrValue[indexPath.section]["voucher_price"].stringValue
//        var strType : String = arrValue[indexPath.section]["voucher_price"].stringValue
        var strAmountFromBank: String = arrValue[indexPath.section]["amount_from_bank"].stringValue
        var strVenderName: String = arrValue[indexPath.section]["amount_from_wallet"].stringValue
        let strDate: String = arrValue[indexPath.section]["updated_at"].stringValue
        let strPrice: String = arrValue[indexPath.section]["total_price"].stringValue
        var strType: String = arrValue[indexPath.section]["scan_voucher_type"].stringValue

        if strAmountFromBank.isEmpty {
            strAmountFromBank = "0"
        }
        if strVenderName.isEmpty {
            strVenderName = "0"
        }

        strAmountFromBank = self.strByVisa.localized + " : \(strAmountFromBank) " + "SR".localized
        strVenderName = self.strByWallet.localized + " : \(strVenderName) " + "SR".localized

        var color = UIColor()

        var strVoucherType = String()
        if strType == "purchase_voucher" {
            color = UIColor.init(rgb: 0x309A4E)
            strType = self.strCredited.localized
            strVoucherType = "Purchase Voucher"
        } else {
            color = UIColor.init(rgb: 0xEE4158)
            strType = self.strDebited.localized

            if strType == "replace_voucher" {
                strVoucherType = "Replace Voucher"
            } else {
                strVoucherType = "Return Voucher"
            }
        }
        cell.lblType.text = strType.localized

        cell.viewLine.backgroundColor = color
        cell.lblPrice.textColor = color

        if self.app.isEnglish {
            cell.lblType.textAlignment = .left
            cell.lblName.textAlignment = .left
            cell.lblDetails.textAlignment = .left
        } else {
            cell.lblType.textAlignment = .right
            cell.lblName.textAlignment = .right
            cell.lblDetails.textAlignment = .right
        }
        cell.lblVoucherType.text = strVoucherType.localized//strVoucherType

        cell.lblVoucherType.textAlignment = .right

        cell.lblName.text = strAmountFromBank
        cell.lblDetails.text = strVenderName

        cell.lblPrice.text = strPrice + " " + "SR".localized
        cell.lblDate.text = self.getDateStringFormate(strDate: strDate)

        if DeviceType.IS_IPHONE_5 {
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
        cell.layer.cornerRadius = 3.0
        cell.backgroundColor = UIColor.white
        cell.clipsToBounds = true

        cell.selectionStyle = .none
        tblView.rowHeight = cell.frame.size.height

        return cell
    }

    func getDateStringFormate(strDate: String) -> String {
        var strFullDate = String()
        if strDate.isEmpty {
            return strFullDate
        }

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd-HH:mm:ss"
        let date = dateFormatter.date(from: strDate)
        if date != nil {
            dateFormatter.dateFormat = "dd-MMM-yy" //25-JAN-19
            strFullDate = dateFormatter.string(from: date!)
        }

        return strFullDate
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let viewHeader = UIView()
        viewHeader.backgroundColor = UIColor.clear

        return viewHeader
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }

    // MARK: - get Cart API
    func getAllUserTransactionAPI() {
        let headers: HTTPHeaders = ["Authorization": self.app.strToken,
                                     "Content-Type": "application/json"]

        AppWebservice.shared.request("\(self.app.BaseURL)get_all_usertransaction", method: .get, parameters: nil, headers: headers, loader: true) { (statusCode, response, error) in

            if statusCode == 200 {
                        self.json = response!
                        print(self.json)

                        let strStatus: String = self.json["status"].stringValue
                        self.strMessage = self.json["message"].stringValue

                        self.arrTransaction.removeAll()
                        if strStatus == "1" {
                            self.arrTransaction = self.json["data"].arrayValue
                            self.app.strWallet = self.json["wallet"].stringValue
                            self.app.defaults.setValue(self.app.strWallet, forKey: "wallet")
                            self.app.defaults.synchronize()
                        } else {
                            Toast(text: self.strMessage).show()
                        }
                        self.tblView.reloadData()
            } else {
                Toast(text: self.app.RequestTimeOut.localized).show()
            }
        }
    }

}
