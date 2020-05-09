//
//  ActiveVoucherView.swift
//  Yakrm
//
//  Created by Krutik V. Poojara on 26/12/18.
//  Copyright © 2018 Krutik V. Poojara. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import MBProgressHUD
import Toaster

class ActiveVoucherView: UIViewController, UITableViewDelegate, UITableViewDataSource {
    // MARK: - Outlet
    @IBOutlet var viewNavigation: UIView!
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var tblView: UITableView!

    //    var loadingNotification : MBProgressHUD!
    var json: JSON!
    var strMessage: String!

    var app = AppDelegate()

    var arrVoucher: [Any] = []

    // MARK: -
    override func viewDidLoad() {
        super.viewDidLoad()
        app = UIApplication.shared.delegate as! AppDelegate

        self.viewNavigation.backgroundColor = UIColor.init(rgb: 0xEE4158)

        if DeviceType.IS_IPHONE_X || DeviceType.IS_IPHONE_XR {
            self.viewNavigation.frame = CGRect(x: self.viewNavigation.frame.origin.x, y: self.viewNavigation.frame.origin.y, width: self.viewNavigation.frame.size.width, height: 88)
            self.tblView.frame = CGRect(x: self.tblView.frame.origin.x, y: self.viewNavigation.frame.origin.y + self.viewNavigation.frame.size.height, width: self.tblView.frame.size.width, height: ScreenSize.SCREEN_HEIGHT - self.viewNavigation.frame.size.height)
        }
        if self.app.isEnglish {
            self.lblTitle.textAlignment = .left
        } else {
            self.lblTitle.textAlignment = .right
        }
        self.tblView.delegate = self
        self.tblView.dataSource = self

        if self.app.isConnectedToInternet() {
            self.getActiveVoucherAPI()
        } else {
            Toast(text: self.app.InternetConnectionMessage).show()
        }
    }

    @IBAction func btnBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }

    // MARK: - Tablview
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.arrVoucher.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: PaymentCell!
        cell = tblView.dequeueReusableCell(withIdentifier: "PaymentCell") as! PaymentCell!
        if cell == nil {
            cell = Bundle.main.loadNibNamed("PaymentCell", owner: self, options: nil)?[1] as! PaymentCell!
        }

        var arrValue = JSON(self.arrVoucher)

        let strName: String = arrValue[indexPath.section]["brand_name"].stringValue
        let strDate: String = arrValue[indexPath.section]["created_at"].stringValue
        let strPrice: String = arrValue[indexPath.section]["voucher_price"].stringValue
        var strImage: String = arrValue[indexPath.section]["voucher_image"].stringValue
        strImage = strImage.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!

        cell.imgProfile.sd_setImage(with: URL(string: "\(self.app.ImageURL)voucher_images/\(strImage)"), placeholderImage: nil)

        if self.app.isEnglish {
            cell.lblName.textAlignment = .left
            cell.lblDetails.textAlignment = .left
            cell.lblDate.textAlignment = .left
        } else {
            cell.lblName.textAlignment = .right
            cell.lblDetails.textAlignment = .right
            cell.lblDate.textAlignment = .right
        }

        if DeviceType.IS_IPHONE_5 {
            cell.lblName.font = cell.lblName.font.withSize(9)
            cell.lblDetails.font = cell.lblDetails.font.withSize(9)
            cell.lblDate.font = cell.lblDate.font.withSize(9)
            cell.lblPrice.font = cell.lblPrice.font.withSize(9)
        }

        cell.lblName.text = strName
        cell.lblDetails.text = ""//"\(indexPath.section + 1) " + "Voucher For Discount".localized
        cell.lblDate.text = "Active Till".localized + " \(strDate)"
        cell.lblPrice.text = "\(strPrice) " + "SR".localized

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

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let viewFooter = UIView()
        viewFooter.backgroundColor = UIColor.clear

        return viewFooter
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var arrValue = JSON(self.arrVoucher)

        let VC = self.storyboard?.instantiateViewController(withIdentifier: "StarbucksCardView") as! StarbucksCardView
        VC.json = arrValue[indexPath.section]
        self.navigationController?.pushViewController(VC, animated: true)
    }

    // MARK: - Active Voucher API
    func getActiveVoucherAPI() {

        let headers: HTTPHeaders = ["Authorization": self.app.strToken,
                                     "Content-Type": "application/json"]
        print(JSON(headers))

        AppWebservice.shared.request("\(self.app.BaseURL)get_active_voucher_ofuser", method: .get, parameters: nil, headers: headers, loader: true) { (statusCode, response, error) in
            if statusCode == 200 {
                self.json = response!
                print(self.json)

                let strStatus: String = self.json["status"].stringValue
                self.strMessage = self.json["message"].stringValue

                if strStatus == "1" {
                    self.arrVoucher = self.json["data"].arrayValue
                    self.app.AdminProfitDiscount = self.json["admin_profit_dis"].floatValue
                } else {
                    Toast(text: self.strMessage).show()
                }
                self.tblView.reloadData()
            } else {
                Toast(text: error?.localizedDescription).show()
            }
        }
    }

}
