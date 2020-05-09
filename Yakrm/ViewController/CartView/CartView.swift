//
//  CartView.swift
//  Yakrm
//
//  Created by Krutik V. Poojara on 10/12/18.
//  Copyright © 2018 Krutik V. Poojara. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import MBProgressHUD
import Toaster

class CartView: UIViewController, UITableViewDelegate, UITableViewDataSource {
    // MARK: - Outlet

    @IBOutlet var viewNavigation: UIView!
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var tblView: UITableView!

    @IBOutlet var btnPay: UIButton!
    @IBOutlet var lblTotal: UILabel!

    @IBOutlet var viewEmpty: UIView!
    @IBOutlet var btnPurchase: UIButton!
    @IBOutlet var viewBottom: UIView!

    var loadingNotification: MBProgressHUD!
    var json: JSON!
    var strMessage: String!

    var app = AppDelegate()

    var empty = Bool()

    var arrCart: [Any] = []

    var strCartID = String()
    var strTotal = String()

    // MARK: -
    override func viewDidLoad() {
        super.viewDidLoad()
        app = UIApplication.shared.delegate as! AppDelegate

        self.viewNavigation.backgroundColor = UIColor.init(rgb: 0xEE4158)

        if DeviceType.IS_IPHONE_X || DeviceType.IS_IPHONE_XR {
            self.viewNavigation.frame = CGRect(x: self.viewNavigation.frame.origin.x, y: self.viewNavigation.frame.origin.y, width: self.viewNavigation.frame.size.width, height: 88)
            self.viewEmpty.frame = CGRect(x: self.viewEmpty.frame.origin.x, y: self.viewNavigation.frame.origin.y + self.viewNavigation.frame.size.height, width: self.viewEmpty.frame.size.width, height: ScreenSize.SCREEN_HEIGHT - self.viewNavigation.frame.size.height)
            self.tblView.frame = CGRect(x: self.tblView.frame.origin.x, y: self.viewNavigation.frame.origin.y + self.viewNavigation.frame.size.height, width: self.tblView.frame.size.width, height: ScreenSize.SCREEN_HEIGHT - self.viewNavigation.frame.size.height - 89)
        }

        if DeviceType.IS_IPHONE_5 {
            self.lblTotal.font = self.lblTotal.font.withSize(self.lblTotal.font.pointSize-1)

            self.btnPurchase.titleLabel!.font = self.btnPurchase.titleLabel!.font.withSize(self.btnPurchase.titleLabel!.font.pointSize-1)
            self.btnPay.titleLabel!.font = self.btnPay.titleLabel!.font.withSize(self.btnPay.titleLabel!.font.pointSize-1)
        }

        self.tblView.delegate = self
        self.tblView.dataSource = self

        self.btnPay.layer.cornerRadius = 5
        self.btnPurchase.layer.cornerRadius = 5

        self.viewEmpty.isHidden = true
        self.tblView.isHidden = true
        self.viewBottom.isHidden = true

        if self.app.isEnglish {
            self.lblTitle.textAlignment = .left
        } else {
            self.lblTitle.textAlignment = .right
        }

        if self.app.isConnectedToInternet() {
            self.getCartAPI()
        } else {
            Toast(text: self.app.InternetConnectionMessage).show()
        }
    }

