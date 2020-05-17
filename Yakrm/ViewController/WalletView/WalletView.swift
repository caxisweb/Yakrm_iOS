//
//  WalletView.swift
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
class WalletView: UIViewController, UITableViewDelegate, UITableViewDataSource {
    // MARK: - Outlet
    @IBOutlet var viewNavigation: UIView!
    @IBOutlet var lblTitle: UILabel!

    @IBOutlet var viewAllDetails: UIView!
    @IBOutlet var lblUPLOAD: UILabel!
    @IBOutlet var tblView: UITableView!

    @IBOutlet var viewDoller: UIView!
    @IBOutlet var lblCurrentBalance: UILabel!
    @IBOutlet var viewActive: UIView!
    @IBOutlet var viewFavorite: UIView!
    @IBOutlet var viewAlreadyEnd: UIView!
    @IBOutlet var viewEndSoon: UIView!

    @IBOutlet var lblActiveCoupon: UILabel!

    @IBOutlet var lblActiveVoucher: UILabel!
    @IBOutlet var lblFavoriteVoucher: UILabel!
    @IBOutlet var lblEndedVoucher: UILabel!
    @IBOutlet var lblWillEndVoucher: UILabel!

    @IBOutlet var lblActiveVoucherCount: UILabel!
    @IBOutlet var lblFavoriteVoucherCount: UILabel!
    @IBOutlet var lblEndedVoucherCount: UILabel!
    @IBOutlet var lblWillEndVoucherCount: UILabel!

    @IBOutlet var imgSign: UIImageView!

    //    var loadingNotification : MBProgressHUD!
    var json: JSON!
    var strMessage: String!
    var arabMessage: String!

    var app = AppDelegate()

    var arrVoucher: [Any] = []

    var isHome = Bool()

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
        self.tblView.tableHeaderView = self.viewAllDetails

        if self.app.isEnglish {
            self.lblTitle.textAlignment = .left
            self.lblCurrentBalance.textAlignment = .left

            self.lblActiveVoucher.textAlignment = .left
            self.lblFavoriteVoucher.textAlignment = .left
            self.lblEndedVoucher.textAlignment = .left
            self.lblWillEndVoucher.textAlignment = .left

            self.lblActiveCoupon.textAlignment = .left

            self.setFrameChange(vv1: self.viewActive, vv2: self.viewFavorite)
            self.setFrameChange(vv1: self.viewAlreadyEnd, vv2: self.viewEndSoon)
        } else {
            self.lblTitle.textAlignment = .right
            self.lblCurrentBalance.textAlignment = .right

            self.lblActiveVoucher.textAlignment = .right
            self.lblFavoriteVoucher.textAlignment = .right
            self.lblEndedVoucher.textAlignment = .right
            self.lblWillEndVoucher.textAlignment = .right

            self.lblActiveCoupon.textAlignment = .right

//            self.lblTitle.text = "محفظتي"
//            self.lblWillEndVoucher.text = "قسائم قرب تاريخ انتهائها"
        }
        self.lblTitle.text = "My Wallet".localized
        self.lblWillEndVoucher.text = "Vouchers Will end Very Soon".localized

        if DeviceType.IS_IPHONE_5 {
            self.lblUPLOAD.font = self.lblUPLOAD.font.withSize(self.lblUPLOAD.font.pointSize-2)
            self.lblCurrentBalance.font = self.lblCurrentBalance.font.withSize(self.lblCurrentBalance.font.pointSize-2)

            self.lblActiveVoucher.font = self.lblActiveVoucher.font.withSize(self.lblActiveVoucher.font.pointSize-2)
            self.lblFavoriteVoucher.font = self.lblFavoriteVoucher.font.withSize(self.lblFavoriteVoucher.font.pointSize-2)
            self.lblEndedVoucher.font = self.lblEndedVoucher.font.withSize(self.lblEndedVoucher.font.pointSize-2)
            self.lblWillEndVoucher.font = self.lblWillEndVoucher.font.withSize(self.lblWillEndVoucher.font.pointSize-2)

            self.lblActiveCoupon.font = self.lblActiveCoupon.font.withSize(self.lblActiveCoupon.font.pointSize-2)
        } else if DeviceType.IS_IPHONE_6 || DeviceType.IS_IPHONE_X {
            self.lblActiveVoucher.font = self.lblActiveVoucher.font.withSize(self.lblActiveVoucher.font.pointSize-1)
            self.lblFavoriteVoucher.font = self.lblFavoriteVoucher.font.withSize(self.lblFavoriteVoucher.font.pointSize-1)
            self.lblEndedVoucher.font = self.lblEndedVoucher.font.withSize(self.lblEndedVoucher.font.pointSize-1)
            self.lblWillEndVoucher.font = self.lblWillEndVoucher.font.withSize(self.lblWillEndVoucher.font.pointSize-1)
        }

        self.lblCurrentBalance.text = "\(self.app.strWallet) " + "SAR".localized + "\n" + "Your current balance".localized
//        self.lblCurrentBalance.text = "SAR".localized + " \(self.app.strWallet)" + "\n" + "Your current balance".localized

        self.setShadowonView(vv: self.viewDoller)

