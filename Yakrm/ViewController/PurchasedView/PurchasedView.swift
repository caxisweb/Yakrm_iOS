//
//  PurchasedView.swift
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

class PurchasedView: UIViewController, UITableViewDelegate, UITableViewDataSource {
    // MARK: - Outlet
    @IBOutlet var viewNavigation: UIView!
    @IBOutlet var viewBorder: UIView!

    @IBOutlet var viewDetails: UIView!
    @IBOutlet var btnComplete: UIButton!
    @IBOutlet var lblBalance: UILabel!
    @IBOutlet var lblTotal: UILabel!

    @IBOutlet var viewPurchase: UIView!
    @IBOutlet var viewSuccess: UIView!
    @IBOutlet var viewFail: UIView!

    @IBOutlet var viewBalance: UIView!
    @IBOutlet var viewBalanceTop: UIView!
    @IBOutlet var viewBalanceBottom: UIView!
    @IBOutlet var lblNotEnough: UILabel!
    @IBOutlet var lblBalancePrice: UILabel!
    @IBOutlet var lblCHANGEACC: UILabel!

    @IBOutlet var tblView: UITableView!

    var loadingNotification: MBProgressHUD!
    var json: JSON!
    var strMessage: String!

    var app = AppDelegate()

    var strTotal = String()

    var isPayment = Bool()

    var arrList = [["Title": "By Using Mada Card".localized, "Detail": "**** **** **** 5678", "image": "payment_type_csmada_icon.png"],
                   ["Title": "By Using Credit Card".localized, "Detail": "**** **** **** 1234", "image": "payment_visa_icon.png"]]
//    var arrList = [["Title":"By Using Pay Pal".localized,"Detail":"email@domain.dlt","image":"paypal_icon.png"],              ["Title":"By Using Mada Card".localized,"Detail":"**** **** **** 5678","image":"payment_type_csmada_icon.png"],
//                   ["Title":"By Using Credit Card".localized,"Detail":"**** **** **** 1234","image":"payment_visa_icon.png"]]

//    var initialSetupViewController: PTFWInitialSetupViewController!

    // MARK: -
    override func viewDidLoad() {
        super.viewDidLoad()
        app = UIApplication.shared.delegate as! AppDelegate

        self.viewNavigation.backgroundColor = UIColor.init(rgb: 0xEE4158)

        if DeviceType.IS_IPHONE_X || DeviceType.IS_IPHONE_XR {
            self.viewNavigation.frame = CGRect(x: self.viewNavigation.frame.origin.x, y: self.viewNavigation.frame.origin.y, width: self.viewNavigation.frame.size.width, height: 88)
            self.viewDetails.frame = CGRect(x: self.viewDetails.frame.origin.x, y: self.viewNavigation.frame.origin.y + self.viewNavigation.frame.size.height, width: self.viewDetails.frame.size.width, height: ScreenSize.SCREEN_HEIGHT - self.viewNavigation.frame.size.height)
            self.viewPurchase.frame = self.viewDetails.frame
            self.viewBalance.frame = self.viewDetails.frame
        }
        if DeviceType.IS_IPHONE_5 {
            self.lblBalance.font = self.lblBalance.font.withSize(self.lblBalance.font.pointSize-2)

            self.lblNotEnough.font = self.lblNotEnough.font.withSize(self.lblNotEnough.font.pointSize-2)
//            self.lblTOTAL.font = self.lblTOTAL.font.withSize(self.lblTOTAL.font.pointSize-2)
            self.lblBalancePrice.font = self.lblBalancePrice.font.withSize(self.lblBalancePrice.font.pointSize-1)
//            self.lblRS.font = self.lblRS.font.withSize(self.lblRS.font.pointSize-2)
//            self.lblCHANGE.font = self.lblCHANGE.font.withSize(self.lblCHANGE.font.pointSize-2)
            self.lblCHANGEACC.font = self.lblCHANGEACC.font.withSize(self.lblCHANGEACC.font.pointSize-2)
        }

        if self.app.isEnglish {
            self.lblCHANGEACC.textAlignment = .left
        } else {
            self.lblCHANGEACC.textAlignment = .right
        }

        self.lblBalance.text = "Balance".localized + " \(self.app.strWallet) " + "SR".localized
        let strSR: String = "SR".localized
//        self.lblTotal.text = self.strTotal
//        self.lblBalancePrice.text = self.strTotal

        let strAttDiscount = NSMutableAttributedString(string: "\(self.strTotal) \(strSR)")
        strAttDiscount.setColorForText(strSR, with: UIColor.black)
        self.lblTotal.attributedText = strAttDiscount
        self.lblBalancePrice.attributedText = strAttDiscount

        self.viewBorder.dropShadow(color: .lightGray, opacity: 1, offSet: CGSize(width: 0, height: 1), radius: 1, scale: true)
        self.viewSuccess.dropShadow(color: .lightGray, opacity: 1, offSet: CGSize(width: 0, height: 1), radius: 1, scale: true)
        self.viewFail.dropShadow(color: .lightGray, opacity: 1, offSet: CGSize(width: 0, height: 1), radius: 1, scale: true)

        self.viewBalanceTop.dropShadow(color: .lightGray, opacity: 1, offSet: CGSize(width: 0, height: 1), radius: 1, scale: true)
        self.viewBalanceBottom.dropShadow(color: .lightGray, opacity: 1, offSet: CGSize(width: 0, height: 1), radius: 1, scale: true)

        self.viewPurchase.isHidden = true
        self.viewBalance.isHidden = true
        self.btnComplete.layer.cornerRadius = 5

        self.tblView.delegate = self
        self.tblView.dataSource = self

        self.lblNotEnough.layer.cornerRadius = 5
        self.lblNotEnough.clipsToBounds = true

    }

