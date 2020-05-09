//
//  FavoriteBrandView.swift
//  Yakrm
//
//  Created by Krutik V. Poojara on 20/12/18.
//  Copyright © 2018 Krutik V. Poojara. All rights reserved.
//

import UIKit

class FavoriteBrandView: UIViewController, UITableViewDelegate, UITableViewDataSource {
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
        if self.app.isEnglish {
            self.lblTitle.textAlignment = .left
        } else {
            self.lblTitle.textAlignment = .right
        }
        self.tblView.delegate = self
        self.tblView.dataSource = self
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
        var cell: FavoriteBrandCell!
        cell = tblView.dequeueReusableCell(withIdentifier: "FavoriteBrandCell") as! FavoriteBrandCell!
        if cell == nil {
            cell = Bundle.main.loadNibNamed("FavoriteBrandCell", owner: self, options: nil)?[0] as! FavoriteBrandCell!
        }

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
        cell.lblDetail.text = "\(indexPath.section) " + "Discounts Of Voucher".localized

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

}
