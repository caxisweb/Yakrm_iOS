//
//  FavoritesView.swift
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

@available(iOS 11.0, *)
class FavoritesView: UIViewController, UITableViewDelegate, UITableViewDataSource {
    // MARK: - Outlet

    @IBOutlet var viewNavigation: UIView!
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var tblView: UITableView!

    var loadingNotification: MBProgressHUD!
    var json: JSON!
    var strMessage: String!
    var arabMessage: String!

    var app = AppDelegate()

    var arrFavourite: [Any] = []

    var strBrandID = String()

    // MARK: -
    override func viewDidLoad() {
        super.viewDidLoad()
        app = UIApplication.shared.delegate as! AppDelegate

        self.viewNavigation.backgroundColor = UIColor.init(rgb: 0xEE4158)

        if DeviceType.IS_IPHONE_X || DeviceType.IS_IPHONE_XR {
            self.viewNavigation.frame = CGRect(x: self.viewNavigation.frame.origin.x, y: self.viewNavigation.frame.origin.y, width: self.viewNavigation.frame.size.width, height: 88)
            self.tblView.frame = CGRect(x: self.tblView.frame.origin.x, y: self.viewNavigation.frame.origin.y + self.viewNavigation.frame.size.height + 20, width: self.tblView.frame.size.width, height: ScreenSize.SCREEN_HEIGHT - self.viewNavigation.frame.size.height - 20)
        }
        if self.app.isEnglish {
            self.lblTitle.textAlignment = .left
        } else {
            self.lblTitle.textAlignment = .right
        }
        self.tblView.delegate = self
        self.tblView.dataSource = self

        if self.app.isConnectedToInternet() {
            self.getFavouriteAPI()
        } else {
            Toast(text: self.app.InternetConnectionMessage.localized).show()
        }
    }

    @IBAction func btnBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }

    // MARK: - Tablview
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.arrFavourite.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: FavoritesCell!
        cell = tblView.dequeueReusableCell(withIdentifier: "FavoritesCell") as! FavoritesCell?
        if cell == nil {
            cell = Bundle.main.loadNibNamed("FavoritesCell", owner: self, options: nil)?[0] as! FavoritesCell?
        }

        var arrValue = JSON(self.arrFavourite)

        let strName: String = arrValue[indexPath.section]["brand_name"].stringValue
        let strDiscount: String = arrValue[indexPath.section]["discount"].stringValue
        var strImage: String = arrValue[indexPath.section]["brand_image"].stringValue
        let strarabName: String = arrValue[indexPath.row]["brand_name_arab"].stringValue
        strImage = strImage.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        cell.imgProfile.sd_setImage(with: URL(string: "\(self.app.ImageURL)brand_images/\(strImage)"), placeholderImage: nil)
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

        if self.app.isEnglish {
            cell.lblName.textAlignment = .left
            cell.lblDiscount.textAlignment = .left
        } else {
            cell.lblName.textAlignment = .right
            cell.lblDiscount.textAlignment = .right
        }
        if DeviceType.IS_IPHONE_5 {
            cell.lblName.font = cell.lblName.font.withSize(11)
            cell.lblDiscount.font = cell.lblDiscount.font.withSize(11)
        }
       // cell.lblName.text = strName
        let strDISCOUNT = "Discount till".localized
        let strAttDiscount = NSMutableAttributedString(string: "\(strDISCOUNT) \(strDiscount)%")
        strAttDiscount.setColorForText("\(strDiscount)%", with: UIColor.init(rgb: 0xEE4158))
        cell.lblDiscount.attributedText = strAttDiscount

        cell.layer.cornerRadius = 1
        cell.frame.size.width = tblView.frame.size.width
        cell.layer.shadowOffset = CGSize(width: 0, height: 1.5)
        cell.layer.shadowRadius = 1
        cell.layer.shadowOpacity = 0.3
        cell.layer.shadowPath = UIBezierPath(roundedRect: cell.bounds, byRoundingCorners: .allCorners, cornerRadii: CGSize(width: -1, height: 3)).cgPath
        cell.layer.shouldRasterize = true
        cell.layer.rasterizationScale = UIScreen.main.scale

        cell.btnDelete.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        cell.btnDelete.tag = indexPath.section

        cell.selectionStyle = .none
        tblView.rowHeight = cell.frame.size.height

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var arrValue = JSON(self.arrFavourite)
        let VC = self.storyboard?.instantiateViewController(withIdentifier: "DetailsView") as! DetailsView
        VC.strBranchID = arrValue[indexPath.section]["id"].stringValue
        self.navigationController?.pushViewController(VC, animated: true)
    }

    @objc func buttonAction(sender: UIButton!) {
        let alertController = UIAlertController(title: "Are you sure You want to Remove from Favourites ?".localized, message: nil, preferredStyle: .alert)

        let cancelAction = UIAlertAction(title: "Cancel".localized, style: .default) { (_: UIAlertAction!) in
            print("you have pressed the Cancel button")
        }
        alertController.addAction(cancelAction)

        let OKAction = UIAlertAction(title: "Remove".localized, style: .destructive) { (_: UIAlertAction!) in
            print("you have pressed OK button")

            var arrValue = JSON(self.arrFavourite)
            self.strBrandID = arrValue[sender.tag]["id"].stringValue

            if self.app.isConnectedToInternet() {
                self.DeleteFavouriteAPI()
            } else {
                Toast(text: self.app.InternetConnectionMessage.localized).show()
            }
        }
        alertController.addAction(OKAction)

        self.present(alertController, animated: true, completion: nil)
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let viewFooter = UIView()
        viewFooter.backgroundColor = UIColor.clear

        return viewFooter
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 20
    }

    // MARK: - get Favourite API
    func getFavouriteAPI() {
        
        let headers: HTTPHeaders = ["Authorization": self.app.strToken,
                                    "Content-Type": "application/json"]
        
        AppWebservice.shared.request("\(self.app.BaseURL)getAllFavouritesList", method: .get, parameters: nil, headers: headers, loader: true) { (statusCode, response, error) in
            if statusCode == 200 {
                self.json = response
                print(self.json)
                
                let strStatus: String = self.json["status"].stringValue
                self.strMessage = self.json["message"].stringValue
                self.arabMessage = self.json["arab_message"].stringValue
                
                self.arrFavourite.removeAll()
                if strStatus == "1" {
                    self.arrFavourite = self.json["data"].arrayValue
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
                self.tblView.reloadData()
            } else {
                Toast(text: self.app.RequestTimeOut.localized).show()
            }
        }
    }

    // MARK: - Delete Favourite API
    func DeleteFavouriteAPI() {

        let headers: HTTPHeaders = ["Authorization": self.app.strToken,
                                     "Content-Type": "application/json"]

        let parameters: Parameters = ["brand_id": self.strBrandID,
                                      "is_favourite": 0]
        print(JSON(parameters))
            
        AppWebservice.shared.request("\(self.app.BaseURL)addremove_to_favourite", method: .post, parameters: parameters, headers: headers, loader: true) { (statusCode, response, error) in

            if statusCode == 200 {
                        self.json = response
                        print(self.json)

                        let strStatus: String = self.json["status"].stringValue
                        self.strMessage = self.json["message"].stringValue

                        Toast(text: self.strMessage).show()

                        if strStatus == "1" {
                            self.getFavouriteAPI()
                        }
            } else {
                Toast(text: self.app.RequestTimeOut.localized).show()
            }
        }
    }

}
