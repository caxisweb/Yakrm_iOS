//
//  DeliveryPaymentVC.swift
//  Yakrm
//
//  Created by Gaurav Parmar on 17/05/20.
//  Copyright © 2020 Krutik V. Poojara. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import MBProgressHUD
import Toaster
import SafariServices

class DeliveryPaymentVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UIWebViewDelegate, OPPCheckoutProviderDelegate, SFSafariViewControllerDelegate {
    // MARK: - Outlet
    @IBOutlet var viewNavigation: UIView!
    
    @IBOutlet var lblTheAmount: UILabel!

    @IBOutlet var viewPurchase: UIView!
    @IBOutlet var viewSuccess: UIView!
    @IBOutlet var viewFail: UIView!

    @IBOutlet var viewBalance: UIView!
    @IBOutlet var viewBalanceTop: UIView!
    @IBOutlet var viewBalanceBottom: UIView!
    @IBOutlet var lblBalancePrice: UILabel!
    @IBOutlet var lblCHANGEACC: UILabel!

    @IBOutlet var tblView: UITableView!

    @IBOutlet var viewPayment: UIView!
    @IBOutlet var viewNavPayment: UIView!
    @IBOutlet var webView: UIWebView!

    var safariVC: SFSafariViewController?

    var loadingNotification: MBProgressHUD!
    var json: JSON!
    var strMessage: String!

    var app = AppDelegate()

    var strTotal = String()
    var strTransactionID = String()
    var orderId = String()

    var isPayment = Bool()

    var arrList = [["Title": "By Using Mada Card".localized, "Detail": "**** **** **** 5678", "image": "payment_type_csmada_icon.png"],
                   ["Title": "By Using Credit Card".localized, "Detail": "**** **** **** 1234", "image": "payment_visa_icon.png"]]
//    var arrList = [["Title":"By Using Pay Pal".localized,"Detail":"email@domain.dlt","image":"paypal_icon.png"],              ["Title":"By Using Mada Card".localized,"Detail":"**** **** **** 5678","image":"payment_type_csmada_icon.png"],
//                   ["Title":"By Using Credit Card".localized,"Detail":"**** **** **** 1234","image":"payment_visa_icon.png"]]

    var initialSetupViewController: PTFWInitialSetupViewController!

    var Total = Float()
    var Wallet = Float()

    var strCardID = String()
    var strCardName = String()
    var strCardNumber = String()
    var strCardMonth = String()
    var strCardYear = String()
    var strCardCVV = String()
    var bankflag = false
    var bankPrice = Double()

    var arrCardList: [Any] = []

    var checkoutProvider: OPPCheckoutProvider?
    var transaction: OPPTransaction?
    var strCheckoutID = String()

    var provider: OPPPaymentProvider?
//    var transaction: OPPTransaction?

