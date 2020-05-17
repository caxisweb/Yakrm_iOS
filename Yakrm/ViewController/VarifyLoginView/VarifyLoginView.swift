//
//  VarifyLoginView.swift
//  Yakrm
//
//  Created by Krutik V. Poojara on 06/12/18.
//  Copyright © 2018 Krutik V. Poojara. All rights reserved.
//

import UIKit
import PinCodeTextField

@available(iOS 11.0, *)
@available(iOS 11.0, *)
class VarifyLoginView: UIViewController, PinCodeTextFieldDelegate {
    // MARK: - Outlet

    @IBOutlet var viewNavigation: UIView!
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var viewBorder: UIView!

    @IBOutlet var lblStep: UILabel!
    @IBOutlet var lblEnterSecret: UILabel!

    @IBOutlet var txtCode: PinCodeTextField!

    @IBOutlet var btnCheck: UIButton!

    fileprivate lazy var allTextFields: [PinCodeTextField] = {
        let allTextFields: [PinCodeTextField] = [
        ]
        return allTextFields
    }()

    var app = AppDelegate()

    // MARK: -
    override func viewDidLoad() {
        super.viewDidLoad()
        app = UIApplication.shared.delegate as! AppDelegate

        self.viewNavigation.backgroundColor = UIColor.init(rgb: 0xEE4158)
        self.btnCheck.layer.cornerRadius = 5

        self.viewBorder.dropShadow(color: .lightGray, opacity: 1, offSet: CGSize(width: 0, height: 1), radius: 1, scale: true)

        if DeviceType.IS_IPHONE_X || DeviceType.IS_IPHONE_XR {
            self.viewNavigation.frame = CGRect(x: self.viewNavigation.frame.origin.x, y: self.viewNavigation.frame.origin.y, width: self.viewNavigation.frame.size.width, height: 88)
            self.scrollView.frame = CGRect(x: self.scrollView.frame.origin.x, y: self.viewNavigation.frame.origin.y + self.viewNavigation.frame.size.height, width: self.scrollView.frame.size.width, height: ScreenSize.SCREEN_HEIGHT - self.viewNavigation.frame.size.height)
        }

        if DeviceType.IS_IPHONE_5 {
            self.lblStep.font = self.lblStep.font.withSize(self.lblStep.font.pointSize-2)
            self.lblEnterSecret.font = self.lblEnterSecret.font.withSize(self.lblEnterSecret.font.pointSize-2)
        }

        if self.app.isEnglish {
            self.lblStep.textAlignment = .left
            self.lblEnterSecret.textAlignment = .left
        } else {
            self.lblStep.textAlignment = .right
            self.lblEnterSecret.textAlignment = .right
        }

        self.txtCode.layer.borderWidth = 1
        self.txtCode.layer.borderColor = UIColor.darkGray.withAlphaComponent(0.5).cgColor

        self.txtCode.keyboardType = .numberPad
        self.txtCode.delegate = self

        let flexibleButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel".localized, style: .plain, target: self, action: #selector(cancelClicked(_:)))

        let doneButton = UIBarButtonItem(title: "Done".localized, style: .plain, target: self, action: #selector(doneClicked(_:)))
        let toolbar = UIToolbar()
        toolbar.items = [cancelButton, flexibleButton, doneButton]

        toolbar.sizeToFit()

        self.allTextFields.append(txtCode)

        self.allTextFields.forEach { (textField) in
            textField.inputAccessoryView = toolbar
        }

    }

    func setScrollViewHeight() {
        for viewAll: UIView in scrollView.subviews {
            if viewAll.tag == 100 {
                scrollView.contentSize = CGSize(width: CGFloat(scrollView.frame.size.width), height: CGFloat(viewAll.frame.origin.y + viewAll.frame.size.height + 15))
            }
        }
    }

    @IBAction func doneClicked(_ sender: Any) {
        self.txtCode.resignFirstResponder()
    }

    @IBAction func cancelClicked(_ sender: Any) {
        self.txtCode.resignFirstResponder()
    }

    @available(iOS 11.0, *)
    @IBAction func btnCheck(_ sender: UIButton) {
        let VC = self.storyboard?.instantiateViewController(withIdentifier: "HomeView") as! HomeView
        self.navigationController?.pushViewController(VC, animated: true)
    }

    @IBAction func btnBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }

}