    @IBAction func btnBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }

    // MARK: - Tablview
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.arrCart.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: FavoritesCell!
        cell = tblView.dequeueReusableCell(withIdentifier: "FavoritesCell") as! FavoritesCell!
        if cell == nil {
            cell = Bundle.main.loadNibNamed("FavoritesCell", owner: self, options: nil)?[1] as! FavoritesCell!
        }

        var arrValue = JSON(self.arrCart)

        let strName: String = arrValue[indexPath.section]["brand_name"].stringValue
        let strDate: String = arrValue[indexPath.section]["expired_at"].stringValue
        let Price: Int = arrValue[indexPath.section]["voucher_price"].intValue
        let Discount: Int = arrValue[indexPath.section]["discount"].intValue
        let strType: String = arrValue[indexPath.section]["voucher_type"].stringValue
        var strImage: String = arrValue[indexPath.section]["brand_image"].stringValue
        strImage = strImage.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        cell.imgProfile.sd_setImage(with: URL(string: "\(self.app.ImageURL)brand_images/\(strImage)"), placeholderImage: nil)

        if self.app.isEnglish {
            cell.lblName.textAlignment = .left
            cell.lblDate.textAlignment = .left
            cell.lblPrice.textAlignment = .left
            cell.lblDiscount.textAlignment = .left
            cell.lblDiscountedPrice.textAlignment = .left
        } else {
            cell.lblName.textAlignment = .right
            cell.lblDate.textAlignment = .right
            cell.lblPrice.textAlignment = .right
            cell.lblDiscount.textAlignment = .right
            cell.lblDiscountedPrice.textAlignment = .right
        }
        if DeviceType.IS_IPHONE_5 {
            cell.lblName.font = cell.lblName.font.withSize(10)
            cell.lblDate.font = cell.lblDiscount.font.withSize(9)
            cell.lblPrice.font = cell.lblPrice.font.withSize(10)
            cell.lblDiscount.font = cell.lblDiscount.font.withSize(10)
            cell.lblDiscountedPrice.font = cell.lblDiscountedPrice.font.withSize(10)
        }

        cell.lblName.text = strName.uppercased() + " (\(strType))"
        cell.lblDate.text = "Ended In".localized + " \(self.getDateStringFormate(strDate: strDate))"
        cell.lblPrice.text = "The Value".localized + " : \(Price)" + "SR".localized

        let DicountPrice: Int = Price * Discount / 100
        let DicountedPrice: Int = Price - DicountPrice

        let strPriceDec = "\(DicountedPrice)" + "SR".localized

        let strDISCOUNT = "Discount".localized
        let strAttDiscount = NSMutableAttributedString(string: "\(strDISCOUNT) : \(Discount)%")
        strAttDiscount.setColorForText("\(Discount)%", with: UIColor.init(rgb: 0xEE4158))
        cell.lblDiscount.attributedText = strAttDiscount
        let strPRICE = "The Price".localized
        let strAttPrice = NSMutableAttributedString(string: "\(strPRICE) : \(strPriceDec)")
        strAttPrice.setColorForText(strPriceDec, with: UIColor.init(rgb: 0xEE4158))
        cell.lblDiscountedPrice.attributedText = strAttPrice

        cell.btnDelete.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        cell.btnDelete.tag = indexPath.section

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

    @objc func buttonAction(sender: UIButton!) {
        let alertController = UIAlertController(title: "Are you sure You want to Delete ?", message: nil, preferredStyle: .alert)

        let cancelAction = UIAlertAction(title: "Cancel", style: .default) { (_: UIAlertAction!) in
            print("you have pressed the Cancel button")
        }
        alertController.addAction(cancelAction)

        let OKAction = UIAlertAction(title: "Delete", style: .destructive) { (_: UIAlertAction!) in
            print("you have pressed OK button")

            var arrValue = JSON(self.arrCart)
            self.strCartID = arrValue[sender.tag]["cart_id"].stringValue

            if self.app.isConnectedToInternet() {
                self.DeleteCartAPI(index: sender.tag)
            } else {
                Toast(text: self.app.InternetConnectionMessage).show()
            }
        }
        alertController.addAction(OKAction)

        self.present(alertController, animated: true, completion: nil)

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
            dateFormatter.dateFormat = "dd-MM-yyyy"
            strFullDate = dateFormatter.string(from: date!)
        }

        return strFullDate
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let viewFooter = UIView()
        viewFooter.backgroundColor = UIColor.clear

        return viewFooter
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 15
    }

    @IBAction func btnPay(_ sender: UIButton) {
        if sender.tag == 1 {
            let VC = self.storyboard?.instantiateViewController(withIdentifier: "PurchasedView") as! PurchasedView
            VC.strTotal = self.strTotal
            self.navigationController?.pushViewController(VC, animated: true)
        } else {
            if let viewController = navigationController?.viewControllers.first(where: {$0 is HomeView}) {
                navigationController?.popToViewController(viewController, animated: true)
            }
        }

    }

    // MARK: - get Cart API
    func getCartAPI() {
        loadingNotification = MBProgressHUD.showAdded(to: self.view, animated: false)
        loadingNotification.mode = MBProgressHUDMode.indeterminate
        loadingNotification.label.text = "Loading..."
//        loadingNotification.dimBackground = true

        let headers: HTTPHeaders = ["Authorization": self.app.strToken,
                                     "Content-Type": "application/json"]

        AppWebservice.shared.request("\(self.app.BaseURL)get_all_cart_list", method: .get, parameters: nil, headers: headers, loader: true) { (statusCode, response, error) in
            if statusCode == 200 {
                self.json = response!
                print(self.json)

                let strStatus: String = self.json["status"].stringValue
                self.strMessage = self.json["message"].stringValue

                self.arrCart.removeAll()
                if strStatus == "1" {
                    self.strTotal = self.json["total_price"].stringValue

                    self.arrCart = self.json["data"].arrayValue
                    self.lblTotal.text = "Total".localized + " : \(self.strTotal)" + "SR".localized
                    self.tblView.isHidden = false
                    self.viewBottom.isHidden = false
                } else {
                    Toast(text: self.strMessage).show()
                    self.viewEmpty.isHidden = false

                    self.tblView.isHidden = true
                    self.viewBottom.isHidden = true
                }
                self.tblView.reloadData()
            } else {
                Toast(text: error?.localizedDescription).show()
            }
        }
    }

    // MARK: - Delete Cart API
    func DeleteCartAPI(index: Int) {
        loadingNotification = MBProgressHUD.showAdded(to: self.view, animated: false)
        loadingNotification.mode = MBProgressHUDMode.indeterminate
        loadingNotification.label.text = "Loading..."
//        loadingNotification.dimBackground = true

        let headers: HTTPHeaders = ["Authorization": self.app.strToken,
                                     "Content-Type": "application/json"]

        let parameters: Parameters = ["cart_id": self.strCartID]
        print(JSON(parameters))

        AppWebservice.shared.request("\(self.app.BaseURL)remove_voucher_from_cart", method: .post, parameters: parameters, headers: headers, loader: true) { (stastusCode, response, error) in
            if stastusCode == 200 {
                self.json = response!
                print(self.json)

                let strStatus: String = self.json["status"].stringValue
                self.strMessage = self.json["message"].stringValue

                Toast(text: self.strMessage).show()

                if strStatus == "1" {
                    self.getCartAPI()

//                            self.arrCart.remove(at: index)
//                            self.tblView.reloadData()
//                            if self.arrCart.count == 0
//                            {
//                                self.tblView.isHidden = true
//                                self.btnPay.isHidden = true
//                                self.lblTotal.isHidden = true
//
//                                self.viewEmpty.isHidden = false
//                            }
                }
            } else {
                Toast(text: error?.localizedDescription).show()
            }
        }
    }

}
