//
//  VoucherExpiredView.swift
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
class VoucherExpiredView: UIViewController, UITableViewDelegate, UITableViewDataSource {
    // MARK: - Outlet
    @IBOutlet var viewNavigation: UIView!
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var tblView: UITableView!

    var app = AppDelegate()

    var json: JSON!
    var strMessage: String!

    var arrVoucherExpired: [Any] = []

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
        if self.app.isEnglish {
            self.lblTitle.textAlignment = .left
        } else {
            self.lblTitle.textAlignment = .right
        }

        if self.app.isConnectedToInternet() {
            self.GetEndedVouchersOfUserAPI()
        } else {
            Toast(text: self.app.InternetConnectionMessage.localized).show()
        }

    }

    @IBAction func btnBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }

    // MARK: - Tablview
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.arrVoucherExpired.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: CouponNearEndCell!
        cell = tblView.dequeueReusableCell(withIdentifier: "CouponNearEndCell") as! CouponNearEndCell?
        if cell == nil {
            cell = Bundle.main.loadNibNamed("CouponNearEndCell", owner: self, options: nil)?[0] as! CouponNearEndCell?
        }
        let arrValue = JSON(self.arrVoucherExpired)

        let strName: String = arrValue[indexPath.section]["brand_name"].stringValue
        let strDiscount: String = arrValue[indexPath.section]["discount"].stringValue
        let strDate: String = arrValue[indexPath.section]["created_at"].stringValue
        let strPrice: String = arrValue[indexPath.section]["voucher_price"].stringValue
        let strarabName: String = arrValue[indexPath.row]["brand_name_arab"].stringValue
        var strImage: String = arrValue[indexPath.section]["voucher_image"].stringValue
        strImage = strImage.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!

       // cell.lblName.text = strName
        if self.app.strLanguage == "ar" {
            self.app.isEnglish = false
            cell.lblName.text = strarabName

            if strarabName.isEmpty {
                cell.lblName.text = strName
            }
        } else {
            self.app.isEnglish = true
            cell.lblName.text = strName
        }

        cell.imgProfile.sd_setImage(with: URL(string: "\(self.app.ImageURL)voucher_images/\(strImage)"), placeholderImage: nil)

        if self.app.isEnglish {
            cell.lblName.textAlignment = .left
            cell.lblDiscount.textAlignment = .left
            cell.lblDate.textAlignment = .left
        } else {
            cell.lblName.textAlignment = .right
            cell.lblDiscount.textAlignment = .right
            cell.lblDate.textAlignment = .right
        }
        if DeviceType.IS_IPHONE_5 {
            cell.lblName.font = cell.lblName.font.withSize(10)
            cell.lblPrice.font = cell.lblPrice.font.withSize(10)
            cell.lblDiscount.font = cell.lblDiscount.font.withSize(9)
            cell.lblDate.font = cell.lblDate.font.withSize(9)
        }
        cell.lblDiscount.text = "\(strDiscount)% " + "Discounts Of Voucher".localized

        let strAvailable = "Ended By".localized + " \(self.getDateStringFormate(strDate: strDate))"
        let strBy = NSMutableAttributedString(string: strAvailable)
        strBy.setColorForText(strAvailable, with: UIColor.init(rgb: 0xEE4158))
        cell.lblDate.attributedText = strBy
        cell.lblDate.isHidden = true

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

    func getDateStringFormate(strDate: String) -> String {
        var strFullDate = String()
        if strDate.isEmpty {
            return strFullDate
        }

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = dateFormatter.date(from: strDate)
        if date != nil {
            dateFormatter.dateFormat = "dd-MM-yyyy"
            strFullDate = dateFormatter.string(from: date!)
        }

        return strFullDate
    }

    // MARK: - Get Ended Vouchers Of User API
    func GetEndedVouchersOfUserAPI() {

        let headers: HTTPHeaders = ["Authorization": self.app.strToken]
        print(JSON(headers))

        AppWebservice.shared.request("\(self.app.BaseURL)get_ended_vouchers_of_user", method: .get, parameters: nil, headers: headers, loader: true) { (statusCode, response, error) in

            if statusCode == 200 {
                        self.json = response!
                        print(self.json)

                        let strStatus: String = self.json["status"].stringValue
                        self.strMessage = self.json["message"].stringValue

                        if strStatus == "1" {
                            self.arrVoucherExpired = self.json["data"].arrayValue
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
