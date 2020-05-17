//
//  TermsView.swift
//  Yakrm
//
//  Created by Krutik V. Poojara on 17/12/18.
//  Copyright © 2018 Krutik V. Poojara. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import MBProgressHUD
import Toaster

@available(iOS 11.0, *)
class TermsView: UIViewController {
    // MARK: - Outlet
    @IBOutlet var viewNavigation: UIView!
    @IBOutlet var lblTITLE: UILabel!
    @IBOutlet var scrollView: UIScrollView!

    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var lblDetails: UILabel!

    var loadingNotification: MBProgressHUD!
    var json: JSON!
    var strMessage: String!

    var app = AppDelegate()

    // MARK: -
    override func viewDidLoad() {
        super.viewDidLoad()
        app = UIApplication.shared.delegate as! AppDelegate

        self.viewNavigation.backgroundColor = UIColor.init(rgb: 0xEE4158)
        self.scrollView.isHidden = true

        if DeviceType.IS_IPHONE_X || DeviceType.IS_IPHONE_XR {
            self.viewNavigation.frame = CGRect(x: self.viewNavigation.frame.origin.x, y: self.viewNavigation.frame.origin.y, width: self.viewNavigation.frame.size.width, height: 88)
            self.scrollView.frame = CGRect(x: self.scrollView.frame.origin.x, y: self.viewNavigation.frame.origin.y + self.viewNavigation.frame.size.height, width: self.scrollView.frame.size.width, height: ScreenSize.SCREEN_HEIGHT - self.viewNavigation.frame.size.height)
        }

        if DeviceType.IS_IPHONE_5 {
            self.lblTitle.font = self.lblTitle.font.withSize(self.lblTitle.font.pointSize-2)
            self.lblDetails.font = self.lblDetails.font.withSize(self.lblDetails.font.pointSize-2)
        }

        if self.app.isEnglish {
            self.lblTitle.textAlignment = .left
            self.lblDetails.textAlignment = .left
            self.lblTITLE.textAlignment = .left
        } else {
            self.lblTitle.textAlignment = .right
            self.lblDetails.textAlignment = .right
            self.lblTITLE.textAlignment = .right

            self.lblTITLE.text = "اتفاقية الإستخدام وسياسة الخصوصية"
        }
        self.lblTITLE.text = "User Agreement And Privacy Policy".localized

        let strDetails = "Here, You Find Voucher Cards  Sent By Your Friends".localized + " " + "You Can Transform It Into Wallet Cards And Use It In purchasing And Discount Process".localized

        self.lblDetails.text = ""//strDetails + strDetails

        if self.app.isConnectedToInternet() {
            self.GetAboutApplicationAPI()
        } else {
            Toast(text: self.app.InternetConnectionMessage.localized).show()
        }
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

    // MARK: - Get About Application API
    func GetAboutApplicationAPI() {

        let headers: HTTPHeaders = ["Content-Type": "application/json"]

        AppWebservice.shared.request("\(self.app.BaseURL)get_about_application", method: .get, parameters: nil, headers: headers, loader: true) { (statusCode, response, error) in
            
            if statusCode == 200 {
                
                        self.json = response
                        
                        let strStatus: String = self.json["status"].stringValue
                        self.strMessage = self.json["message"].stringValue

                        if strStatus == "1" {
                            self.scrollView.isHidden = false
                            var strAbout = String()
                            if self.app.isEnglish {
                                strAbout = self.json["terms_and_condition_english"].stringValue
                            } else {
                                strAbout = self.json["terms_and_condition_arab"].stringValue
                            }
                            let Font = self.lblDetails.font
                            self.lblDetails.attributedText = strAbout.html2AttributedString
                            let rectTitle = strAbout.html2AttributedString?.string.boundingRect(with: CGSize(width: self.lblDetails.frame.size.width, height: CGFloat(50000)), options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: self.lblDetails.font], context: nil)

                            self.lblDetails.frame = CGRect(x: self.lblDetails.frame.origin.x, y: self.lblDetails.frame.origin.y, width: self.lblDetails.frame.size.width, height: (rectTitle!.size.height))
                            self.lblDetails.font = Font
                            self.setScrollViewHeight()
                        } else {
                            Toast(text: self.strMessage).show()
                        }
            } else {
                Toast(text: self.app.RequestTimeOut.localized).show()
            }
        }
    }
}