    // MARK: -
    override func viewDidLoad() {
        super.viewDidLoad()
        app = UIApplication.shared.delegate as! AppDelegate

        self.viewNavigation.backgroundColor = UIColor.init(rgb: 0xEE4158)
        self.viewNavPayment.backgroundColor = UIColor.init(rgb: 0xEE4158)

        if DeviceType.IS_IPHONE_X || DeviceType.IS_IPHONE_XR {
            self.viewNavigation.frame = CGRect(x: self.viewNavigation.frame.origin.x, y: self.viewNavigation.frame.origin.y, width: self.viewNavigation.frame.size.width, height: 88)
            
            
            self.viewNavPayment.frame = CGRect(x: self.viewNavPayment.frame.origin.x, y: self.viewNavPayment.frame.origin.y, width: self.viewNavPayment.frame.size.width, height: 88)
            self.webView.frame = CGRect(x: self.webView.frame.origin.x, y: self.viewNavPayment.frame.origin.y + self.viewNavPayment.frame.size.height, width: self.webView.frame.size.width, height: ScreenSize.SCREEN_HEIGHT - self.viewNavigation.frame.size.height)
        }

//        if self.app.isEnglish == false
//        {
//            self.lblTotalAmountIS.text = "المبلغ الإجمالي هو"
//            self.lblAmountWillBe.text = "سيتم خصم المبلغ من رصيدك الحالي"
//            self.lblTheAmount.text = "المبلغ الإجمالي هو"
//        }
        
        self.lblTheAmount.text = "Total Amount".localized

        if DeviceType.IS_IPHONE_5 {
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

        if !self.app.strWallet.isEmpty {
            self.Wallet = Float(self.app.strWallet)!
        }

        let strSR: String = "SR".localized
//        self.lblTotal.text = self.strTotal
//        self.lblBalancePrice.text = self.strTotal

        let strAttDiscount = NSMutableAttributedString(string: "\(self.strTotal) \(strSR)")
        strAttDiscount.setColorForText(strSR, with: UIColor.black)
        self.lblBalancePrice.attributedText = strAttDiscount

        
        self.viewSuccess.dropShadow(color: .lightGray, opacity: 1, offSet: CGSize(width: 0, height: 1), radius: 1, scale: true)
        self.viewFail.dropShadow(color: .lightGray, opacity: 1, offSet: CGSize(width: 0, height: 1), radius: 1, scale: true)

        self.viewBalanceTop.dropShadow(color: .lightGray, opacity: 1, offSet: CGSize(width: 0, height: 1), radius: 1, scale: true)
        self.viewBalanceBottom.dropShadow(color: .lightGray, opacity: 1, offSet: CGSize(width: 0, height: 1), radius: 1, scale: true)

        self.viewPurchase.isHidden = true
        self.viewBalance.isHidden = false

        self.tblView.delegate = self
        self.tblView.dataSource = self
        self.viewPayment.isHidden = true

        provider = OPPPaymentProvider(mode: .live)
    }

    override func viewWillAppear(_ animated: Bool) {
        app = UIApplication.shared.delegate as! AppDelegate
        if self.arrCardList.count == 0 {
            if self.app.isConnectedToInternet() {
                self.GetAllCardsOfUsersAPI()
            } else {
                Toast(text: self.app.InternetConnectionMessage.localized).show()
            }
        }
    }

    @IBAction func btnBack(_ sender: UIButton) {
        if self.isPayment {
            let desiredViewController = self.navigationController!.viewControllers.filter { $0 is HomeView }.first!
            self.navigationController!.popToViewController(desiredViewController, animated: true)
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }

    @IBAction func btnAllAction(_ sender: UIButton) {
        if sender.tag == 1 {
            let desiredViewController = self.navigationController!.viewControllers.filter { $0 is HomeView }.first!
            self.navigationController!.popToViewController(desiredViewController, animated: true)
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }

    // MARK: - Voucher Purchase API
    func VoucherPurchaseAPI() {

        if self.strTransactionID.isEmpty {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let myString = formatter.string(from: Date()) // string purpose I add here
            let yourDate = formatter.date(from: myString)
            formatter.dateFormat = "yyyyMMddHHmmss"
            self.strTransactionID = formatter.string(from: yourDate!)
        }

        let headers: HTTPHeaders = ["Authorization": self.app.strToken,
                                     "Content-Type": "application/json"]
        print(JSON(headers))

        var onedouble = Double()
        if bankflag {

            onedouble = bankPrice
            bankflag = false
        } else {

            onedouble = Double(self.Total)
        }

        print(onedouble)
        let voucherStr = String(format: "%.2f", onedouble)
        let parameters: Parameters = ["transaction_id": self.strTransactionID,
                                      "order_id" : self.orderId,
                                      "card_id": self.strCardID]
        print(JSON(parameters))

        AppWebservice.shared.request("\(self.app.newBaseURL)users/orders/payment", method: .post, parameters: parameters, headers: headers, loader: true) { (statusCode, response, error) in

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
                            self.navigationController?.popViewController(animated: true)
                        } else {
                            self.viewSuccess.isHidden = true
                            ProjectUtility.animatePopupView(viewPopup: self.viewPurchase, viewDetails: self.viewFail)
                        }
            } else {
                Toast(text: self.app.RequestTimeOut.localized).show()
            }
        }
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
                    self.CreateCheckoutID()
                } else {
                    Toast(text: self.app.InternetConnectionMessage.localized).show()
                }
//            }
//            else
//            {
//                self.initiateSDK()
//            }
        }
        alertController.addAction(OKAction)

