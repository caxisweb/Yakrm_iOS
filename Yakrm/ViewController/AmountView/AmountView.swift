//
//  AmountView.swift
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
import SafariServices

@available(iOS 11.0, *)
class AmountView: UIViewController, UIWebViewDelegate, OPPCheckoutProviderDelegate, UITableViewDelegate, UITableViewDataSource, SFSafariViewControllerDelegate {
    // MARK: - Outlet

    @IBOutlet var viewNavigation: UIView!
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var viewBorder: UIView!

    @IBOutlet var imgProfile: UIImageView!
    @IBOutlet var lblName: UILabel!
    @IBOutlet var lblPrice: UILabel!
    //    @IBOutlet var lblYOUWILL: UILabel!
    //    @IBOutlet var lblAHOWMUCH: UILabel!
    //
    //    @IBOutlet var txtPrice: UITextField!
    @IBOutlet var btnComplete: UIButton!

    @IBOutlet var lblGeneral: UILabel!
    @IBOutlet var lblTextDetails: UILabel!

    @IBOutlet var viewTop: UIView!
    @IBOutlet var imgTopProfile: UIImageView!
    @IBOutlet var lblTopName: UILabel!
    @IBOutlet var lblTopPrice: UILabel!

    @IBOutlet var lblWalletAmount: UILabel!
    @IBOutlet var lblTotal: UILabel!

    @IBOutlet var viewPayment: UIView!
    @IBOutlet var viewNavPayment: UIView!
    @IBOutlet var webView: UIWebView!

    @IBOutlet var viewPopup: UIView!
    @IBOutlet var viewPopupDetails: UIView!
    @IBOutlet var lblPaymentGateway: UILabel!

    @IBOutlet var viewHyperPay: UIView!
    @IBOutlet var lblHyperPay: UILabel!

    @IBOutlet var viewPaytabs: UIView!
    @IBOutlet var lblPaytabs: UILabel!

    @IBOutlet var tblView: UITableView!

    var app = AppDelegate()

    var strVoucherID = String()
    var strVoucherPaymentID = String()
    var strImage = String()
    var strName = String()
    var strPrice = String()

    var loadingNotification: MBProgressHUD!
    var json: JSON!
    var strMessage: String!

    var PayPrice = Double()
    var strReplaceVoucherID = String()
    var strTransactionID = String()

    var initialSetupViewController: PTFWInitialSetupViewController!
    var priceflag = false
    var strCardID = String()
    var strCardName = String()
    var strCardNumber = String()
    var strCardMonth = String()
    var strCardYear = String()
    var strCardCVV = String()

    var checkoutProvider: OPPCheckoutProvider?
    var transaction: OPPTransaction?
    var strCheckoutID = String()

    var arrCardList: [Any] = []

    var provider: OPPPaymentProvider?
    var safariVC: SFSafariViewController?

