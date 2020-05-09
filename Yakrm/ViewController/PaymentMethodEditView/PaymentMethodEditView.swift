//
//  PaymentMethodEditView.swift
//  Yakrm
//
//  Created by Krutik V. Poojara on 07/02/19.
//  Copyright © 2019 Krutik V. Poojara. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import MBProgressHUD
import Toaster

class PaymentMethodEditView: UIViewController, UITableViewDelegate, UITableViewDataSource {
    // MARK: - Outlet

    @IBOutlet var viewNavigation: UIView!
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var viewBorder: UIView!

    @IBOutlet var btnAdd: UIButton!

    @IBOutlet var tblView: UITableView!

    var app = AppDelegate()

    var arrList = [["Title": "By Using Pay Pal".localized, "Detail": "email@domain.dlt", "image": "paypal_icon.png"], ["Title": "By Using Mada Card".localized, "Detail": "**** **** **** 5678", "image": "payment_type_csmada_icon.png"],
                   ["Title": "By Using Credit Card".localized, "Detail": "**** **** **** 1234", "image": "payment_visa_icon.png"]]

    // MARK: -
    override func viewDidLoad() {
        super.viewDidLoad()
        app = UIApplication.shared.delegate as! AppDelegate

        self.viewNavigation.backgroundColor = UIColor.init(rgb: 0xEE4158)

        if DeviceType.IS_IPHONE_X || DeviceType.IS_IPHONE_XR {
            self.viewNavigation.frame = CGRect(x: self.viewNavigation.frame.origin.x, y: self.viewNavigation.frame.origin.y, width: self.viewNavigation.frame.size.width, height: 88)
            self.viewBorder.frame = CGRect(x: self.viewBorder.frame.origin.x, y: self.viewNavigation.frame.origin.y + self.viewNavigation.frame.size.height, width: self.viewBorder.frame.size.width, height: self.viewBorder.frame.size.height)
        }

        self.viewBorder.dropShadow(color: .lightGray, opacity: 1, offSet: CGSize(width: 0, height: 1), radius: 1, scale: true)

        self.btnAdd.layer.cornerRadius = 5

        self.tblView.delegate = self
        self.tblView.dataSource = self

    }

    @IBAction func btnBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func btnAddAnother(_ sender: UIButton) {

    }

    // MARK: - Tablview
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.arrList.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: PaymentCell!
        cell = tblView.dequeueReusableCell(withIdentifier: "PaymentCell") as! PaymentCell!
        if cell == nil {
            cell = Bundle.main.loadNibNamed("PaymentCell", owner: self, options: nil)?[0] as! PaymentCell!
        }

        var arrValue  = JSON(self.arrList)

        if self.app.isEnglish {
            cell.lblName.textAlignment = .left
            cell.lblDetails.textAlignment = .left
        } else {
            cell.lblName.textAlignment = .right
            cell.lblDetails.textAlignment = .right
        }

        let strName: String = arrValue[indexPath.section]["Title"].stringValue
        let strDetails: String = arrValue[indexPath.section]["Detail"].stringValue
        let strImage: String = arrValue[indexPath.section]["image"].stringValue
        cell.lblName.text = strName
        cell.lblDetails.text = strDetails
        cell.imgProfile.image = UIImage(named: strImage)!
        cell.imgEdit.image = UIImage(named: "new-file.png")!

        if DeviceType.IS_IPHONE_5 {
            cell.lblName.font = cell.lblName.font.withSize(10)
            cell.lblDetails.font = cell.lblName.font.withSize(10)
        }

        cell.selectionStyle = .none
        tblView.rowHeight = cell.frame.size.height

        cell.layer.borderWidth = 1
        cell.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.5).cgColor

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

}
