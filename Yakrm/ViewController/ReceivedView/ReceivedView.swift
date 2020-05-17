//
//  ReceivedView.swift
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
import MobileCoreServices
import AVKit
import AVFoundation

@available(iOS 11.0, *)
@available(iOS 11.0, *)
@available(iOS 11.0, *)
class ReceivedView: UIViewController, UITableViewDelegate, UITableViewDataSource {
    // MARK: - Outlet

    @IBOutlet var viewNavigation: UIView!
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var tblView: UITableView!
    @IBOutlet var viewFooter: UIView!
    @IBOutlet var lblDetails: UILabel!

    var json: JSON!
    var strMessage: String!
    var arabMessage: String!
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
            self.lblDetails.textAlignment = .left
        } else {
            self.lblTitle.textAlignment = .right
            self.lblDetails.textAlignment = .right
        }
        self.viewFooter.isHidden = true

        if self.app.isConnectedToInternet() {
            self.getAllGiftReceivedAPI()
        } else {
            Toast(text: self.app.InternetConnectionMessage.localized).show()
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
        var cell: ReceivedCell!
        cell = tblView.dequeueReusableCell(withIdentifier: "ReceivedCell") as! ReceivedCell?
        if cell == nil {
            cell = Bundle.main.loadNibNamed("ReceivedCell", owner: self, options: nil)?[0] as! ReceivedCell?
        }

        if self.app.isEnglish {
            cell.lblName.textAlignment = .left
            cell.lblDate.textAlignment = .left
            cell.lblPrice.textAlignment = .left
            cell.lblDiscount.textAlignment = .left
            cell.lblDiscountedPrice.textAlignment = .left

            cell.lblFriends.textAlignment = .left
            cell.lblDetails.textAlignment = .left
        } else {
            cell.lblName.textAlignment = .right
            cell.lblDate.textAlignment = .right
            cell.lblPrice.textAlignment = .right
            cell.lblDiscount.textAlignment = .right
            cell.lblDiscountedPrice.textAlignment = .right

            cell.lblFriends.textAlignment = .right
            cell.lblDetails.textAlignment = .right
        }

        var arrValue = JSON(self.arrVoucher)

        let strFriendsName: String = arrValue[indexPath.section]["name"].stringValue
        let strName: String = arrValue[indexPath.section]["brand_name"].stringValue
        let strDate: String = arrValue[indexPath.section]["expired_at"].stringValue
        let Price: Int = arrValue[indexPath.section]["voucher_price"].intValue
        let Discount: Int = arrValue[indexPath.section]["discount"].intValue
        let strarabName: String = arrValue[indexPath.row]["brand_name_arab"].stringValue
        var strImage: String = arrValue[indexPath.section]["voucher_image"].stringValue
        var strDescription: String = arrValue[indexPath.section]["description"].stringValue
        strImage = strImage.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!

        cell.imgProfile.sd_setImage(with: URL(string: "\(self.app.ImageURL)voucher_images/\(strImage)"), placeholderImage: nil)
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
        //cell.lblName.text = strName
        cell.lblDate.text = "Ended On".localized + " \(strDate)"
        cell.lblPrice.text = "The Value".localized + ": \(Price) " + "SR".localized
//        cell.lblDiscount.text = "Discount".localized + ":3%"
//        cell.lblDiscountedPrice.text = "The Price".localized
        let DicountPrice: Int = Price * Discount / 100
        let DicountedPrice: Int = Price - DicountPrice
        let strPriceDec = "\(DicountedPrice) " + "SR".localized

        let strDISCOUNT = "Discount".localized
        let strAttDiscount = NSMutableAttributedString(string: "\(strDISCOUNT) : \(Discount)%")
        strAttDiscount.setColorForText("\(Discount)%", with: UIColor.init(rgb: 0xEE4158))
        cell.lblDiscount.attributedText = strAttDiscount
        let strPRICE = "The Price".localized
        let strAttPrice = NSMutableAttributedString(string: "\(strPRICE) : \(strPriceDec)")
        strAttPrice.setColorForText(strPriceDec, with: UIColor.init(rgb: 0xEE4158))
        cell.lblDiscountedPrice.attributedText = strAttPrice

        cell.lblFriends.text = "Sent By Your Friend".localized + " : \(strFriendsName)"
//        cell.lblDetails.text = "Hello Friend. I Am Sending You This Present To Express My Love And Gratitude For You As A Friend".localized + " " + "I Hope That You Will Be Happy During Every Single Moment Of Your Life".localized
        cell.lblDetails.text = strDescription

        cell.lblAttached.text = "Attached Video".localized
        cell.btnPress.setTitle("Press To Watch".localized, for: .normal)

//        let rectTitle = cell.lblDetails.text!.boundingRect(with: CGSize(width: cell.lblDetails.frame.size.width, height: CGFloat(50000)), options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: cell.lblDetails.font], context: nil)

        let strVideoImage: String = arrValue[indexPath.section]["attached_video_image"].stringValue

        cell.imgMP4.isHidden = strVideoImage.isEmpty
        cell.lblAttached.isHidden = strVideoImage.isEmpty
        cell.btnPress.isHidden = strVideoImage.isEmpty

        if DeviceType.IS_IPHONE_5 {
            cell.lblName.font = cell.lblName.font.withSize(9)
            cell.lblDate.font = cell.lblDate.font.withSize(8)
            cell.lblPrice.font = cell.lblPrice.font.withSize(9)
            cell.lblDiscount.font = cell.lblDiscount.font.withSize(9)
            cell.lblDiscountedPrice.font = cell.lblDiscountedPrice.font.withSize(9)

            cell.lblFriends.font = cell.lblFriends.font.withSize(9)
            cell.lblDetails.font = cell.lblDetails.font.withSize(9)

            cell.lblAttached.font = cell.lblAttached.font.withSize(9)
            cell.btnPress.titleLabel!.font = cell.btnPress.titleLabel!.font.withSize(9)
        }

        cell.btnWallet.addTarget(self, action: #selector(self.buttonClicked), for: .touchUpInside)

        cell.layer.cornerRadius = 1
        cell.frame.size.width = tblView.frame.size.width
        cell.layer.shadowOffset = CGSize(width: 0, height: 1.5)
        cell.layer.shadowRadius = 1
        cell.layer.shadowOpacity = 0.3
        cell.layer.shadowPath = UIBezierPath(roundedRect: cell.bounds, byRoundingCorners: .allCorners, cornerRadii: CGSize(width: 0, height: 3)).cgPath
        cell.layer.shouldRasterize = true
        cell.layer.rasterizationScale = UIScreen.main.scale

        cell.btnPress.addTarget(self, action: #selector(self.btnVideoPlay), for: .touchUpInside)
        cell.btnPress.tag = indexPath.section

        cell.selectionStyle = .none
        tblView.rowHeight = cell.btnPress.frame.origin.y + cell.btnPress.frame.size.height + 9//cell.frame.size.height

        return cell
    }

    @objc func btnVideoPlay(sender: UIButton) {
        var arrValue = JSON(self.arrVoucher)
        var strVideoImage: String = arrValue[sender.tag]["attached_video_image"].stringValue
        if strVideoImage.isEmpty {
            let alertController = UIAlertController(title: "Yakrm", message: "Video not availble".localized, preferredStyle: .alert)

            let cancelAction = UIAlertAction(title: "OK".localized, style: .default) { (_: UIAlertAction!) in
                print("you have pressed the Cancel button")
            }
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true, completion: nil)
        } else {
            strVideoImage = strVideoImage.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!

            let videoURL = URL(string: "\(self.app.ImageURL)gift_videos/\(strVideoImage)")
            let player = AVPlayer(url: videoURL!)
            let playerViewController = AVPlayerViewController()
            playerViewController.player = player
            self.present(playerViewController, animated: true) {
                playerViewController.player!.play()
            }

//            let fileUrl = NSURL(string: "\(self.app.ImageURL)video_or_image/\(strFriendsName)")//URL(fileURLWithPath: "\(self.app.ImageURL)video_or_image/\(strFriendsName)")
//            let player = AVPlayer(url: fileUrl ?? URL)
//
//            let playerViewController = AVPlayerViewController()
//            playerViewController.player = player
//
//            present(playerViewController, animated: true)
//            {
//                playerViewController.player!.play()
//            }
        }
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

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var arrValue = JSON(self.arrVoucher)

        let VC = self.storyboard?.instantiateViewController(withIdentifier: "StarbucksCardView") as! StarbucksCardView
        VC.json = arrValue[indexPath.section]
//        VC.isReceived = true
        self.navigationController?.pushViewController(VC, animated: true)
    }
//    {
//        var arrValue = JSON(self.arrVoucher)
//        let json = arrValue[indexPath.section]
//        let strImage = json["voucher_image"].stringValue
//        let strDate : String = json["created_at"].stringValue
//        let strPrice = json["voucher_price"].stringValue
//        let strScanCode = json["scan_code"].stringValue
//        var strScanVoucherType : String = json["scan_voucher_type"].stringValue
//        let strScanVoucherType2 = json["scan_voucher_type"].stringValue
//
//        var strVoucherID = json["voucher_id"].stringValue
//        let strNewVoucherID = json["new_voucher_id"].stringValue
//        var strVoucherPaymentID = json["voucher_payment_detail_id"].stringValue
//
//        if strScanVoucherType.lowercased() == "gift_voucher"
//        {
//            strScanVoucherType = "g"
//        }
//        else if strScanVoucherType.lowercased() == "replace_voucher"
//        {
//            strScanVoucherType = "r"
//            strVoucherID = json["new_voucher_id"].stringValue
//            strVoucherPaymentID = json["replace_voucher_payment_id"].stringValue
//        }
//        else if strScanVoucherType.lowercased() == "purchase_voucher"
//        {
//            strScanVoucherType = "p"
//        }
//        let strPinNumber : String = json["pin_code"].stringValue
//        let strName = json["brand_name"].stringValue
//
//        let VC = self.storyboard?.instantiateViewController(withIdentifier: "ReplacementView") as! ReplacementView
//        VC.strVoucherID = strVoucherID
//        VC.strVoucherPaymentID = strVoucherPaymentID
//        VC.strImage = strImage
//        VC.strName = strName
//        VC.strPrice = strPrice
//        VC.strScanVoucherType = strScanVoucherType2
//        VC.strScanCode = strScanCode
//        self.navigationController?.pushViewController(VC, animated: true)
//    }

    @objc func buttonClicked(sender: UIButton) {
        let VC = self.storyboard?.instantiateViewController(withIdentifier: "WalletView") as! WalletView
        self.navigationController?.pushViewController(VC, animated: true)
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let viewFooter = UIView()
        viewFooter.backgroundColor = UIColor.clear

        return viewFooter
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == self.arrVoucher.count-1 {
            return 5
        }
        return 20
    }

    // MARK: - Active Voucher API
    func getAllGiftReceivedAPI() {

        let headers: HTTPHeaders = ["Authorization": self.app.strToken,
                                     "Content-Type": "application/json"]
        print(JSON(headers))

        AppWebservice.shared.request("\(self.app.BaseURL)get_all_gift_received", method: .get, parameters: nil, headers: headers, loader: true) { (statusCode, response, _) in

            if statusCode == 200 {
                        self.json = response

                        let strStatus: String = self.json["status"].stringValue
                        self.strMessage = self.json["message"].stringValue
                        self.arabMessage = self.json["arab_message"].stringValue

                        if strStatus == "1" {
                            self.arrVoucher = self.json["data"].arrayValue
                            self.viewFooter.isHidden = false
                            self.tblView.delegate = self
                            self.tblView.dataSource = self
                            self.tblView.tableFooterView = self.viewFooter
                            self.tblView.reloadData()
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

            } else {
                Toast(text: self.app.RequestTimeOut.localized).show()
            }
        }
    }

}
