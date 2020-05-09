//
//  CouponNearEndView.swift
//  Yakrm
//
//  Created by Krutik V. Poojara on 17/12/18.
//  Copyright © 2018 Krutik V. Poojara. All rights reserved.
//

import UIKit

class CouponNearEndView: UIViewController, UITableViewDelegate, UITableViewDataSource {
    // MARK: - Outlet
    @IBOutlet var viewNavigation: UIView!
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var tblView: UITableView!

    var app = AppDelegate()

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
    }

    @IBAction func btnBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }

    // MARK: - Tablview
    func numberOfSections(in tableView: UITableView) -> Int {
        return 20
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: CouponNearEndCell!
        cell = tblView.dequeueReusableCell(withIdentifier: "CouponNearEndCell") as! CouponNearEndCell!
        if cell == nil {
            cell = Bundle.main.loadNibNamed("CouponNearEndCell", owner: self, options: nil)?[0] as! CouponNearEndCell!
        }

        var img = UIImage()
        if indexPath.section % 2 == 0 {
            img = UIImage(named: "Screenshot 2018-12-11 at 3.53.07 PM.png")!
        } else {
            img = UIImage(named: "Screenshot 2018-12-11 at 3.53.18 PM.png")!
        }
        cell.imgProfile.image = img

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
        cell.lblDiscount.text = "\(indexPath.row) " + "Discounts Of Voucher".localized

        let strAvailable = "Available Till".localized + "13/13/2018"
        let strFor = "(For The Coming 2 Days Only)".localized
        let strBy = NSMutableAttributedString(string: "\(strAvailable)\(strFor)")
        strBy.setColorForText(strFor, with: UIColor.init(rgb: 0xE8385A))
        cell.lblDate.attributedText = strBy

        cell.lblPrice.text = "\(indexPath.row)0" + "SR".localized

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

}