    @IBAction func btnBack(_ sender: UIButton) {
        if self.isPayment {
            let desiredViewController = self.navigationController!.viewControllers.filter { $0 is HomeView }.first!
            self.navigationController!.popToViewController(desiredViewController, animated: true)
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }

    @IBAction func btnComplete(_ sender: UIButton) {
        self.viewDetails.isHidden = true
        self.viewBalance.isHidden = false
//        ProjectUtility.animatePopupView(viewPopup: self.viewBalance, viewDetails: self.viewBalance)
//        let alertController = UIAlertController(title: "Are you sure ?", message: nil, preferredStyle: .alert)
//
//        let cancelAction = UIAlertAction(title: "NO", style: .default) { (action:UIAlertAction!) in
//            print("you have pressed the Cancel button")
//        }
//        alertController.addAction(cancelAction)
//
//        let OKAction = UIAlertAction(title: "YES", style: .default) { (action:UIAlertAction!) in
//            print("you have pressed OK button")
//
//            if self.app.isConnectedToInternet()
//            {
//                self.VoucherPurchaseAPI()
//            }
//            else
//            {
//                Toast(text: self.app.InternetConnectionMessage).show()
//            }
//        }
//        alertController.addAction(OKAction)
//
//        self.present(alertController, animated: true, completion:nil)
    }

    @IBAction func btnAllAction(_ sender: UIButton) {
        if sender.tag == 1 {
            let desiredViewController = self.navigationController!.viewControllers.filter { $0 is HomeView }.first!
            self.navigationController!.popToViewController(desiredViewController, animated: true)
        } else {
            self.navigationController?.popViewController(animated: true)
        }
//        let VC = self.storyboard?.instantiateViewController(withIdentifier: "PaymentView") as! PaymentView
//        self.navigationController?.pushViewController(VC, animated: true)
    }

    // MARK: - Voucher Purchase API
    func VoucherPurchaseAPI() {
        loadingNotification = MBProgressHUD.showAdded(to: self.view, animated: false)
        loadingNotification.mode = MBProgressHUDMode.indeterminate
        loadingNotification.label.text = "Loading..."
//        loadingNotification.dimBackground = true

        let headers: HTTPHeaders = ["Authorization": self.app.strToken,
                                     "Content-Type": "application/json"]
        print(JSON(headers))

        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let myString = formatter.string(from: Date()) // string purpose I add here
        let yourDate = formatter.date(from: myString)
        formatter.dateFormat = "yyyyMMddHHmmss"
        let strTransactionID = formatter.string(from: yourDate!)

        let parameters: Parameters = ["transaction_id": strTransactionID]
        print(JSON(parameters))

        AppWebservice.shared.request("\(self.app.BaseURL)voucher_purchase", method: .post, parameters: parameters, headers: headers, loader: true) { (statusCode, response, error) in

            if statusCode == 200 {
                self.json = response!
                print(self.json)

                let strStatus: String = self.json["status"].stringValue
                self.strMessage = self.json["message"].stringValue

                Toast(text: self.strMessage).show()
                self.viewBalance.isHidden = true
                if strStatus == "1" {
                    self.viewFail.isHidden = true
                    ProjectUtility.animatePopupView(viewPopup: self.viewPurchase, viewDetails: self.viewSuccess)
                    self.isPayment = true
                } else {
                    self.viewSuccess.isHidden = true
                    ProjectUtility.animatePopupView(viewPopup: self.viewPurchase, viewDetails: self.viewFail)
                }
            } else {
                Toast(text: error?.localizedDescription).show()
            }
        }
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

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let VC = self.storyboard?.instantiateViewController(withIdentifier: "PaymentMethodView") as! PaymentMethodView
        self.navigationController?.pushViewController(VC, animated: true)

//        let alertController = UIAlertController(title: "Are you sure ?", message: nil, preferredStyle: .alert)
//
//        let cancelAction = UIAlertAction(title: "NO", style: .default) { (action:UIAlertAction!) in
//            print("you have pressed the Cancel button")
//        }
//        alertController.addAction(cancelAction)
//
//        let OKAction = UIAlertAction(title: "YES", style: .default) { (action:UIAlertAction!) in
//            print("you have pressed OK button")
//
//            if self.app.isConnectedToInternet()
//            {
//                self.VoucherPurchaseAPI()
//            }
//            else
//            {
//                Toast(text: self.app.InternetConnectionMessage).show()
//            }
//        }
//        alertController.addAction(OKAction)
//
//        self.present(alertController, animated: true, completion:nil)
    }
//
//    // MARK: Private Methods
//    // MARK: Objects
//    private func initiateSDK()
//    {
//        self.launcherView.endEditing(true)
//        let bundle = Bundle(url: Bundle.main.url(forResource: ApplicationResources.kFrameworkResourcesBundle, withExtension: "bundle")!)
//
//        self.initialSetupViewController = PTFWInitialSetupViewController.init(
//            nibName: ApplicationXIBs.kPTFWInitialSetupView,
//            bundle: bundle,
//            andWithViewFrame: self.view.frame,
//            andWithAmount: Float(2),
//            andWithCustomerTitle: "PayTabs",
//            andWithCurrencyCode: "SAR", //
//            andWithTaxAmount: 0.0,
//            andWithSDKLanguage: "en", // language
//            andWithShippingAddress: "عُنوان البَريد الإلِكتْروني",
//            andWithShippingCity: "jeddah عَنوِن / يَكتُب العُنوان™™™ 29393 .. 48493 $",
//            andWithShippingCountry: "BHR",
//            andWithShippingState: "123",
//            andWithShippingZIPCode: "NBsdjbd.",
//            andWithBillingAddress: "عُنوان البَريد الإلِكتْروني",
//            andWithBillingCity: "Manama",
//            andWithBillingCountry: "BHR",
//            andWithBillingState: "Manama",
//            andWithBillingZIPCode: "0097",
//            andWithOrderID: "00987",
//            andWithPhoneNumber: "0097335532915",
//            andWithCustomerEmail: "abc@gmail.com",
//            andIsTokenization: false,
//            andWithMerchantEmail: "s@gmail.com",
//            andWithMerchantSecretKey: "ex2SHCqdgtJlrF2gp5fGCis3tUGh5EkjcmcTZD7g6RCxwEOWJ3Cml4qOY664KroXOBQNeY3lPFTlkHh4KUq6YQVXW22HtrFh2w4g",
//            andWithAssigneeCode: "SDK",
//            andWithThemeColor: UIColor.lightGray,
//            andIsThemeColorLight: true)
//
//        //        weak var weakSelf = self
//        self.initialSetupViewController.didReceiveBackButtonCallback = {
//            //            weakSelf?.handleBackButtonTapEvent()
//            self.initialSetupViewController.willMove(toParentViewController: self)
//            self.initialSetupViewController.view.removeFromSuperview()
//            self.initialSetupViewController.removeFromParentViewController()
//        }
//
//        self.initialSetupViewController.didReceiveFinishTransactionCallback = {(responseCode, result, transactionID, tokenizedCustomerEmail, tokenizedCustomerPassword, token, transactionState) in
//            //handle response code , result , transactionID , transaction state
//            print(responseCode,result)
//
//            self.initialSetupViewController.willMove(toParentViewController: self)
//            self.initialSetupViewController.view.removeFromSuperview()
//            self.initialSetupViewController.removeFromParentViewController()
//            //go to whatever u want to go
//
//        }
//    }
}
