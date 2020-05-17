//
//  FavoriteBrandView.swift
//  Yakrm
//
//  Created by Krutik V. Poojara on 20/12/18.
//  Copyright © 2018 Krutik V. Poojara. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import MBProgressHUD
import Toaster

@available(iOS 11.0, *)
@available(iOS 11.0, *)
class FavoriteBrandView: UIViewController, UITableViewDelegate, UITableViewDataSource {
    // MARK: - Outlet
    @IBOutlet var viewNavigation: UIView!
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var tblView: UITableView!

    var app = AppDelegate()
    var json: JSON!
    var strMessage: String!

    var arrList: [Brands] = []

    struct Brands {
        var voucher_id: String
        var vendor_id: String
        var voucher_code: String
        var discount: Int
        var voucher_price: String
        var voucher_type: String
        var expired_at: String
        var brand_id: String
        var brand_name: String
        var brand_image: String
        var description: String
        var gift_category_name: String

        init(_ voucher_id: String, _ vendor_id: String, _ voucher_code: String, _ discount: Int, _ voucher_price: String, _ voucher_type: String, _ expired_at: String, _ brand_id: String, _ brand_name: String, _ brand_image: String, _ description: String, _ gift_category_name: String) {
            self.voucher_id = voucher_id
            self.vendor_id = vendor_id
            self.voucher_code = voucher_code
            self.discount = discount
            self.voucher_price = voucher_price
            self.voucher_type = voucher_type
            self.expired_at = expired_at
            self.brand_id = brand_id
            self.brand_name = brand_name
            self.brand_image = brand_image
            self.description = description
            self.gift_category_name = gift_category_name
        }
    }

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
            self.getHomeAPI()
        } else {
            Toast(text: self.app.InternetConnectionMessage.localized).show()
        }

    }

    @IBAction func btnBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }

    // MARK: - Tablview
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.arrList.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: FavoriteBrandCell!
        cell = tblView.dequeueReusableCell(withIdentifier: "FavoriteBrandCell") as! FavoriteBrandCell?
        if cell == nil {
            cell = Bundle.main.loadNibNamed("FavoriteBrandCell", owner: self, options: nil)?[0] as! FavoriteBrandCell?
        }

        let dicValue = arrList[indexPath.section]

//        print("voucher_id : \(ditails.voucher_id)")
//        print("Discount : \(ditails.discount)\n")

        if self.app.isEnglish {
            cell.lblName.textAlignment = .left
            cell.lblDetail.textAlignment = .left
        } else {
            cell.lblName.textAlignment = .right
            cell.lblDetail.textAlignment = .right
        }
        if DeviceType.IS_IPHONE_5 {
            cell.lblName.font = cell.lblName.font.withSize(12)
            cell.lblDetail.font = cell.lblDetail.font.withSize(10)
        }
        cell.lblName.text = dicValue.brand_name.uppercased()
        cell.lblDetail.text = "\(dicValue.discount) " + "Discounts Of Voucher".localized

        let strImage = dicValue.brand_image.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!

        cell.imgProfile.sd_setImage(with: URL(string: "\(self.app.ImageURL)brand_images/\(strImage)"), placeholderImage: nil)

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

    // MARK: - Home API
    func getHomeAPI() {
        var loadingNotification: MBProgressHUD!

        let headers: HTTPHeaders = ["Authorization": self.app.strToken,
                                     "Content-Type": "application/json"]
        print(JSON(headers))
        var IsLogin = 1
        if self.app.strUserID.isEmpty {
            IsLogin = 0
        }
        let parameters: Parameters = ["is_login": IsLogin]
        print(JSON(parameters))
        
        AppWebservice.shared.request("\(self.app.BaseURL)getAllActiveVoucher", method: .post, parameters: parameters, headers: headers, loader: true) { (statusCode, response, error) in
            
            if statusCode == 200 {
                        self.json = response!
                        print(self.json)

                        let strStatus: String = self.json["status"].stringValue
                        self.strMessage = self.json["message"].stringValue

                        if strStatus == "1" {
                            let data = self.json["data"].arrayValue

                            if data.count > 0 {
                                for index in 0...data.count-1 {
                                    let voucher_id = data[index]["voucher_id"].stringValue
                                    let vendor_id = data[index]["vendor_id"].stringValue
                                    let voucher_code = data[index]["voucher_code"].stringValue
                                    let discount = data[index]["discount"].intValue
                                    let voucher_price = data[index]["voucher_price"].stringValue
                                    let voucher_type = data[index]["voucher_type"].stringValue
                                    let expired_at = data[index]["expired_at"].stringValue
                                    let brand_id = data[index]["brand_id"].stringValue
                                    let brand_name = data[index]["brand_name"].stringValue
                                    let brand_image = data[index]["brand_image"].stringValue
                                    let description = data[index]["description"].stringValue
                                    let gift_category_name = data[index]["gift_category_name"].stringValue
//                                    self.arrList.append(Brands(voucher_id, vendor_id))
                                    self.arrList.append(Brands(voucher_id, vendor_id, voucher_code, discount, voucher_price, voucher_type, expired_at, brand_id, brand_name, brand_image, description, gift_category_name))
                                }
                            }
                            let final: [Brands] = self.arrList.sorted(by: { (object1, object2) -> Bool in
                                return object1.discount > object2.discount
                            })
                            self.arrList = final

                            self.tblView.reloadData()
                        } else {
                            Toast(text: self.strMessage).show()
                        }
            } else {
            
                Toast(text: self.app.RequestTimeOut.localized).show()
            }
        }
    }

}