    // MARK: -
    override func viewDidLoad() {
        super.viewDidLoad()
        app = UIApplication.shared.delegate as! AppDelegate

        self.viewNavigation.backgroundColor = UIColor.init(rgb: 0xEE4158)
        self.viewNavPayment.backgroundColor = UIColor.init(rgb: 0xEE4158)

        if DeviceType.IS_IPHONE_X || DeviceType.IS_IPHONE_XR {
            self.viewNavigation.frame = CGRect(x: self.viewNavigation.frame.origin.x, y: self.viewNavigation.frame.origin.y, width: self.viewNavigation.frame.size.width, height: 88)
            self.scrollView.frame = CGRect(x: self.scrollView.frame.origin.x, y: self.viewNavigation.frame.origin.y + self.viewNavigation.frame.size.height, width: self.scrollView.frame.size.width, height: ScreenSize.SCREEN_HEIGHT - self.viewNavigation.frame.size.height)

            self.viewNavPayment.frame = CGRect(x: self.viewNavPayment.frame.origin.x, y: self.viewNavPayment.frame.origin.y, width: self.viewNavPayment.frame.size.width, height: 88)
            self.webView.frame = CGRect(x: self.webView.frame.origin.x, y: self.viewNavPayment.frame.origin.y + self.viewNavPayment.frame.size.height, width: self.webView.frame.size.width, height: ScreenSize.SCREEN_HEIGHT - self.viewNavigation.frame.size.height)
        }

        if DeviceType.IS_IPHONE_5 {
            self.lblTopName.font = self.lblTopName.font.withSize(15)
            self.lblTopPrice.font = self.lblTopPrice.font.withSize(15)

            self.lblName.font = self.lblName.font.withSize(15)
            self.lblPrice.font = self.lblPrice.font.withSize(15)

            self.lblTotal.font = self.lblTotal.font.withSize(self.lblTotal.font.pointSize-1)
            self.lblWalletAmount.font = self.lblWalletAmount.font.withSize(self.lblWalletAmount.font.pointSize-1)

            self.btnComplete.titleLabel?.font = self.btnComplete.titleLabel?.font.withSize(14)

            self.lblGeneral.font = self.lblGeneral.font.withSize(15)
            self.lblTextDetails.font = self.lblTextDetails.font.withSize(13)
        }

        self.viewTop.backgroundColor = UIColor.white
        self.viewBorder.backgroundColor = UIColor.white
        self.viewTop.dropShadow(color: .lightGray, opacity: 1, offSet: CGSize(width: 0, height: 1), radius: 1, scale: true)
        self.viewBorder.dropShadow(color: .lightGray, opacity: 1, offSet: CGSize(width: 0, height: 1), radius: 1, scale: true)

        if self.app.isEnglish {
            self.lblName.textAlignment = .left
            self.lblPrice.textAlignment = .left
            self.lblTopName.textAlignment = .left
            self.lblTopPrice.textAlignment = .left
            //            self.lblYOUWILL.textAlignment = .left
            //            self.lblYOUWILL.textAlignment = .left
            self.lblGeneral.textAlignment = .left
            self.lblTextDetails.textAlignment = .left
            self.lblTitle.textAlignment = .left

            self.lblHyperPay.textAlignment = .left
            self.lblPaytabs.textAlignment = .left
        } else {
            self.lblName.textAlignment = .right
            self.lblPrice.textAlignment = .right
            self.lblTopName.textAlignment = .right
            self.lblTopPrice.textAlignment = .right
            //            self.lblYOUWILL.textAlignment = .right
            //            self.lblYOUWILL.textAlignment = .right
            self.lblGeneral.textAlignment = .right
            self.lblTextDetails.textAlignment = .right
            self.lblTitle.textAlignment = .right

            self.lblHyperPay.textAlignment = .right
            self.lblPaytabs.textAlignment = .right

            //            self.lblTitle.text = "استبدال وإضافة المبلغ إلى رصيدك"
            //            self.btnComplete.setTitle("اتمام عملية الاستبدال", for: .normal)
            //            self.lblGeneral.text = "تعليمات عامة"
        }

        self.lblTitle.text = "Exchanging And to my balance".localized//"استبدال وإضافة المبلغ إلى رصيدك"
        self.btnComplete.setTitle("COMPLETING EXCHANGE PROSESS".localized, for: .normal)
        self.lblGeneral.text = "General instructions".localized

        self.viewPopup.isHidden = true
        self.viewPopupDetails.center = self.view.center
        self.viewHyperPay.layer.borderWidth = 1
        self.viewHyperPay.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.5).cgColor
        self.viewPaytabs.layer.borderWidth = 1
        self.viewPaytabs.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.5).cgColor

        let TopPrice: Float = self.json["voucher_price"].floatValue
        self.strReplaceVoucherID = self.json["voucher_id"].stringValue
        self.lblTopName.text = self.json["brand_name"].stringValue
        self.lblTopPrice.text = "\(TopPrice) " + "SR".localized
        var strTopImage: String = self.json["brand_image"].stringValue
        strTopImage = strTopImage.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        self.imgTopProfile.sd_setImage(with: URL(string: "\(self.app.ImageURL)brand_images/\(strTopImage)"), placeholderImage: nil)

        self.imgProfile.sd_setImage(with: URL(string: "\(self.app.ImageURL)voucher_images/\(self.strImage)"), placeholderImage: nil)
        self.lblName.text = self.strName

        self.lblPrice.text = self.strPrice + " " + "SR".localized

        self.btnComplete.layer.cornerRadius = 5
        let strYouWill = "You Will Get The Amount Of".localized
        let strSROnly = "8.5 " + "SR Only".localized
        let strBy = NSMutableAttributedString(string: "\(strYouWill) \(strSROnly)")
        strBy.setColorForText(strSROnly, with: UIColor.init(rgb: 0xEE4158))
        //        self.lblYOUWILL.attributedText = strBy

        var strText = "Here, You Find Vouchers sent By Your Friends".localized + " " + "You Can Transform It Into Wallet Cards And Use It In purchasing And Discount Process".localized
        strText = strText + " " + strText
        self.lblTextDetails.text = strText + "\n\n" + strText

        //        self.txtPrice.layer.borderWidth = 1
        //        self.txtPrice.layer.borderColor = UIColor.darkGray.withAlphaComponent(0.5).cgColor
        //        self.txtPrice.placeHolderColor = UIColor.black
        //        self.txtPrice.placeHolderColor = UIColor.darkGray.withAlphaComponent(0.5)

        let rectTitle = self.lblTextDetails.text!.boundingRect(with: CGSize(width: CGFloat(self.lblTextDetails.frame.size.width), height: CGFloat(50000)), options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: self.lblTextDetails.font], context: nil)

        self.lblTextDetails.frame = CGRect(x: self.lblTextDetails.frame.origin.x, y: self.lblTextDetails.frame.origin.y, width: self.lblTextDetails.frame.size.width, height: (rectTitle.size.height))

        self.setScrollViewHeight()

        var wallet = Double()
        if self.app.strWallet.isEmpty {
            wallet = 0
        } else {
            wallet = Double(self.app.strWallet)!
        }

        let PerPrice: Float = Float(self.strPrice)! * self.app.AdminProfitDiscount / 100
        let FinalValue: Float = Float(self.strPrice)! - PerPrice

        if FinalValue < TopPrice //190  300
        {
            PayPrice = Double(TopPrice - FinalValue)
            if wallet > 0 {
                if wallet >= PayPrice {
                    PayPrice = 0
                } else {
                    PayPrice = PayPrice - wallet
                }
            }
        }

        if self.app.isEnglish {
            self.lblWalletAmount.text = "Wallet amount is ".localized + "\(wallet)" + " and the amount to be paid is".localized
        } else {
            self.lblWalletAmount.text = "مبلغ المحفظة هو".localized + " \(wallet) " + "والمبلغ الواجب دفعه هو".localized
        }

        self.lblTotal.text = "\(PayPrice) " + "SR".localized

        self.viewPayment.isHidden = true

        provider = OPPPaymentProvider(mode: .live)
    }

    override func viewWillAppear(_ animated: Bool) {
        if self.arrCardList.count == 0 {
            if self.app.isConnectedToInternet() {
                self.GetAllCardsOfUsersAPI()
            } else {
                Toast(text: self.app.InternetConnectionMessage.localized).show()
            }
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

    @IBAction func btnComplete(_ sender: UIButton) {
        if self.app.isConnectedToInternet() {
            if self.PayPrice > 0 {
                self.tblView.delegate = self
                self.tblView.dataSource = self
                self.tblView.reloadData()

                var count = self.arrCardList.count
                if count > 5 {
                    count = 5
                }
                let height: CGFloat = CGFloat(count * 65)
                self.tblView.frame = CGRect(x: self.tblView.frame.origin.x, y: self.tblView.frame.origin.y, width: self.tblView.frame.size.width, height: height)
                self.viewPopupDetails.frame = CGRect(x: self.viewPopupDetails.frame.origin.x, y: self.viewPopupDetails.frame.origin.y, width: self.viewPopupDetails.frame.size.width, height: height)
                self.viewPopupDetails.center = self.view.center
                ProjectUtility.animatePopupView(viewPopup: self.viewPopup, viewDetails: self.viewPopupDetails)
            } else {
                self.ReplaceVoucherAPI()
            }
        } else {
            Toast(text: self.app.InternetConnectionMessage.localized).show()
        }
    }

    private func initiateSDK() {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let myString = formatter.string(from: Date()) // string purpose I add here
        let yourDate = formatter.date(from: myString)
        formatter.dateFormat = "yyyyMMddHHmmss"
        let strOrderID = formatter.string(from: yourDate!)

        let bundle = Bundle(url: Bundle.main.url(forResource: ApplicationResources.kFrameworkResourcesBundle, withExtension: "bundle")!)

        self.initialSetupViewController =
            PTFWInitialSetupViewController.init(
                nibName: ApplicationXIBs.kPTFWInitialSetupView,
                bundle: bundle,
                andWithViewFrame: self.view.frame,
                andWithAmount: Float(self.PayPrice),
                andWithCustomerTitle: "PayTabs",
                andWithCurrencyCode: "SAR",
                andWithTaxAmount: 0.0,
                andWithSDKLanguage: "en",
                andWithShippingAddress: "عُنوان البَريد الإلِكتْروني",
                andWithShippingCity: "jeddah عَنوِن / يَكتُب العُنوان™™™ 29393 .. 48493 $",
                andWithShippingCountry: "BHR",
                andWithShippingState: "123",
                andWithShippingZIPCode: "NBsdjbd.",
                andWithBillingAddress: "عُنوان البَريد الإلِكتْروني",
                andWithBillingCity: "Manama",
                andWithBillingCountry: "BHR",
                andWithBillingState: "Manama",
                andWithBillingZIPCode: "0097",
                andWithOrderID: strOrderID,
                andWithPhoneNumber: "0097335532915",
                andWithCustomerEmail: self.app.strEmail,
                andIsTokenization: true,
                andWithMerchantEmail: "ahmed@yakrm.com",
                andWithMerchantSecretKey: "ex2SHCqdgtJlrF2gp5fGCis3tUGh5EkjcmcTZD7g6RCxwEOWJ3Cml4qOY664KroXOBQNeY3lPFTlkHh4KUq6YQVXW22HtrFh2w4g",
                andWithAssigneeCode: "SDK",
                andWithThemeColor: UIColor.lightGray,
                andIsThemeColorLight: true)//(red: 225.0 / 255.0, green: 225.0 / 255.0, blue: 225.0 / 255.0, alpha: 1.0)

        self.initialSetupViewController.didReceiveBackButtonCallback = {
                //            weakSelf?.handleBackButtonTapEvent()
                self.initialSetupViewController.willMove(toParent: self)
                self.initialSetupViewController.view.removeFromSuperview()
                self.initialSetupViewController.removeFromParent()
        }

        self.initialSetupViewController.didReceiveFinishTransactionCallback = {(responseCode, result, transactionID, tokenizedCustomerEmail, tokenizedCustomerPassword, token, transactionState) in
            //handle response code , result , transactionID , transaction state
            print(responseCode, result)

            self.initialSetupViewController.willMove(toParent: self)
            self.initialSetupViewController.view.removeFromSuperview()
            self.initialSetupViewController.removeFromParent()
            //go to whatever u want to go

            self.strTransactionID = "\(transactionID)"
            if self.app.isConnectedToInternet() {
                self.ReplaceVoucherAPI()
            } else {
                Toast(text: self.app.InternetConnectionMessage.localized).show()
            }
        }

        self.view.addSubview(self.initialSetupViewController.view)
        self.addChild(self.initialSetupViewController)
        self.initialSetupViewController.didMove(toParent: self)
    }

    // MARK: - Replace Voucher API
    @available(iOS 11.0, *)
    func ReplaceVoucherAPI() {
        let headers: HTTPHeaders = ["Authorization": self.app.strToken,
                                     "Content-Type": "application/json"]
        if self.strTransactionID.isEmpty {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let myString = formatter.string(from: Date()) // string purpose I add here
            let yourDate = formatter.date(from: myString)
            formatter.dateFormat = "yyyyMMddHHmmss"
            self.strTransactionID = formatter.string(from: yourDate!)
        }

        var Wallet = self.app.strWallet
        if self.PayPrice > 0 {
            Wallet = "0"
        }

        let parameters: Parameters = ["replace_active_voucher_id": strVoucherID,
                                      "voucher_payment_detail_id": strVoucherPaymentID,
                                      "replace_voucher_id": strReplaceVoucherID,
                                      "transaction_id": strTransactionID,
                                      "transaction_price": self.PayPrice,
                                      "wallet": Wallet,
                                      "card_id": self.strCardID]
        print(JSON(parameters))

        AppWebservice.shared.request("\(self.app.BaseURL)replace_voucher", method: .post, parameters: parameters, headers: headers, loader: true) { (statusCode, response, _) in

            if statusCode == 200 {
                self.json = response
                print(self.json)

                let strStatus: String = self.json["status"].stringValue
                self.strMessage = self.json["message"].stringValue

                Toast(text: self.strMessage).show()
                if strStatus == "1" {
                    self.app.strWallet = self.json["wallet"].stringValue
                    self.app.defaults.setValue(self.app.strWallet, forKey: "wallet")
                    self.app.defaults.synchronize()

                    let desiredViewController = self.navigationController!.viewControllers.filter { $0 is HomeView }.first!
                    self.navigationController!.popToViewController(desiredViewController, animated: true)
                }
            } else {
                Toast(text: self.app.RequestTimeOut.localized).show()
            }
        }
    }

    @IBAction func btnClose(_ sender: UIButton) {
        self.viewPayment.isHidden = true
    }

    // MARK: - Create Pay Page API
    func CreatePayPageAPI() {

        let parameters: Parameters = ["merchant_email": "ahmed@yakrm.com",
                                      "secret_key": "ex2SHCqdgtJlrF2gp5fGCis3tUGh5EkjcmcTZD7g6RCxwEOWJ3Cml4qOY664KroXOBQNeY3lPFTlkHh4KUq6YQVXW22HtrFh2w4g",
                                      "site_url": "http://yakrm.com",
                                      "return_url": "http://google.com",
                                      "title": "Yakrm",
                                      "cc_first_name": self.app.strName,
                                      "cc_last_name": self.app.strName,
                                      "cc_phone_number": self.app.strMobile,
                                      "phone_number": "00966551432252",
                                      "email": self.app.strEmail,
                                      "products_per_title": "Product 1",
                                      "unit_price": self.PayPrice,
                                      "quantity": "1",
                                      "other_charges": 0.0,
                                      "amount": self.PayPrice,
                                      "discount": 0.0,
                                      "currency": "SAR",
                                      "reference_no": "1234567890",
                                      "ip_customer": "123.45.1245",
                                      "ip_merchant": "91.135.55",
                                      "billing_address": "Flat 1,Building 123, Road 2345",
                                      "state": "Manama",
                                      "city": "Manama",
                                      "postal_code": "00973",
                                      "country": "BHR",
                                      "shipping_first_name": self.app.strName,
                                      "shipping_last_name": self.app.strName,
                                      "address_shipping": "Flat 1,Building 123, Road 2345",
                                      "city_shipping": "Manama",
                                      "state_shipping": "Manama",
                                      "postal_code_shipping": "00973",
                                      "country_shipping": "BHR",
                                      "msg_lang": "en",
                                      "cms_with_version": "SDK"]
        print(JSON(parameters))

        AppWebservice.shared.request("https://www.paytabs.com/apiv2/create_pay_page", method: .post, parameters: parameters, headers: nil, loader: true) { (statusCode, response, _) in

            if statusCode == 200 {

                self.json = response
                print(self.json)

                let strStatus: String = self.json["response_code"].stringValue
                self.strMessage = self.json["result"].stringValue

                if strStatus == "4012" {
                    self.strTransactionID = self.json["p_id"].stringValue

                    self.viewPayment.isHidden = false
                    self.webView.delegate = self
                    let url = URL(string: self.json["payment_url"].stringValue)!
                    self.webView.loadRequest(URLRequest(url: url))
                } else {
                    self.loadingNotification.hide(animated: true)
                    Toast(text: self.strMessage).show()
                }
            } else {
                self.loadingNotification.hide(animated: true)
                Toast(text: self.app.RequestTimeOut.localized).show()
            }
        }
    }

    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        print("\(error)")
        self.loadingNotification.hide(animated: true)
    }

    @available(iOS 11.0, *)
    func webViewDidFinishLoad(_ webView: UIWebView) {
        self.loadingNotification.hide(animated: true)
        let strFinal: String = (webView.request?.url?.absoluteString)!

        if strFinal.hasPrefix("http://google.com") {
            self.viewPayment.isHidden = true
            if self.app.isConnectedToInternet() {
                self.ReplaceVoucherAPI()
            } else {
                Toast(text: self.app.InternetConnectionMessage.localized).show()
            }
            //            print("Google")
        } else if strFinal.hasPrefix("http://yakrm.com") {
            self.viewPayment.isHidden = true
            if self.app.isConnectedToInternet() {
                self.ReplaceVoucherAPI()
            } else {
                Toast(text: self.app.InternetConnectionMessage.localized).show()
            }
            //            webView.isHidden = true
            //            print("Yakrm")
        }
    }

    // MARK: - Get All Cards Of Users API
    func GetAllCardsOfUsersAPI() {

        let headers: HTTPHeaders = ["Authorization": self.app.strToken,
                                     "Content-Type": "application/json"]
        print(JSON(headers))

        AppWebservice.shared.request("\(self.app.BaseURL)get_all_cards_ofusers", method: .get, parameters: nil, headers: headers, loader: true) { (statusCode, response, _) in

            if statusCode == 200 {

                self.json = response
                print(self.json)

                let strStatus: String = self.json["status"].stringValue
                self.strMessage = self.json["message"].stringValue

                if strStatus == "1" {
                    let data = self.json["data"]
                    self.arrCardList = self.json["data"].arrayValue
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

    // MARK: - Log In API
    func CreateCheckoutID() {
        let strPrice = String(format: "%.2f", self.PayPrice)

        let parameters: Parameters = ["price": strPrice,
                                      "is_ios": "com.inforaam.Yakrm/payments://result?"]

        //        let parameters: Parameters = ["price":self.PayPrice]
        print(JSON(parameters))

        AppWebservice.shared.request("\(self.app.BaseURL)checkout", method: .post, parameters: parameters, headers: nil, loader: true) { (statusCode, response, error) in

            if statusCode == 200 {

                        self.json = response

                        let strCheckoutID: String = self.json["id"].stringValue
                        print("CheckoutID : \(strCheckoutID)")

                        self.strCheckoutID = strCheckoutID
                        //                        self.checkprovider()

                        self.strCheckoutID = strCheckoutID

                        guard let transaction = self.createTransaction(checkoutID: strCheckoutID) else {
                            return
                        }
                        //                        self.provider.dele
                        self.provider!.submitTransaction(transaction, completionHandler: { (transaction, error) in

                            DispatchQueue.main.async {
                                self.handleTransactionSubmission(transaction: transaction, error: error)
                            }
                        })
            } else {
                Toast(text: self.app.RequestTimeOut.localized).show()
            }
        }
    }

    func createTransaction(checkoutID: String) -> OPPTransaction? {
        do {
            //            let params = try OPPCardPaymentParams.init(checkoutID: checkoutID, paymentBrand: "VISA", holder: "kamal", number: "4054332514836521", expiryMonth: "07", expiryYear: "2020", cvv: "471")

            let params = try OPPCardPaymentParams.init(checkoutID: checkoutID, paymentBrand: "VISA", holder: self.strCardName, number: self.strCardNumber, expiryMonth: self.strCardMonth, expiryYear: self.strCardYear, cvv: self.strCardCVV)

            return OPPTransaction.init(paymentParams: params)
        } catch let error as NSError {
            Utils.showResult(presenter: self, success: false, message: error.localizedDescription)
            return nil
        }
    }

    func checkprovider() {
        let provider = OPPPaymentProvider(mode: OPPProviderMode.test)
        let checkoutSettings = OPPCheckoutSettings()
        checkoutSettings.paymentBrands = ["VISA", "MASTER"]//, "PAYPAL"
        //        checkoutSettings.schemeURL = "com.inforaam.OPPWAMobileDemo.payments://result"//"com.inforaam.OPPWAMobileDemo"
        checkoutSettings.storePaymentDetails = .prompt

        checkoutSettings.theme.navigationBarBackgroundColor = Config.mainColor
        checkoutSettings.theme.confirmationButtonColor = Config.mainColor
        checkoutSettings.theme.accentColor = Config.mainColor
        checkoutSettings.theme.cellHighlightedBackgroundColor = Config.mainColor
        checkoutSettings.theme.sectionBackgroundColor = Config.mainColor.withAlphaComponent(0.05)

        self.checkoutProvider = OPPCheckoutProvider(paymentProvider: provider, checkoutID: self.strCheckoutID, settings: checkoutSettings)

        self.checkoutProvider?.delegate = self

        self.checkoutProvider?.presentCheckout(forSubmittingTransactionCompletionHandler: { (transaction, error) in
            guard let transaction = transaction else {
                // Handle invalid transaction, check error
                return
            }

            self.transaction = transaction

            if transaction.type == .synchronous {
                // If a transaction is synchronous, just request the payment status
                // You can use transaction.resourcePath or just checkout ID to do it
                self.PaymentStatusAPI()
            } else if transaction.type == .asynchronous {
                // If a transaction is asynchronous, SDK opens transaction.redirectUrl in a browser
                // Subscribe to notifications to request the payment status when a shopper comes back to the app
                NotificationCenter.default.addObserver(self, selector: #selector(self.didReceiveAsynchronousPaymentCallback), name: Notification.Name(rawValue: Config.asyncPaymentCompletedNotificationKey), object: nil)
                self.presenterURL(url: self.transaction!.redirectURL!)
            } else {
                // Executed in case of failure of the transaction for any reason
                print("ERROR : \(error?.localizedDescription)")
                print("ERROR Desc: \(JSON(error.debugDescription))")
            }
        }, cancelHandler: {
            // Executed if the shopper closes the payment page prematurely
        })
    }

    func checkoutProvider(_ checkoutProvider: OPPCheckoutProvider, continueSubmitting transaction: OPPTransaction, completion: @escaping (String?, Bool) -> Void) {
        completion(transaction.paymentParams.checkoutID, false)
    }

    func getCheckout(strID: String) {
        self.checkoutProvider = self.configureCheckoutProvider(checkoutID: strID)
        self.checkoutProvider?.delegate = self
        self.checkoutProvider?.presentCheckout(forSubmittingTransactionCompletionHandler: { (transaction, error) in
            DispatchQueue.main.async {
                self.handleTransactionSubmission(transaction: transaction, error: error)
            }
        }, cancelHandler: nil)
    }

    func configureCheckoutProvider(checkoutID: String) -> OPPCheckoutProvider? {
        let provider = OPPPaymentProvider.init(mode: .test)
        let checkoutSettings = Utils.configureCheckoutSettings()
        checkoutSettings.storePaymentDetails = .prompt
        return OPPCheckoutProvider.init(paymentProvider: provider, checkoutID: checkoutID, settings: checkoutSettings)
    }

    func requestPaymentStatus() {
        guard let resourcePath = self.transaction?.resourcePath else {
            Utils.showResult(presenter: self, success: false, message: "Resource path is invalid")
            return
        }
        self.transaction = nil

        Request.requestPaymentStatus(resourcePath: resourcePath) { (success, transactionID)  in
            DispatchQueue.main.async {
                print("Transaction ID : \(transactionID)")
                let message = success ? "Your payment was successful" : "Your payment was not successful"
                //                Utils.showResult(presenter: self, success: success, message: message)
                self.strTransactionID = transactionID
            }
        }
    }

    // MARK: - Async payment callback
    @objc func didReceiveAsynchronousPaymentCallback() {
        NotificationCenter.default.removeObserver(self, name: Notification.Name(rawValue: "AsyncPaymentCompletedNotificationKey"), object: nil)
        self.safariVC?.dismiss(animated: true, completion: {
            DispatchQueue.main.async {
                //                self.requestPaymentStatus()
                self.PaymentStatusAPI()
            }
        })

        //        self.checkoutProvider?.dismissCheckout(animated: true) {
        //            DispatchQueue.main.async {
        //                //                self.requestPaymentStatus()
        //                self.PaymentStatusAPI()
        //            }
        //        }
    }

    func handleTransactionSubmission(transaction: OPPTransaction?, error: Error?) {
        guard let transaction = transaction else {
            Utils.showResult(presenter: self, success: false, message: error?.localizedDescription)
            return
        }

        self.transaction = transaction
        if transaction.type == .synchronous {
            // If a transaction is synchronous, just request the payment status
            //            self.requestPaymentStatus()
            self.PaymentStatusAPI()
        } else if transaction.type == .asynchronous {
            // If a transaction is asynchronous, SDK opens transaction.redirectUrl in a browser
            // Subscribe to notifications to request the payment status when a shopper comes back to the app
            NotificationCenter.default.addObserver(self, selector: #selector(self.didReceiveAsynchronousPaymentCallback), name: Notification.Name(rawValue: Config.asyncPaymentCompletedNotificationKey), object: nil)
            self.presenterURL(url: self.transaction!.redirectURL!)
        } else {
            print(JSON(error?.localizedDescription))
            print(JSON(error.debugDescription))
            Utils.showResult(presenter: self, success: false, message: "Invalid transaction")
            //            self.paymentstatusAPI()
        }
    }

    func presenterURL(url: URL) {
        self.safariVC = SFSafariViewController(url: url)
        self.safariVC?.delegate = self
        self.present(safariVC!, animated: true, completion: nil)
    }

    // MARK: - PaymentStatusAPI
    @available(iOS 11.0, *)
    func PaymentStatusAPI() {

        let parameters: Parameters = ["checkout_id": self.strCheckoutID]
        print(JSON(parameters))

        AppWebservice.shared.request("\(self.app.BaseURL)paymentstatus", method: .post, parameters: parameters, headers: nil, loader: true) { (statusCode, response, _) in

            if statusCode == 200 {

                        self.json = response

                        self.strMessage = self.json["result"]["description"].stringValue
                        let strCode: String = self.json["result"]["code"].stringValue
                        if strCode == "000.000.000" {
                            let strID: String = self.json["id"].stringValue
                            self.strTransactionID = strID
                            print("TRAN ID : \(strID)")

                            if self.app.isConnectedToInternet() {
                                self.ReplaceVoucherAPI()
                            } else {
                                Toast(text: self.app.InternetConnectionMessage.localized).show()
                            }
                        } else {
                            Toast(text: self.strMessage).show()
                        }

            } else {
                Toast(text: self.app.RequestTimeOut.localized).show()
            }
        }
    }

    @IBAction func btnCancel(_ sender: UIButton) {
        self.viewPopup.isHidden = true
    }

    @IBAction func btnSelectAction(_ sender: UIButton) {
        self.viewPopup.isHidden = true

        //        if sender.tag == 1
        //        {
        if self.app.isConnectedToInternet() {
            self.CreateCheckoutID()
        } else {
            Toast(text: self.app.InternetConnectionMessage.localized).show()
        }
        //        }
        //        else
        //        {
        //            self.initiateSDK()
        //        }
    }

    // MARK: - Tablview
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.arrCardList.count//self.arrList.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: PaymentCell!
        cell = tblView.dequeueReusableCell(withIdentifier: "PaymentCell") as! PaymentCell?
        if cell == nil {
            cell = Bundle.main.loadNibNamed("PaymentCell", owner: self, options: nil)?[0] as! PaymentCell?
        }

        var arrValue  = JSON(self.arrCardList)

        if self.app.isEnglish {
            cell.lblName.textAlignment = .left
            cell.lblDetails.textAlignment = .left
        } else {
            cell.lblName.textAlignment = .right
            cell.lblDetails.textAlignment = .right
        }

        let strName: String = arrValue[indexPath.section]["card_number"].stringValue

        let strLast: String = String(strName.suffix(4))
        let strDetails: String = arrValue[indexPath.section]["name"].stringValue

        cell.lblDetails.text = "**** **** **** \(strLast)"
        cell.lblName.text = "By Using Credit Card"//strDetails
        cell.imgProfile.image = UIImage(named: "payment_visa_icon.png")!

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
        var arrValue  = JSON(self.arrCardList)

        let alertController = UIAlertController(title: "Are you sure ?".localized, message: nil, preferredStyle: .alert)

        let cancelAction = UIAlertAction(title: "NO".localized, style: .default) { (_: UIAlertAction!) in
            print("you have pressed the Cancel button")
        }
        alertController.addAction(cancelAction)

        let OKAction = UIAlertAction(title: "YES".localized, style: .default) { (_: UIAlertAction!) in
            print("you have pressed OK button")
            //            if indexPath.section == 0
            //            {
            self.strCardID = arrValue[indexPath.section]["id"].stringValue
            self.strCardName = arrValue[indexPath.section]["holder_name"].stringValue
            self.strCardNumber = arrValue[indexPath.section]["card_number"].stringValue
            self.strCardCVV = arrValue[indexPath.section]["security_number"].stringValue

            let expiry_date: String = arrValue[indexPath.section]["expiry_date"].stringValue
            let arrEx = expiry_date.components(separatedBy: "/")
            if arrEx.count > 1 {
                self.strCardMonth = arrEx[0]
                self.strCardYear = "20\(arrEx[1])"
            }

            if self.app.isConnectedToInternet() {
                self.viewPopup.isHidden = true
                self.CreateCheckoutID()
            } else {
                Toast(text: self.app.InternetConnectionMessage.localized).show()
            }
        }
        alertController.addAction(OKAction)

        self.present(alertController, animated: true, completion: nil)
    }

}
