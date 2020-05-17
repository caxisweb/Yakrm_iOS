//
//  CouponDetailsView.swift
//  Yakrm
//
//  Created by Krutik V. Poojara on 15/12/18.
//  Copyright © 2018 Krutik V. Poojara. All rights reserved.
//

import UIKit
import SwiftyJSON

@available(iOS 11.0, *)
@available(iOS 11.0, *)
class CouponDetailsView: UIViewController {
    // MARK: - Outlet
    @IBOutlet var viewNavigation: UIView!
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var viewBorder: UIView!

    @IBOutlet var imgProfile: UIImageView!
    @IBOutlet var lblName: UILabel!
    @IBOutlet var lblSCAN: UILabel!
    @IBOutlet var lblOR: UILabel!

    @IBOutlet var btnClear: UIButton!
    @IBOutlet var btnMenual: UIButton!

    var app = AppDelegate()

    var json: JSON!

    // MARK: -
    override func viewDidLoad() {
        super.viewDidLoad()
        app = UIApplication.shared.delegate as! AppDelegate

        self.btnClear.layer.cornerRadius = 5
        self.viewNavigation.backgroundColor = UIColor.init(rgb: 0xEE4158)

        if json != nil {
            let strName: String = json["brand_name"].stringValue
            var strImage: String = json["brand_image"].stringValue
            strImage = strImage.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!

            self.imgProfile.sd_setImage(with: URL(string: "\(self.app.ImageURL)brand_images/\(strImage)"), placeholderImage: nil)
            self.lblName.text = strName
        }

        if DeviceType.IS_IPHONE_X || DeviceType.IS_IPHONE_XR {
            self.viewNavigation.frame = CGRect(x: self.viewNavigation.frame.origin.x, y: self.viewNavigation.frame.origin.y, width: self.viewNavigation.frame.size.width, height: 88)
            self.scrollView.frame = CGRect(x: self.scrollView.frame.origin.x, y: self.viewNavigation.frame.origin.y + self.viewNavigation.frame.size.height, width: self.scrollView.frame.size.width, height: ScreenSize.SCREEN_HEIGHT - self.viewNavigation.frame.size.height)
        }

        if DeviceType.IS_IPHONE_5 {
            self.lblName.font = self.lblName.font.withSize(self.lblName.font.pointSize-2)
            self.lblSCAN.font = self.lblSCAN.font.withSize(self.lblSCAN.font.pointSize-2)
            self.lblOR.font = self.lblOR.font.withSize(self.lblOR.font.pointSize-2)

            self.btnClear.titleLabel!.font = self.btnClear.titleLabel!.font.withSize(self.btnClear.titleLabel!.font.pointSize-2)
            self.btnMenual.titleLabel!.font = self.btnMenual.titleLabel!.font.withSize(self.btnMenual.titleLabel!.font.pointSize-2)
        }

        if self.app.isEnglish {
            self.lblTitle.textAlignment = .left
        } else {
            self.lblTitle.textAlignment = .right
//            self.lblSCAN.text = "قم بعمل ماسح ضوئي للبطاقة لجلب بيانات البطاقة تلقائيا"
//            self.btnMenual.setTitle("إدخال البيانات يدويا في حالة فشل المسح الضوئي", for: .normal)
        }
        self.lblSCAN.text = "Scan The Card To Bring The Data Automatically".localized
        self.btnMenual.setTitle("Enter Data Manually In Case Scanning Is Failed".localized, for: .normal)

        self.viewBorder.dropShadow(color: .lightGray, opacity: 1, offSet: CGSize(width: 0, height: 1), radius: 1, scale: true)

        self.setScrollViewHeight()
    }

    func setScrollViewHeight() {
        for viewAll: UIView in scrollView.subviews {
            if viewAll.tag == 100 {
                scrollView.contentSize = CGSize(width: CGFloat(scrollView.frame.size.width), height: CGFloat(viewAll.frame.origin.y + viewAll.frame.size.height + 15))
            }
        }
    }

    @IBAction func btnBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func btnAllAction(_ sender: UIButton) {
        if sender.tag == 1 {
            let VC = self.storyboard?.instantiateViewController(withIdentifier: "BarcodeView") as! BarcodeView
            VC.strBrandID = self.json["id"].stringValue
            VC.strName = self.json["brand_name"].stringValue
            VC.strImage = self.json["brand_image"].stringValue
            self.navigationController?.pushViewController(VC, animated: true)
        } else {
            let VC = self.storyboard?.instantiateViewController(withIdentifier: "UpdateCouponView") as! UpdateCouponView
            VC.json = self.json
            self.navigationController?.pushViewController(VC, animated: true)
        }
    }

}