        self.setShadowonView(vv: self.viewActive)
        self.setShadowonView(vv: self.viewFavorite)
        self.setShadowonView(vv: self.viewAlreadyEnd)
        self.setShadowonView(vv: self.viewEndSoon)

        self.imgSign.image = self.imgSign.image?.maskWithColor(color: UIColor.init(rgb: 0xE8385A))
    }

    override func viewWillAppear(_ animated: Bool) {
        if self.app.isConnectedToInternet() {
            self.getActiveVoucherAPI()
        } else {
            Toast(text: self.app.InternetConnectionMessage.localized).show()
        }
    }

    func setFrameChange(vv1: UIView, vv2: UIView) {
        let vv = UIView()
        vv.frame = vv1.frame
        vv1.frame = vv2.frame
        vv2.frame = vv.frame
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

    @available(iOS 11.0, *)
    @IBAction func btnBack(_ sender: UIButton) {
        if self.isHome {
            let desiredViewController = self.navigationController!.viewControllers.filter { $0 is HomeView }.first!
            self.navigationController!.popToViewController(desiredViewController, animated: true)
        } else {
            self.navigationController?.popViewController(animated: true)
        }
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
        cell = tblView.dequeueReusableCell(withIdentifier: "PaymentCell") as! PaymentCell?
        if cell == nil {
            cell = Bundle.main.loadNibNamed("PaymentCell", owner: self, options: nil)?[1] as! PaymentCell?
        }

        var arrValue = JSON(self.arrVoucher)

        let strName: String = arrValue[indexPath.section]["brand_name"].stringValue
        let strDate: String = arrValue[indexPath.section]["created_at"].stringValue
        let strPrice: String = arrValue[indexPath.section]["voucher_price"].stringValue

        var strImage: String = arrValue[indexPath.section]["voucher_image"].stringValue
        strImage = strImage.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let strarabName: String = arrValue[indexPath.row]["brand_name_arab"].stringValue
        if self.app.strLanguage == "ar" {
            self.app.isEnglish = false
            cell.lblName.text = strarabName + " (Gifted)"

            if strarabName.isEmpty {
            cell.lblName.text = strName + " (Gifted)"
            }

        } else {
            self.app.isEnglish = true
            cell.lblName.text = strName + " (Gifted)"
            let scan_voucher_type: String = arrValue[indexPath.section]["scan_voucher_type"].stringValue
            if scan_voucher_type.lowercased() == "gift_voucher" {
                    cell.lblName.text = strName + " (Gifted)"
                } else {
                    cell.lblName.text = strName
                }
        }

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

//        let scan_voucher_type : String = arrValue[indexPath.section]["scan_voucher_type"].stringValue
//        if scan_voucher_type.lowercased() == "gift_voucher"
//        {
//            cell.lblName.text = strName + " (Gifted)"
//        }
//        else
//        {
//            cell.lblName.text = strName
//        }
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

    @IBAction func btnCouponAction(_ sender: UIButton) {
        let VC = self.storyboard?.instantiateViewController(withIdentifier: "CouponView") as! CouponView
        self.navigationController?.pushViewController(VC, animated: true)
    }

    @IBAction func btnAllAction(_ sender: UIButton) {
        if sender.tag == 1 {
            let VC = self.storyboard?.instantiateViewController(withIdentifier: "ActiveVoucherView") as! ActiveVoucherView
            self.navigationController?.pushViewController(VC, animated: true)
        } else if sender.tag == 2 {
            let VC = self.storyboard?.instantiateViewController(withIdentifier: "FavoritesView") as! FavoritesView
            self.navigationController?.pushViewController(VC, animated: true)
        } else if sender.tag == 3 {
            let VC = self.storyboard?.instantiateViewController(withIdentifier: "VoucherExpiredView") as! VoucherExpiredView
            self.navigationController?.pushViewController(VC, animated: true)
        } else if sender.tag == 4 {
            let VC = self.storyboard?.instantiateViewController(withIdentifier: "CouponNearEndView") as! CouponNearEndView
            self.navigationController?.pushViewController(VC, animated: true)
        }
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
                        self.arabMessage = self.json["arab_message"].stringValue
                        if strStatus == "1" {
                            self.arrVoucher = self.json["data"].arrayValue
                        } else {
                            if self.app.strLanguage == "ar" {
                                self.app.isEnglish = false
                                Toast(text: self.arabMessage.localized).show()
                            } else {
                                self.app.isEnglish = true
                                Toast(text: self.strMessage).show()
                            }
                            //Toast(text: self.strMessage).show()
                        }
                        self.app.strWallet = self.json["wallet"].stringValue
                        self.app.defaults.setValue(self.app.strWallet, forKey: "wallet")
                        self.app.defaults.synchronize()

                        self.lblActiveVoucherCount.text = "\(self.json["total_active_voucher"].intValue)"
                        self.lblFavoriteVoucherCount.text = "\(self.json["total_favourites"].intValue)"
                        self.lblEndedVoucherCount.text = "\(self.json["voucher_end_soon"].intValue)"
                        self.lblWillEndVoucherCount.text = "\(self.json["voucher_ended"].intValue)"

                        self.tblView.reloadData()
            } else {
                Toast(text: self.app.RequestTimeOut.localized).show()
            }
        }
    }

}
