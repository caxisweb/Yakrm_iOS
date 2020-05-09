//
//  AlarmsView.swift
//  Yakrm
//
//  Created by Krutik V. Poojara on 17/12/18.
//  Copyright © 2018 Krutik V. Poojara. All rights reserved.
//

import UIKit

class AlarmsView: UIViewController, UITableViewDelegate, UITableViewDataSource {
    // MARK: - Outlet
    @IBOutlet var viewNavigation: UIView!
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
    }

    @IBAction func btnBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }

    // MARK: - Tablview
    func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: AlarmsCell!
        cell = tblView.dequeueReusableCell(withIdentifier: "AlarmsCell") as! AlarmsCell!
        if cell == nil {
            cell = Bundle.main.loadNibNamed("AlarmsCell", owner: self, options: nil)?[0] as! AlarmsCell!
        }

        var img = UIImage()
        if indexPath.row % 2 == 0 {
            img = UIImage(named: "Screenshot 2018-12-11 at 3.53.07 PM.png")!
        } else {
            img = UIImage(named: "Screenshot 2018-12-11 at 3.53.18 PM.png")!
        }
        cell.imgProfile.image = img

        if self.app.isEnglish {
            cell.lblName.textAlignment = .left
            cell.lblDate.textAlignment = .left
        } else {
            cell.lblName.textAlignment = .right
            cell.lblDate.textAlignment = .right
        }
        if DeviceType.IS_IPHONE_5 {
            cell.lblName.font = cell.lblName.font.withSize(9)
            cell.lblDate.font = cell.lblDate.font.withSize(8)
            cell.lblNew.font = cell.lblNew.font.withSize(9)
        }

        var width: CGFloat = 0.0
        if indexPath.row == 0 {
            cell.lblNew.isHidden = false
            width = cell.lblName.frame.size.width
        } else {
            cell.lblNew.isHidden = true
            width = cell.lblName.frame.size.width + cell.lblNew.frame.size.width + 10
        }
        cell.lblNew.text = "New".localized

        let rectTitle = cell.lblName.text!.boundingRect(with: CGSize(width: width, height: CGFloat(50000)), options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: cell.lblName.font], context: nil)

        cell.lblName.frame = CGRect(x: cell.lblName.frame.origin.x, y: cell.lblName.frame.origin.y, width: width, height: (rectTitle.size.height))
        cell.lblDate.frame = CGRect(x: cell.lblDate.frame.origin.x, y: cell.lblName.frame.origin.y + cell.lblName.frame.size.height, width: cell.lblDate.frame.size.width, height: cell.lblDate.frame.size.height)
        cell.viewLine.frame = CGRect(x: cell.viewLine.frame.origin.x, y: cell.lblDate.frame.origin.y + cell.lblDate.frame.size.height + 10, width: cell.viewLine.frame.size.width, height: cell.viewLine.frame.size.height)

        cell.lblNew.layer.cornerRadius = 4
        cell.lblNew.clipsToBounds = true

        cell.btnDelete.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        cell.btnDelete.tag = indexPath.row

        cell.selectionStyle = .none
        tblView.rowHeight = cell.viewLine.frame.origin.y + cell.viewLine.frame.size.height//cell.frame.size.height

        return cell
    }

    @objc func buttonAction(sender: UIButton!) {
        let buttonPosition: CGPoint = sender.convert(CGPoint.zero, to: self.tblView)
        let indexPath: IndexPath = self.tblView.indexPathForRow(at: buttonPosition)!

        let alertController = UIAlertController(title: "Are you sure You want to Delete ?", message: nil, preferredStyle: .alert)

        let cancelAction = UIAlertAction(title: "Cancel", style: .default) { (_: UIAlertAction!) in
            print("you have pressed the Cancel button")
        }
        alertController.addAction(cancelAction)

        let OKAction = UIAlertAction(title: "Delete", style: .destructive) { (_: UIAlertAction!) in
            print("you have pressed OK button")
            print("Section : \(indexPath.section) Row : \(indexPath.row)")
        }
        alertController.addAction(OKAction)

        self.present(alertController, animated: true, completion: nil)
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let viewHeader = UIView()
        viewHeader.frame = CGRect(x: 0, y: 0, width: tblView.frame.size.width, height: 40)
        viewHeader.backgroundColor = UIColor.white

        let vv = UIView()
        vv.frame =  viewHeader.frame
        vv.backgroundColor = UIColor.init(rgb: 0xCBCBCB).withAlphaComponent(0.5)

        let lbl = UILabel()
        lbl.frame = CGRect(x: 15, y: 0, width: tblView.frame.size.width-30, height: 40)
        var lblFontSize: CGFloat = 10
        if DeviceType.IS_IPHONE_5 {
            lblFontSize = 9
        }
//        lbl.font = UIFont (name: "GE SS Two Medium", size: lblFontSize)
        lbl.font = UIFont.systemFont(ofSize: lblFontSize, weight: .medium)
        lbl.backgroundColor = UIColor.clear
        if self.app.isEnglish {
            lbl.textAlignment = .left
        } else {
            lbl.textAlignment = .right
        }
        lbl.textColor = UIColor.darkGray
        viewHeader.addSubview(vv)
        viewHeader.addSubview(lbl)
        lbl.text = "Yesterday".localized

        return viewHeader
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }

    @IBAction func btnDeleteAll(_ sender: UIButton) {
        let alertController = UIAlertController(title: "Are you sure You want to Delete All ?", message: nil, preferredStyle: .alert)

        let cancelAction = UIAlertAction(title: "NO", style: .default) { (_: UIAlertAction!) in
            print("you have pressed the Cancel button")
        }
        alertController.addAction(cancelAction)

        let OKAction = UIAlertAction(title: "YES", style: .destructive) { (_: UIAlertAction!) in
            print("you have pressed OK button")

        }
        alertController.addAction(OKAction)

        self.present(alertController, animated: true, completion: nil)
    }

}