        self.present(alertController, animated: true, completion: nil)
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
                andWithAmount: self.Total,
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
                self.VoucherPurchaseAPI()
            } else {
                Toast(text: self.app.InternetConnectionMessage.localized).show()
            }
        }

        self.view.addSubview(self.initialSetupViewController.view)
        self.addChild(self.initialSetupViewController)
        self.initialSetupViewController.didMove(toParent: self)
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
                                      "unit_price": self.Total,
                                      "quantity": "1",
                                      "other_charges": 0.0,
                                      "amount": self.Total,
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
            
        AppWebservice.shared.request("https://www.paytabs.com/apiv2/create_pay_page", method: .post, parameters: parameters, headers: nil, loader: true) { (statusCode, response, error) in

            if statusCode == 200 {
                        self.json = response!
                        print(self.json)

                        let strStatus: String = self.json["response_code"].stringValue
                        self.strMessage = self.json["result"].stringValue

                        if strStatus == "4012" {
                            self.strTransactionID = self.json["p_id"].stringValue

                            self.viewPayment.isHidden = false
                            self.webView.delegate = self
                            let url = URL(string: self.json["payment_url"].stringValue)!
                            self.webView.loadRequest(URLRequest(url: url))
                            print("Payment ID : \(self.json["p_id"].stringValue)")
                        } else {
                            Toast(text: self.strMessage).show()
                        }
                    
                } else {
                    Toast(text: self.app.RequestTimeOut.localized).show()
                }
        }
    }

    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        print("\(error)")
    }

    func webViewDidFinishLoad(_ webView: UIWebView) {
        let strFinal: String = (webView.request?.url?.absoluteString)!

        if strFinal.hasPrefix("http://google.com") {
            self.viewPayment.isHidden = true
            if self.app.isConnectedToInternet() {
                self.VoucherPurchaseAPI()
            } else {
                Toast(text: self.app.InternetConnectionMessage.localized).show()
            }
        } else if strFinal.hasPrefix("http://yakrm.com") {
            self.viewPayment.isHidden = true
            if self.app.isConnectedToInternet() {
                self.VoucherPurchaseAPI()
            } else {
                Toast(text: self.app.InternetConnectionMessage.localized).show()
            }
        }
    }

    // MARK: - Get All Cards Of Users API
    func GetAllCardsOfUsersAPI() {
        let headers: HTTPHeaders = ["Authorization": self.app.strToken,
                                     "Content-Type": "application/json"]
        print(JSON(headers))

        
            
        AppWebservice.shared.request("\(self.app.BaseURL)get_all_cards_ofusers", method: .get, parameters: nil, headers: headers, loader: true) { (statusCode, response, error) in

            if statusCode == 200 {
                        self.json = response!
                        print(self.json)

                        let strStatus: String = self.json["status"].stringValue
                        self.strMessage = self.json["message"].stringValue

                        if strStatus == "1" {
                            let data = self.json["data"]

//                            var dic : Dictionary<String,String> = [:]
//                            dic.updateValue("Hyper Pay", forKey: "name")
                            self.arrCardList = self.json["data"].arrayValue
//                            if data.count > 0
//                            {
//                                self.strCardID = data[0]["id"].stringValue
//                            }
//                            self.arrCardList.insert(dic, at: 0)

                            self.tblView.reloadData()
                        } else {
                            let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
                            let VC = storyboard.instantiateViewController(withIdentifier: "PaymentMethodView") as! PaymentMethodView
                            self.navigationController?.pushViewController(VC, animated: true)

                            Toast(text: self.strMessage).show()
                        }
            } else {
                Toast(text: self.app.RequestTimeOut.localized).show()
            }
        }
    }

    // MARK: - Log In API
    func CreateCheckoutID() {

        var Price = Double()

        if !self.strTotal.isEmpty {
            Price = Double(self.strTotal)!
        }
//        let strPrice = String(format:"%.2f", Price)
//
//        let floatPrice = Float(strPrice)

        bankPrice = Double(self.strTotal)!

        if String(app.strWallet) > String(bankPrice) {

            bankPrice = Double(app.strWallet)! - Double(bankPrice)

        } else {

            bankPrice = Double(bankPrice) - Double(app.strWallet)!
        }
        print(bankPrice)

        let priceStr = String(format: "%.2f", bankPrice)
        print(priceStr)

//        let y = Double(round(100*bankPrice)/100)
//        print(y)

        let parameters: Parameters = ["price": priceStr,
                                      "is_ios": "com.inforaam.Yakrm/payments://result?"]
        print(JSON(parameters))
            
        AppWebservice.shared.request("\(self.app.BaseURL)checkout", method: .post, parameters: parameters, headers: nil, loader: true) { (statusCode, response, error) in

            if statusCode == 200 {
                        self.json = response!
                        
                        let strCheckoutID: String = self.json["id"].stringValue
                        print("CheckoutID : \(strCheckoutID)")
                        self.bankflag = true
//                        self.VoucherPurchaseAPI()
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
//                        self.checkprovider()
            } else {
                Toast(text: self.app.RequestTimeOut.localized).show()
            }
        }
    }

    func checkprovider() {
        let provider = OPPPaymentProvider(mode: OPPProviderMode.live)//test
        let checkoutSettings = OPPCheckoutSettings()
        do {
        let params = try OPPCardPaymentParams(checkoutID: self.strCheckoutID, paymentBrand: "VISA", holder: "holderName", number: "cardNumber", expiryMonth: "month", expiryYear: "year", cvv: "CVV")

        } catch let error as NSError {
            print("Error : \(error.description)")
        }
        checkoutSettings.paymentBrands = ["VISA", "MASTER"]//, "PAYPAL"
        //        checkoutSettings.schemeURL = "com.inforaam.OPPWAMobileDemo.payments://result"//"com.inforaam.OPPWAMobileDemo"
        checkoutSettings.storePaymentDetails = .prompt

//        checkoutSettings.theme.navigationBarBackgroundColor = Config.mainColor
//        checkoutSettings.theme.confirmationButtonColor = Config.mainColor
//        checkoutSettings.theme.accentColor = Config.mainColor
//        checkoutSettings.theme.cellHighlightedBackgroundColor = Config.mainColor
//        checkoutSettings.theme.sectionBackgroundColor = Config.mainColor.withAlphaComponent(0.05)

//        self.checkoutProvider = OPPCheckoutProvider(paymentProvider: provider, checkoutID: self.strCheckoutID, settings: nil)
//
//        self.checkoutProvider?.delegate = self

        //        self.checkoutProvider?.presentCheckout(forSubmittingTransactionCompletionHandler: { (transaction, error) in
//            guard let transaction = transaction else {
//                // Handle invalid transaction, check error
//                return
//            }
//
//            self.transaction = transaction
//
//            if transaction.type == .synchronous
//            {
//                self.PaymentStatusAPI()
//            }
//            else if transaction.type == .asynchronous
//            {
//                NotificationCenter.default.addObserver(self, selector: #selector(self.didReceiveAsynchronousPaymentCallback), name: Notification.Name(rawValue: "AsyncPaymentCompletedNotificationKey"), object: nil)
//            }
//            else
//            {
//                // Executed in case of failure of the transaction for any reason
//                print("ERROR : \(error?.localizedDescription)")
//                print("ERROR Desc: \(JSON(error.debugDescription))")
//            }
//        }, cancelHandler: {
//            // Executed if the shopper closes the payment page prematurely
//        })
    }
