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
        } else {
            self.lblTitle.textAlignment = .right
        }

        if self.app.isConnectedToInternet() {
            self.getAllUserTransactionAPI()
        } else {
            Toast(text: self.app.InternetConnectionMessage).show()
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
        cell = tblView.dequeueReusableCell(withIdentifier: "OprationlogCell") as! OprationlogCell!
        if cell == nil {
            cell = Bundle.main.loadNibNamed("OprationlogCell", owner: self, options: nil)?[0] as! OprationlogCell!
        }

        var arrValue = JSON(self.arrTransaction)

        let strName: String = arrValue[indexPath.section]["brand_name"].stringValue
        let strVenderName: String = arrValue[indexPath.section]["vendor_name"].stringValue
        let strDate: String = arrValue[indexPath.section]["created_at"].stringValue
        let strPrice: String = arrValue[indexPath.section]["voucher_price"].stringValue

        var color = UIColor()
//        if indexPath.section % 2 == 0
//        {
//            color = UIColor.init(rgb: 0xEE4158)
//        }
//        else
//        {
            color = UIColor.init(rgb: 0x309A4E)
//        }
        cell.viewLine.backgroundColor = color
        cell.lblPrice.textColor = color

        if self.app.isEnglish {
            cell.lblName.textAlignment = .left
            cell.lblDetails.textAlignment = .left
        } else {
            cell.lblName.textAlignment = .right
            cell.lblDetails.textAlignment = .right
        }

        cell.lblName.text = strName
        cell.lblPrice.text = strPrice + "SR".localized
        cell.lblDetails.text = strVenderName
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
        loadingNotification = MBProgressHUD.showAdded(to: self.view, animated: false)
        loadingNotification.mode = MBProgressHUDMode.indeterminate
        loadingNotification.label.text = "Loading..."
//        loadingNotification.dimBackground = true

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
                } else {
                    Toast(text: self.strMessage).show()
                }
                self.tblView.reloadData()
            }else {
                Toast(text: error?.localizedDescription).show()
            }
        }

    }

}
