//
//  CouponView.swift
//  Yakrm
//
//  Created by Krutik V. Poojara on 15/12/18.
//  Copyright © 2018 Krutik V. Poojara. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import MBProgressHUD
import Toaster

@available(iOS 11.0, *)
@available(iOS 11.0, *)
class CouponView: UIViewController, UITableViewDelegate, UITableViewDataSource {
    // MARK: - Outlet

    @IBOutlet var viewNavigation: UIView!
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var tblView: UITableView!

    //    var loadingNotification : MBProgressHUD!
    var json: JSON!
    var strMessage: String!

    var app = AppDelegate()

    var arrVoucher: [Any] = []

    var refresher: UIRefreshControl!

    // MARK: -
    override func viewDidLoad() {
        super.viewDidLoad()
        app = UIApplication.shared.delegate as! AppDelegate

        UIApplication.shared.statusBarStyle = .lightContent

        self.viewNavigation.backgroundColor = UIColor.init(rgb: 0xEE4158)

        if DeviceType.IS_IPHONE_X || DeviceType.IS_IPHONE_XR {
            self.viewNavigation.frame = CGRect(x: self.viewNavigation.frame.origin.x, y: self.viewNavigation.frame.origin.y, width: self.viewNavigation.frame.size.width, height: 88)
            self.tblView.frame = CGRect(x: self.tblView.frame.origin.x, y: self.viewNavigation.frame.origin.y + self.viewNavigation.frame.size.height, width: self.tblView.frame.size.width, height: ScreenSize.SCREEN_HEIGHT - self.viewNavigation.frame.size.height)
        }

//        if self.app.isEnglish
//        {
//            self.lblTitle.textAlignment = .left
//        }
//        else
//        {
//            self.lblTitle.textAlignment = .right
//        }

        self.tblView.delegate = self
        self.tblView.dataSource = self

        if self.app.isConnectedToInternet() {
            self.getActiveVoucherAPI(isLoading: true)
        } else {
            Toast(text: self.app.InternetConnectionMessage.localized).show()
        }

        self.refresher = UIRefreshControl()
        self.tblView!.alwaysBounceVertical = true
        self.refresher.tintColor = UIColor.init(rgb: 0xEE4158)
        self.refresher.addTarget(self, action: #selector(self.reloadListData), for: .valueChanged)
        self.tblView!.addSubview(refresher)

    }

    @objc func reloadListData() {
        if self.app.isConnectedToInternet() {
            self.getActiveVoucherAPI(isLoading: false)
        } else {
            Toast(text: self.app.InternetConnectionMessage.localized).show()
        }
    }

    @IBAction func btnBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func btnSignOut(_ sender: UIButton) {
        let alertController = UIAlertController(title: "Are you sure You want to Logout ?".localized, message: nil, preferredStyle: .alert)

        let cancelAction = UIAlertAction(title: "Cancel".localized, style: .default) { (_: UIAlertAction!) in
            print("you have pressed the Cancel button")
        }
        alertController.addAction(cancelAction)

        let OKAction = UIAlertAction(title: "Logout".localized, style: .destructive) { (_: UIAlertAction!) in
            print("you have pressed OK button")

            self.app.strUserID = ""
            self.app.strToken = ""
            self.app.defaults.removeObject(forKey: "user_id")
            self.app.defaults.synchronize()

            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "SidemenuView"), object: nil, userInfo: nil)

            let VC = self.storyboard?.instantiateViewController(withIdentifier: "ViewController") as! ViewController
            self.navigationController!.pushViewController(VC, animated: true)
        }
        alertController.addAction(OKAction)

        self.present(alertController, animated: true, completion: nil)
    }

    // MARK: - Tablview
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.arrVoucher.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: CouponCell!
        cell = tblView.dequeueReusableCell(withIdentifier: "CouponCell") as! CouponCell?
        if cell == nil {
            cell = Bundle.main.loadNibNamed("CouponCell", owner: self, options: nil)?[0] as! CouponCell?
        }

        if self.app.isEnglish {
            cell.lblName.textAlignment = .left
            cell.lblDetails.textAlignment = .left
        } else {
            cell.lblName.textAlignment = .right
            cell.lblDetails.textAlignment = .right
        }
        if DeviceType.IS_IPHONE_5 {
            cell.lblName.font = cell.lblName.font.withSize(10)
            cell.lblDetails.font = cell.lblDetails.font.withSize(9)
        }

        var arrValue = JSON(self.arrVoucher)

        let strName: String = arrValue[indexPath.section]["brand_name"].stringValue
        let strTotalVoucher: String = arrValue[indexPath.section]["total_voucher"].stringValue
        var strImage: String = arrValue[indexPath.section]["brand_image"].stringValue
        strImage = strImage.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!

        cell.imgProfile.sd_setImage(with: URL(string: "\(self.app.ImageURL)brand_images/\(strImage)"), placeholderImage: nil)

        cell.lblName.text = strName
        cell.lblDetails.text = "\(strTotalVoucher) " + "Discount Voucher".localized

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

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var arrValue = JSON(self.arrVoucher)

        let VC = self.storyboard?.instantiateViewController(withIdentifier: "CouponDetailsView") as! CouponDetailsView
        VC.json = arrValue[indexPath.section]
        self.navigationController?.pushViewController(VC, animated: true)
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let viewFooter = UIView()
        viewFooter.backgroundColor = UIColor.clear

        return viewFooter
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }

    // MARK: - Active Voucher API
    func getActiveVoucherAPI(isLoading: Bool) {
        var loadingNotification: MBProgressHUD!

        if isLoading {
        }

        let headers: HTTPHeaders = ["Authorization": self.app.strToken,
                                     "Content-Type": "application/json"]
        print(JSON(headers))

        
            
        AppWebservice.shared.request("\(self.app.SalesURL)get_all_brands_of_vendors", method: .get, parameters: nil, headers: headers, loader: isLoading) { (statusCode, response, error) in
            

            if statusCode == 200 {
                        self.json = response!
                        print(self.json)

                        let strStatus: String = self.json["status"].stringValue
                        self.strMessage = self.json["message"].stringValue

                        self.arrVoucher.removeAll()
                        if strStatus == "1" {
                            self.arrVoucher = self.json["data"].arrayValue
                        } else {
                            Toast(text: self.strMessage).show()
                            if strStatus != "0" {
                                self.app.strUserID = ""
                                self.app.strToken = ""
                                self.app.isCartAdded = false
                                self.app.defaults.removeObject(forKey: "user_id")
                                self.app.defaults.removeObject(forKey: "isCartAdded")
                                self.app.defaults.synchronize()

                                let VC = self.storyboard?.instantiateViewController(withIdentifier: "ViewController") as! ViewController

                                self.navigationController!.pushViewController(VC, animated: true)
                            }
                        }
                        self.tblView.reloadData()
            } else {
                Toast(text: self.app.RequestTimeOut.localized).show()
            }
        }
    }

}