//    func setParamDic(provider: OPPPaymentProvider,params: OPPPaymentParams)
//    {
//        let transaction = OPPTransaction(paymentParams: params)
//        provider.submitTransaction(transaction) { (transaction, error) in
//            guard let transaction = transaction else {
//                // Handle invalid transaction, check error
//                return
//            }
//
//            if transaction.type == .asynchronous {
//                // Open transaction.redirectURL in Safari browser to complete the transaction
//            } else if transaction.type == .synchronous {
//                // Send request to your server to obtain transaction status
//            } else {
//                // Handle the error
//            }
//        }
//    }

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
    func PaymentStatusAPI() {

        let parameters: Parameters = ["checkout_id": self.strCheckoutID]
        print(JSON(parameters))

        AppWebservice.shared.request("\(self.app.BaseURL)paymentstatus", method: .post, parameters: parameters, headers: nil, loader: true) { (statusCode, response, error) in

            if statusCode == 200 {
                        self.json = response!
                        
                        self.strMessage = self.json["result"]["description"].stringValue
                        let strCode: String = self.json["result"]["code"].stringValue
                        if strCode == "000.000.000" {
                            let strID: String = self.json["id"].stringValue
                            self.strTransactionID = strID
                            print("TRAN ID : \(strID)")

                            if self.app.isConnectedToInternet() {
                                self.VoucherPurchaseAPI()
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

}
