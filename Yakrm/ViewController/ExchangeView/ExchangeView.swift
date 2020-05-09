//
//  ExchangeView.swift
//  Yakrm
//
//  Created by Krutik V. Poojara on 28/02/19.
//  Copyright © 2019 Krutik V. Poojara. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import MBProgressHUD
import Toaster

class ExchangeView: UIViewController, UITableViewDelegate, UITableViewDataSource {
    // MARK: - Outlet

    @IBOutlet var viewNavigation: UIView!
    @IBOutlet var lblTitle: UILabel!

    @IBOutlet var tblView: UITableView!

    var loadingNotification: MBProgressHUD!
    var json: JSON!
    var strMessage: String!

    var app = AppDelegate()

    var arrVoucher: [Any] = []

    var strVoucherID = String()
    var strVoucherPaymentID = String()
    var strImage = String()
    var strName = String()
    var strPrice = String()

    // MARK: -
    override func viewDidLoad() {
        super.viewDidLoad()
        app = UIApplication.shared.delegate as! AppDelegate

        self.viewNavigation.backgroundColor = UIColor.init(rgb: 0xEE4158)

        if DeviceType.IS_IPHONE_X || DeviceType.IS_IPHONE_XR {
            self.viewNavigation.frame = CGRect(x: self.viewNavigation.frame.origin.x, y: self.viewNavigation.frame.origin.y, width: self.viewNavigation.frame.size.width, height: 88)
            self.tblView.frame = CGRect(x: self.tblView.frame.origin.x, y: self.viewNavigation.frame.origin.y + self.viewNavigation.frame.size.height, width: self.tblView.frame.size.width, height: ScreenSize.SCREEN_HEIGHT - self.viewNavigation.frame.size.height)
        }

        self.tblView.delegate = self
        self.tblView.dataSource = self

        if self.app.isConnectedToInternet() {
            self.getHomeAPI()
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
        let strDate: String = arrValue[indexPath.section]["expired_at"].stringValue
        let strPrice: String = arrValue[indexPath.section]["voucher_price"].stringValue
        var strImage: String = arrValue[indexPath.section]["brand_image"].stringValue
        strImage = strImage.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!

        cell.imgProfile.sd_setImage(with: URL(string: "\(self.app.ImageURL)brand_images/\(strImage)"), placeholderImage: nil)

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
        let VC = self.storyboard?.instantiateViewController(withIdentifier: "AmountView") as! AmountView
        VC.strVoucherID = self.strVoucherID
        VC.strVoucherPaymentID = self.strVoucherPaymentID
        VC.strImage = self.strImage
        VC.strName = self.strName
        VC.strPrice = self.strPrice
        VC.json = arrValue[indexPath.section]
        self.navigationController?.pushViewController(VC, animated: true)
//        let VC = self.storyboard?.instantiateViewController(withIdentifier: "StarbucksCardView") as! StarbucksCardView
//        VC.json = arrValue[indexPath.section]
//        self.navigationController?.pushViewController(VC, animated: true)
    }

    // MARK: - Home API
    func getHomeAPI() {
        var loadingNotification: MBProgressHUD!

        loadingNotification = MBProgressHUD.showAdded(to: self.view, animated: false)
        loadingNotification.mode = MBProgressHUDMode.indeterminate
        loadingNotification.label.text = "Loading..."
        loadingNotification.dimBackground = true

        Alamofire.request("\(self.app.BaseURL)getAllActiveVoucher", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON { response in
            debugPrint(response)

            //            self.loadingNotification.hide(animated: true)
            loadingNotification.hide(animated: true)

            if response.response?.statusCode == 200 {
                if response.result.isSuccess == true {
                    if let value = response.result.value {
                        self.json = JSON(value)
                        print(self.json)

                        let strStatus: String = self.json["status"].stringValue
                        self.strMessage = self.json["message"].stringValue

                        if strStatus == "1" {
                            self.arrVoucher = self.json["data"].arrayValue
                            self.tblView.reloadData()
                        } else {
                            Toast(text: self.strMessage).show()
                        }
                    }
                } else {
                    Toast(text: "Request time out.").show()
                }
            } else {
                print(response.result.error.debugDescription)
                Toast(text: "Request time out.").show()
            }
        }
    }

}