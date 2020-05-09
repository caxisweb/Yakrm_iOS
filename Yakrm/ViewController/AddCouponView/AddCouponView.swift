//
//  AddCouponView.swift
//  Yakrm
//
//  Created by Krutik V. Poojara on 15/12/18.
//  Copyright © 2018 Krutik V. Poojara. All rights reserved.
//

import UIKit

class AddCouponView: UIViewController, UITextFieldDelegate {
    // MARK: - Outlet

    @IBOutlet var viewNavigation: UIView!
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var viewBorder: UIView!

    @IBOutlet var imgProfile: UIImageView!
    @IBOutlet var lblName: UILabel!
    @IBOutlet var imgBarcode: UIImageView!

    @IBOutlet var txtVoucherNumber: UITextField!
    @IBOutlet var txtPinNumber: UITextField!
    @IBOutlet var txtPrice: UITextField!
    @IBOutlet var txtDate: UITextField!

    @IBOutlet var viewVoucher: UIView!
    @IBOutlet var viewPin: UIView!
    @IBOutlet var viewPrice: UIView!
    @IBOutlet var viewDate: UIView!

    @IBOutlet var lblVoucher: UILabel!
    @IBOutlet var lblPin: UILabel!
    @IBOutlet var lblPrice: UILabel!
    @IBOutlet var lblDate: UILabel!

    @IBOutlet var btnAdd: UIButton!

    var app = AppDelegate()
    var strNumber = String()

    // MARK: -
    override func viewDidLoad() {
        super.viewDidLoad()
        app = UIApplication.shared.delegate as! AppDelegate

        self.viewNavigation.backgroundColor = UIColor.init(rgb: 0xEE4158)

        self.txtVoucherNumber.text = strNumber
        self.imgBarcode.image = Barcode.fromString(string: strNumber)

        if DeviceType.IS_IPHONE_X || DeviceType.IS_IPHONE_XR {
            self.viewNavigation.frame = CGRect(x: self.viewNavigation.frame.origin.x, y: self.viewNavigation.frame.origin.y, width: self.viewNavigation.frame.size.width, height: 88)
            self.scrollView.frame = CGRect(x: self.scrollView.frame.origin.x, y: self.viewNavigation.frame.origin.y + self.viewNavigation.frame.size.height, width: self.scrollView.frame.size.width, height: ScreenSize.SCREEN_HEIGHT - self.viewNavigation.frame.size.height)
        }

        if DeviceType.IS_IPHONE_5 {
            self.lblName.font = self.lblName.font.withSize(self.lblName.font.pointSize-2)
            self.lblVoucher.font = self.lblVoucher.font.withSize(self.lblVoucher.font.pointSize-1)
            self.lblPin.font = self.lblPin.font.withSize(self.lblPin.font.pointSize-1)
            self.lblPrice.font = self.lblPrice.font.withSize(self.lblPrice.font.pointSize-1)
            self.lblDate.font = self.lblDate.font.withSize(self.lblDate.font.pointSize-1)

            self.txtVoucherNumber.font = self.txtVoucherNumber.font!.withSize(self.txtVoucherNumber.font!.pointSize-2)
            self.txtPinNumber.font = self.txtPinNumber.font!.withSize(self.txtPinNumber.font!.pointSize-2)
            self.txtPrice.font = self.txtPrice.font!.withSize(self.txtPrice.font!.pointSize-2)
            self.txtDate.font = self.txtDate.font!.withSize(self.txtDate.font!.pointSize-2)

            self.btnAdd.titleLabel!.font = self.btnAdd.titleLabel!.font.withSize(self.btnAdd.titleLabel!.font.pointSize-2)
        }

        if self.app.isEnglish {
            self.lblTitle.textAlignment = .left
        } else {
            self.lblTitle.textAlignment = .right
        }
        self.viewBorder.dropShadow(color: .lightGray, opacity: 1, offSet: CGSize(width: 0, height: 1), radius: 1, scale: true)

        self.btnAdd.layer.cornerRadius = 5

        self.setTextfildDesign(txt: self.txtVoucherNumber, vv: self.viewVoucher, lbl: self.lblVoucher)
        self.setTextfildDesign(txt: self.txtPinNumber, vv: self.viewPin, lbl: self.lblPin)
        self.setTextfildDesign(txt: self.txtPrice, vv: self.viewPrice, lbl: self.lblPrice)
        self.setTextfildDesign(txt: self.txtDate, vv: self.viewDate, lbl: self.lblDate)

        self.setScrollViewHeight()
    }

    func setTextfildDesign(txt: UITextField, vv: UIView, lbl: UILabel) {
        if self.app.isEnglish {
            txt.textAlignment = .left
            lbl.textAlignment = .left
            if self.app.isLangEnglish {
                txt.setLeftPaddingPoints(vv)
            } else {
                txt.setRightPaddingPoints(vv)
            }
        } else {
            txt.textAlignment = .right
            lbl.textAlignment = .right
            if self.app.isLangEnglish {
                txt.setRightPaddingPoints(vv)
            } else {
                txt.setLeftPaddingPoints(vv)
            }
        }
        txt.placeHolderColor = UIColor.init(rgb: 0xEE4158)
        txt.delegate = self
    }

    func setScrollViewHeight() {
        for viewAll: UIView in scrollView.subviews {
            if viewAll.tag == 100 {
                scrollView.contentSize = CGSize(width: CGFloat(scrollView.frame.size.width), height: CGFloat(viewAll.frame.origin.y + viewAll.frame.size.height + 15))
            }
        }
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField .resignFirstResponder()
        return true
    }

    @IBAction func btnBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func btnAdd(_ sender: UIButton) {
        let VC = self.storyboard?.instantiateViewController(withIdentifier: "UpdateCouponView") as! UpdateCouponView
        self.navigationController?.pushViewController(VC, animated: true)
    }

}
