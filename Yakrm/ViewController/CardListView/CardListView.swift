//
//  CardListView.swift
//  Yakrm
//
//  Created by Apple on 24/05/19.
//  Copyright © 2019 Krutik V. Poojara. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import MBProgressHUD
import Toaster

@available(iOS 11.0, *)
class CardListView: UIViewController, UITableViewDelegate, UITableViewDataSource {
    // MARK: - Outlet

    @IBOutlet var viewNavigation: UIView!
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var tblView: UITableView!
    @IBOutlet var btnAdd: UIButton!

    var loadingNotification: MBProgressHUD!
    var json: JSON!
    var strMessage: String!

    var app = AppDelegate()

    var empty = Bool()

    var arrCardList: [Any] = []
    var strCartID = String()

    // MARK: -
    override func viewDidLoad() {
        super.viewDidLoad()
        app = UIApplication.shared.delegate as! AppDelegate
        self.viewNavigation.backgroundColor = UIColor.init(rgb: 0xEE4158)

        self.btnAdd.layer.cornerRadius = 5

        if DeviceType.IS_IPHONE_X || DeviceType.IS_IPHONE_XR {
            self.viewNavigation.frame = CGRect(x: self.viewNavigation.frame.origin.x, y: self.viewNavigation.frame.origin.y, width: self.viewNavigation.frame.size.width, height: 88)
            self.tblView.frame = CGRect(x: self.tblView.frame.origin.x, y: self.viewNavigation.frame.origin.y + self.viewNavigation.frame.size.height + 30, width: self.tblView.frame.size.width, height: ScreenSize.SCREEN_HEIGHT - self.viewNavigation.frame.size.height - 125)
        }

        self.tblView.delegate = self
        self.tblView.dataSource = self

        if self.app.isEnglish {
            self.lblTitle.textAlignment = .left
        } else {
            self.lblTitle.textAlignment = .right
//            self.lblTitle.text = "قائمة البطاقات"
//            self.btnAdd.setTitle("إضافة طريقة أخرى", for: .normal)
        }
        self.lblTitle.text = "Card List".localized
        self.btnAdd.setTitle("Add Another Method".localized, for: .normal)

        if self.app.isConnectedToInternet() {
            self.GetAllCardsOfUsersAPI()
        } else {
            Toast(text: self.app.InternetConnectionMessage.localized).show()
        }
        NotificationCenter.default.addObserver(self, selector: #selector(self.showCartView(_:)), name: NSNotification.Name(rawValue: "CartView"), object: nil)
    }

    @objc func showCartView(_ notification: NSNotification) {
        app = UIApplication.shared.delegate as! AppDelegate
        if self.app.isConnectedToInternet() {
            self.GetAllCardsOfUsersAPI()
        } else {
            Toast(text: self.app.InternetConnectionMessage.localized).show()
        }
    }

    override func viewWillAppear(_ animated: Bool) {

    }

    @IBAction func btnBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func btnAdd(_ sender: UIButton) {
        let VC = self.storyboard?.instantiateViewController(withIdentifier: "PaymentMethodView") as! PaymentMethodView
        self.navigationController?.pushViewController(VC, animated: true)
    }

    // MARK: - Tablview
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.arrCardList.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: PaymentCell!
        cell = tblView.dequeueReusableCell(withIdentifier: "PaymentCell") as! PaymentCell?
        if cell == nil {
            cell = Bundle.main.loadNibNamed("PaymentCell", owner: self, options: nil)?[2] as! PaymentCell?
        }

        var arrValue  = JSON(self.arrCardList)

//        if self.app.isEnglish
//        {
            cell.lblName.textAlignment = .left
            cell.lblDetails.textAlignment = .left
//        }
//        else
//        {
//            cell.lblName.textAlignment = .right
//            cell.lblDetails.textAlignment = .right
//        }

        var img = UIImage(named: "edit-document.png")!
        cell.btnEdit.setImage(img.maskWithColor(color: UIColor.init(rgb: 0x3C99C0)), for: .normal)
        img = UIImage(named: "delete.png")!
        cell.btnDelete.setImage(img.maskWithColor(color: UIColor.init(rgb: 0xEE4158)), for: .normal)

        let strName: String = arrValue[indexPath.section]["card_number"].stringValue

        let strLast: String = String(strName.suffix(4))
        let strDetails: String = arrValue[indexPath.section]["name"].stringValue

        cell.lblDetails.text = "**** **** **** \(strLast)"
        cell.lblName.text = "By Using Credit Card"//strDetails
//        cell.imgProfile.image = UIImage(named: "payment_visa_icon.png")!
        if let methods = arrValue[indexPath.section]["payment_method"].string, methods == "1" {
            cell.imgProfile.image = UIImage(named: "payment_type_csmada_icon.png")!
        }else {
            cell.imgProfile.image = UIImage(named: "payment_visa_icon.png")!
        }

        if !strDetails.isEmpty {
            cell.lblName.text = "By \(strDetails)"//strDetails
            cell.imgProfile.image = UIImage(named: "hyperpay.png")!
            cell.imgProfile.contentMode = .scaleAspectFill
            cell.imgProfile.frame.origin.x = 20
            cell.lblDetails.text = "**** **** **** ****"
        } else {
            cell.imgProfile.contentMode = .scaleAspectFit
        }

        if DeviceType.IS_IPHONE_5 {
            cell.lblName.font = cell.lblName.font.withSize(12)
            cell.lblDetails.font = cell.lblName.font.withSize(8)
        }

        cell.btnEdit.addTarget(self, action: #selector(btnEditAction(sender:)), for: .touchUpInside)
        cell.btnEdit.tag = indexPath.section
        cell.btnDelete.addTarget(self, action: #selector(btnDeleteAction(sender:)), for: .touchUpInside)
        cell.btnDelete.tag = indexPath.section

        cell.selectionStyle = .none
        tblView.rowHeight = cell.frame.size.height

        cell.layer.borderWidth = 1
        cell.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.5).cgColor

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        var arrValue  = JSON(self.arrCardList)
//        let strCardHolderName : String = arrValue[indexPath.section]["holder_name"].stringValue
//        let strCardHolderNumber : String = arrValue[indexPath.section]["card_number"].stringValue
//        let strExpireyDate : String = arrValue[indexPath.section]["expiry_date"].stringValue
//        let strCVV : String = arrValue[indexPath.section]["security_number"].stringValue
//        let strCardID : String = arrValue[indexPath.section]["id"].stringValue
//        let VC = self.storyboard?.instantiateViewController(withIdentifier: "PaymentMethodView") as! PaymentMethodView
//        VC.strCardHolderName = strCardHolderName
//        VC.strCardHolderNumber = strCardHolderNumber
//        VC.strExpireyDate = strExpireyDate
//        VC.strCVV = strCVV
//        VC.strCardID = strCardID
//        self.navigationController?.pushViewController(VC, animated: true)
    }

    @objc func btnEditAction(sender: UIButton!) {
        var arrValue  = JSON(self.arrCardList)
        let strCardHolderName: String = arrValue[sender.tag]["holder_name"].stringValue
        let strCardHolderNumber: String = arrValue[sender.tag]["card_number"].stringValue
        let strExpireyDate: String = arrValue[sender.tag]["expiry_date"].stringValue
        let strCVV: String = arrValue[sender.tag]["security_number"].stringValue
        let strCardID: String = arrValue[sender.tag]["id"].stringValue
        let VC = self.storyboard?.instantiateViewController(withIdentifier: "PaymentMethodView") as! PaymentMethodView
        VC.strCardHolderName = strCardHolderName
        VC.strCardHolderNumber = strCardHolderNumber
        VC.strExpireyDate = strExpireyDate
        VC.strCVV = strCVV
        VC.strCardID = strCardID
        self.navigationController?.pushViewController(VC, animated: true)
    }

    @objc func btnDeleteAction(sender: UIButton!) {
        let alertController = UIAlertController(title: "Are you sure You want to Delete ?".localized, message: nil, preferredStyle: .alert)

        let cancelAction = UIAlertAction(title: "Cancel".localized, style: .default) { (_: UIAlertAction!) in
            print("you have pressed the Cancel button")
        }
        alertController.addAction(cancelAction)

        let OKAction = UIAlertAction(title: "Delete".localized, style: .destructive) { (_: UIAlertAction!) in
            print("you have pressed OK button")

            var arrValue = JSON(self.arrCardList)
            self.strCartID = arrValue[sender.tag]["id"].stringValue

            if self.app.isConnectedToInternet() {
                self.DeleteCardAPI(index: sender.tag)
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
        return 10
    }

    // MARK: - Get All Cards Of Users API
    func GetAllCardsOfUsersAPI() {
        let headers: HTTPHeaders = ["Authorization": self.app.strToken,
                                     "Content-Type": "application/json"]
        print(JSON(headers))

        AppWebservice.shared.request("\(self.app.BaseURL)get_all_cards_ofusers", method: .get, parameters: nil, headers: headers, loader: true) { (statusCode, response, error) in


            if statusCode == 200 {
                        self.json = response!
                        print(self.json)

                        let strStatus: String = self.json["status"].stringValue
                        self.strMessage = self.json["message"].stringValue

                        if strStatus == "1" {
                            let data = self.json["data"]

                            self.arrCardList = self.json["data"].arrayValue
                            self.tblView.reloadData()
                        } else {
                            let VC = self.storyboard?.instantiateViewController(withIdentifier: "PaymentMethodView") as! PaymentMethodView
                            self.navigationController?.pushViewController(VC, animated: true)

//                            let alertController = UIAlertController(title: "Yakrm", message: self.strMessage, preferredStyle: .alert)
//
//                            let cancelAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
//                                print("you have pressed the Cancel button")
//                            }
//                            alertController.addAction(cancelAction)
//                            self.present(alertController, animated: true, completion:nil)
                            Toast(text: self.strMessage).show()
                        }
            } else {
                Toast(text: self.app.RequestTimeOut.localized).show()
            }
        }
    }

    // MARK: - Delete Cart API
    func DeleteCardAPI(index: Int) {
        
        let headers: HTTPHeaders = ["Authorization": self.app.strToken,
                                     "Content-Type": "application/json"]

        let parameters: Parameters = ["card_id": self.strCartID]
        print(JSON(parameters))
        
        AppWebservice.shared.request("\(self.app.BaseURL)remove_card_of_users", method: .post, parameters: parameters, headers: headers, loader: true) { (statusCode, response, error) in
            
            if statusCode == 200 {
                        self.json = response!
                        print(self.json)

                        let strStatus: String = self.json["status"].stringValue
                        self.strMessage = self.json["message"].stringValue

                        Toast(text: self.strMessage).show()
                        if strStatus == "1" {
                            self.arrCardList.remove(at: index)
                            self.tblView.reloadData()
                        }
            } else {
                Toast(text: self.app.RequestTimeOut.localized).show()
            }
        }
    }

}
