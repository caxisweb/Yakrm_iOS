
//
//  DetailsView.swift
//  Yakrm
//
//  Created by Krutik V. Poojara on 07/12/18.
//  Copyright © 2018 Krutik V. Poojara. All rights reserved.
//

import UIKit
import MessageUI
import SafariServices
import Social
import Alamofire
import SwiftyJSON
import MBProgressHUD
import Toaster
import UserNotifications

@available(iOS 11.0, *)
class DetailsView: UIViewController,UITableViewDelegate,UITableViewDataSource,MFMailComposeViewControllerDelegate,SFSafariViewControllerDelegate,MFMessageComposeViewControllerDelegate,UNUserNotificationCenterDelegate
{
    //MARK:- Outlet
    
    @IBOutlet var viewNavigation: UIView!
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var viewTop: UIView!
    @IBOutlet var imgProfile: UIImageView!
    @IBOutlet var lblName: UILabel!
    @IBOutlet var lblDate: UILabel!
    @IBOutlet var lblSub: UILabel!
    @IBOutlet var lblDetails: UILabel!
    @IBOutlet var btnShare: UIButton!
    @IBOutlet var btnFavourite: UIButton!
    @IBOutlet var imgLogo: UIImageView!
    
    @IBOutlet var lblValue: UILabel!
    @IBOutlet var lblDiscount: UILabel!
    @IBOutlet var lblPay: UILabel!
    @IBOutlet var viewLine: UIView!

    @IBOutlet var tblView: UITableView!
    @IBOutlet var btnComplete: UIButton!
    
    
    @IBOutlet var viewAdded: UIView!
    
    @IBOutlet var viewPopup: UIView!
    @IBOutlet var viewShare: UIView!

    @IBOutlet var viewPopupDetails: UIView!
    @IBOutlet var viewDetails: UIView!
    @IBOutlet var imgVoucher: UIImageView!
    @IBOutlet var lblVoucherName: UILabel!
    @IBOutlet var lblVoucherDate: UILabel!
    @IBOutlet var lblVoucherCode: UILabel!
    @IBOutlet var lblVoucherType: UILabel!
    @IBOutlet var lblDesc: UILabel!
    
    var loadingNotification : MBProgressHUD!
    var json : JSON!
    var strMessage : String!
    var arabMessage : String!
    
    var app = AppDelegate()
    
    var strShareURL = "https://itunes.apple.com/us/app/"

    var strBranchID = String()
    
    var arrVouchers : [Any] = []
    var arrAdded : [Bool] = []
    
    var isFavourite = Int()
    
    var isAdded = Bool()
    
    //MARK:-
    override func viewDidLoad()
    {
        super.viewDidLoad()
        app = UIApplication.shared.delegate as! AppDelegate
        
        self.viewTop.isHidden = true
        self.btnComplete.isHidden = true

        self.viewNavigation.backgroundColor = UIColor.init(rgb: 0xEE4158)

        if DeviceType.IS_IPHONE_X || DeviceType.IS_IPHONE_XR
        {
            self.viewNavigation.frame = CGRect(x:self.viewNavigation.frame.origin.x, y: self.viewNavigation.frame.origin.y, width:self.viewNavigation.frame.size.width, height: 88)
            self.viewTop.frame = CGRect(x:self.viewTop.frame.origin.x, y: self.viewNavigation.frame.origin.y + self.viewNavigation.frame.size.height, width:self.viewTop.frame.size.width, height: self.viewTop.frame.size.height)
            self.tblView.frame = CGRect(x:self.tblView.frame.origin.x, y: self.viewTop.frame.origin.y + self.viewTop.frame.size.height, width:self.tblView.frame.size.width, height: ScreenSize.SCREEN_HEIGHT - self.viewTop.frame.origin.y - self.viewTop.frame.size.height - 65)//122
        }
        
        if DeviceType.IS_IPHONE_5
        {
            self.lblName.font = self.lblName.font.withSize(self.lblName.font.pointSize-1)
            self.lblSub.font = self.lblSub.font.withSize(self.lblSub.font.pointSize-1)
            self.lblDetails.font = self.lblDetails.font.withSize(self.lblDetails.font.pointSize-1)

            self.btnComplete.titleLabel!.font = self.btnComplete.titleLabel!.font.withSize(self.btnComplete.titleLabel!.font.pointSize-1)
        }
        
        if self.app.isEnglish
        {
            self.lblName.textAlignment = .left
            self.lblSub.textAlignment = .left
            self.lblDetails.textAlignment = .left
            self.lblTitle.textAlignment = .left

            self.lblVoucherName.textAlignment = .left
            self.lblVoucherDate.textAlignment = .left
            self.lblVoucherCode.textAlignment = .left
            self.lblVoucherType.textAlignment = .left
        }
        else
        {
            self.lblName.textAlignment = .right
            self.lblSub.textAlignment = .right
            self.lblDetails.textAlignment = .right
            self.lblTitle.textAlignment = .right
            
            self.lblVoucherName.textAlignment = .right
            self.lblVoucherDate.textAlignment = .right
            self.lblVoucherCode.textAlignment = .right
            self.lblVoucherType.textAlignment = .right
        }
        
        self.tblView.delegate = self
        self.tblView.dataSource = self
    
        self.btnComplete.layer.cornerRadius = 5
        self.viewAdded.layer.cornerRadius = 5
        self.viewAdded.clipsToBounds = true
        
        self.viewPopup.isHidden = true
        self.viewPopupDetails.isHidden = true
        self.viewPopup.frame.origin.y = 0
        self.viewPopupDetails.frame.origin.y = 0
        self.viewShare.center = self.view.center
        self.viewDetails.center = self.view.center

        self.viewAdded.isHidden = true
        
        if self.app.isConnectedToInternet()
        {
            self.GetAllDetailsAPI()
        }
        else
        {
            Toast(text: self.app.InternetConnectionMessage.localized).show()
        }

    }
    
    @IBAction func btnBack(_ sender: UIButton)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK:- Tablview
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.arrVouchers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
            var cell : DetailsCell!
            cell = tblView.dequeueReusableCell(withIdentifier: "DetailsCell") as! DetailsCell?
            if cell == nil
            {
                cell = Bundle.main.loadNibNamed("DetailsCell", owner: self, options: nil)?[1] as! DetailsCell?
            }
            let arrValue = JSON(self.arrVouchers)
            let Price = arrValue[indexPath.row]["voucher_price"].floatValue
            let Discount = arrValue[indexPath.row]["discount"].intValue
    /*
            let DiscountPrice = Price * Discount / 100
            let PayValue = Price + DiscountPrice
            
            cell.lblValue.text = "\(PayValue)" + "SR".localized
            cell.lblDiscount.text = "\(Discount)%"
            cell.lblPay.text = "\(Price)" + "SR".localized
    */
            
        
            var img = UIImage()
            if self.arrAdded[indexPath.row]
            {
                img = UIImage(named: "ic_fillcart.png")!
                
            }
            else
            {
               
                img = UIImage(named: "ic_addcart_plush.png")!
            }
       

        // Message constrait for congiguration
       
           
    //        cell.btnCart.setImage(img, for: .normal)
            cell.btnCart.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
            cell.btnCart.tag = indexPath.row
            cell.imgProfile.image = img
    //        cell.imgProfile.isHidden = true
            /*if DeviceType.IS_IPHONE_5
            {
                cell.lblValue.font = cell.lblValue.font.withSize(13)
                cell.lblPay.font = cell.lblPay.font.withSize(13)
                cell.lblDiscount.font = cell.lblDiscount.font.withSize(13)
            }*/
            //"I Pay" = "أنا أدفع";
            //"And get" = "و احصل علي";
            let discountText = "Discount".localized
            cell.lblCardName.text = "Pay".localized + " \(Price) " + "SR".localized() + " " + "And get".localized + " (\(discountText) \(Discount)%)"
            var strVoucherDesc : String = arrValue[indexPath.row]["voucher_description"].stringValue
            let strArabicDescription : String = arrValue[indexPath.row]["arab_voucher_description"].stringValue

            if !self.app.isEnglish && !strArabicDescription.isEmpty {
                strVoucherDesc = strArabicDescription
            }
            cell.lblDisc.text = strVoucherDesc
        
            

            if self.app.isEnglish
            {
                let width = (tblView.frame.size.width/2) - 8
                cell.lblCardName.textAlignment = .left
                cell.lblDisc.textAlignment = .left
                cell.imgProfile.frame.origin.x = width - cell.imgProfile.frame.size.width + 120
                cell.btnCart.frame.origin.x = width - cell.btnCart.frame.size.width + 120
            }
            else
            {
                
                cell.lblCardName.textAlignment = .right
                cell.lblDisc.textAlignment = .right
                cell.imgProfile.frame.origin.x = -30
                cell.btnCart.frame.origin.x = -30
            }
            cell.selectionStyle = .none
            tblView.rowHeight = cell.frame.size.height
            
            return cell
        }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        var arrValue = JSON(self.arrVouchers)
        let strVoucherName : String = arrValue[indexPath.row]["gift_category_name"].stringValue
        let strVoucherDate : String = arrValue[indexPath.row]["expired_at"].stringValue
        let strVoucherCode : String = arrValue[indexPath.row]["voucher_code"].stringValue
        let strVoucherType : String = arrValue[indexPath.row]["voucher_type"].stringValue
        var strVoucherDesc : String = arrValue[indexPath.row]["voucher_description"].stringValue
        let strArabicDescription : String = arrValue[indexPath.row]["arab_voucher_description"].stringValue

        var strImage : String = arrValue[indexPath.row]["voucher_image"].stringValue
        strImage = strImage.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        self.imgVoucher.sd_setImage(with: URL(string: "\(self.app.ImageURL)voucher_images/\(strImage)"), placeholderImage: nil)

        if !self.app.isEnglish
        {
            if !strArabicDescription.isEmpty
            {
                strVoucherDesc = strArabicDescription
            }
        }

        
        self.lblVoucherName.text = strVoucherName
        self.lblVoucherDate.text = "Ended In".localized + " \(self.getDateStringFormate(strDate: strVoucherDate))"
        self.lblVoucherCode.text = strVoucherCode
        self.lblVoucherType.text = strVoucherType
        self.lblDesc.text = strVoucherDesc

        var Height = self.lblVoucherType.frame.origin.y + self.lblVoucherType.frame.size.height + 10
        if !strVoucherDesc.isEmpty
        {
            let rectTitle = self.lblDesc.text!.boundingRect(with: CGSize(width: self.lblDesc.frame.size.width, height: CGFloat(50000)), options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: self.lblDesc.font as Any], context: nil)
            if rectTitle.height > 20
            {
                var FinalHeight = rectTitle.height
                if rectTitle.height > ScreenSize.SCREEN_HEIGHT - 176
                {
                    FinalHeight = ScreenSize.SCREEN_HEIGHT - 176
                }
                self.lblDesc.frame = CGRect(x: self.lblDesc.frame.origin.x, y: self.lblDesc.frame.origin.y, width: self.lblDesc.frame.size.width, height: FinalHeight)
            }
            Height = self.lblDesc.frame.origin.y + self.lblDesc.frame.size.height + 10
        }
        
        self.viewDetails.frame = CGRect(x: self.viewDetails.frame.origin.x, y: self.viewDetails.frame.origin.y, width: self.viewDetails.frame.size.width, height: Height)
        self.viewDetails.center = self.view.center
        
        ProjectUtility.animatePopupView(viewPopup: self.viewPopupDetails, viewDetails: self.viewDetails)
    }
    
    func getDateStringFormate(strDate : String) -> String
    {
        var strFullDate = String()
        if strDate.isEmpty
        {
            return strFullDate
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd-HH:mm:ss"
        let date = dateFormatter.date(from: strDate)
        if date != nil
        {
            dateFormatter.dateFormat = "dd-MM-yyyy"
            strFullDate = dateFormatter.string(from: date!)
        }
        
        return strFullDate
    }
    
    @objc func buttonAction(sender: UIButton!)
    {
        if self.app.strUserID.isEmpty
        {
            let VC = self.storyboard?.instantiateViewController(withIdentifier: "ViewController") as! ViewController
            self.navigationController?.pushViewController(VC, animated: true)
        }
        else
        {
            let check = self.arrAdded[sender.tag]
            if check
            {
                Toast(text: "Voucher Already Added!").show()
            }
            else
            {
                var arrValue = JSON(self.arrVouchers)
                let strVoucherID : String = arrValue[sender.tag]["voucher_id"].stringValue
                let strVoucherType : String = arrValue[sender.tag]["voucher_type"].stringValue
                
                if strVoucherType.lowercased() == "paper gift"
                {
                    Toast(text: "Can't buy Pepar Gift").show()
                }
                else
                {
                    if self.app.isConnectedToInternet()
                    {
                        self.AddToCartAPI(index: sender.tag, strVoucherID: strVoucherID)
                    }
                    else
                    {
                        Toast(text: self.app.InternetConnectionMessage.localized).show()
                    }
                }
                
            }
        }
    }
    
    @IBAction func btnAllAction(_ sender: UIButton)
    {
        if sender.tag == 1
        {
            
        }
        else
        {
            if self.isAdded
            {
                let VC = self.storyboard?.instantiateViewController(withIdentifier: "CartView") as! CartView
                self.navigationController?.pushViewController(VC, animated: true)
            }
            else
            {
                Toast(text: "Please add item to the Cart").show()
            }
        }
    }
    
    @IBAction func btnShareAction(_ sender: UIButton)
    {
        if sender.tag == 1
        {
            ProjectUtility.animatePopupView(viewPopup: self.viewPopup, viewDetails: self.viewShare)
        }
        else if sender.tag == 2
        {
            if self.isFavourite == 0
            {
                if self.app.isConnectedToInternet()
                {
                    self.AddDeleteFavouriteAPI(status: 1)
                }
                else
                {
                    Toast(text: self.app.InternetConnectionMessage.localized).show()
                }
            }
            else
            {
                let alertController = UIAlertController(title: nil, message: "Are you sure You want to Remove from Favourites ?".localized, preferredStyle: .alert)
                
                let cancelAction = UIAlertAction(title: "Cancel".localized, style: .default) { (action:UIAlertAction!) in
                    print("you have pressed the Cancel button")
                }
                alertController.addAction(cancelAction)
                
                let OKAction = UIAlertAction(title: "Remove".localized, style: .destructive) { (action:UIAlertAction!) in
                    print("you have pressed OK button")
                    
                    if self.app.isConnectedToInternet()
                    {
                        self.AddDeleteFavouriteAPI(status: 0)
                    }
                    else
                    {
                        Toast(text: self.app.InternetConnectionMessage.localized).show()
                    }
                }
                alertController.addAction(OKAction)
                
                self.present(alertController, animated: true, completion:nil)
            }
        }
    }
    
    @IBAction func btnCancel(_ sender: UIButton)
    {
        if sender.tag == 1
        {
            self.viewPopupDetails.isHidden = true
        }
        else
        {
            self.viewPopup.isHidden = true
        }
    }
    
    @IBAction func btnShareSocialAction(_ sender: UIButton)
    {
        if sender.tag == 1
        {
            let mailComposeViewController = configuredMailComposeViewController()
            if MFMailComposeViewController.canSendMail()
            {
                self.present(mailComposeViewController, animated: true, completion: nil)
            }
        }
        else if sender.tag == 2
        {
            if (MFMessageComposeViewController.canSendText())
            {
                let controller = MFMessageComposeViewController()
                controller.body = self.strShareURL
                controller.recipients = [""]
                controller.messageComposeDelegate = self
                self.present(controller, animated: true, completion: nil)
            }
            else
            {
                self.AlertAction(strTitle: "Your device could not send Message. Please check Message configuration and try again.")
            }
        }
        else if sender.tag == 3
        {
            self.ShareApp()
//            let escapedShareString = self.strShareURL.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
//
//            let url : NSURL = NSURL(string: escapedShareString)!
//
//            let activityViewController : UIActivityViewController = UIActivityViewController(
//                activityItems: [url], applicationActivities: nil)
//
//            // Anything you want to exclude
//            activityViewController.excludedActivityTypes = [
//                UIActivity.ActivityType.postToWeibo,
//                UIActivity.ActivityType.print,
//                UIActivity.ActivityType.assignToContact,
//                UIActivity.ActivityType.saveToCameraRoll,
//                UIActivity.ActivityType.addToReadingList,
//                UIActivity.ActivityType.postToFlickr,
//                UIActivity.ActivityType.postToVimeo,
//                UIActivity.ActivityType.postToTencentWeibo
//            ]
//            self.present(activityViewController, animated: true, completion: nil)
//            //        sideMenuController?.hideLeftViewAnimated()
        }
        else if sender.tag == 4
        {
            var urlWhats = "whatsapp://send?text=\(self.strShareURL)"
            urlWhats = urlWhats.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
            if UIApplication.shared.canOpenURL(URL(string:urlWhats)!)
            {
                UIApplication.shared.open(URL(string:urlWhats)!, options: [:]) { (success) in
                    if success
                    {
                        print("WhatsApp accessed successfully")
                    }
                    else
                    {
                        print("Error accessing WhatsApp")
                        self.AlertAction(strTitle: "Error Accessing WhatsApp")
                    }
                }
            }
        }
        else if sender.tag == 5
        {
            self.TwitterShare()
        }
        else
        {
            self.FBShare()
        }
    }
    
    //MARK:- Mail Methods
    func configuredMailComposeViewController() -> MFMailComposeViewController
    {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self
        
        mailComposerVC.setToRecipients([])//"abc@gmail.com"
        mailComposerVC.setSubject("Sending you an in-app e-mail...")
//        mailComposerVC.setMessageBody("Message From iPhone...", isHTML: false)
        mailComposerVC.setMessageBody(self.strShareURL, isHTML: false)

        return mailComposerVC
    }
    
    func showSendMailErrorAlert(strType : String)
    {
        let alertController = UIAlertController(title: "Could Not Send \(strType)", message: "Your device could not send \(strType).  Please check \(strType) configuration and try again.", preferredStyle: .alert)
        
        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(defaultAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?)
    {
        switch result
        {
        case .cancelled:
            print("Mail cancelled")
        case .saved:
            print("Mail saved")
        case .sent:
            print("Mail sent")
        case .failed:
            print("Mail sent failure: \(String(describing: error?.localizedDescription))")
        default:
            break
        }
        
        // Close the Mail Interface
        //        self.dismiss(animated: true, completion: { _ in })
        self .dismiss(animated: true) {
        }
    }
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult)
    {
        self .dismiss(animated: true)
        {
        }
    }
    
    func AlertAction(strTitle : String)
    {
        let alertController = UIAlertController(title: "Yakrm", message: strTitle, preferredStyle: .alert)
        
        let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
            print("you have pressed OK button")
        }
        alertController.addAction(OKAction)
        
        self.present(alertController, animated: true, completion:nil)
    }
    
    //MARK:- FB Share
    func FBShare()
    {
        let isInstalled : Bool = UIApplication.shared.canOpenURL(URL(string: "fb://")!)
        if isInstalled
        {
            let VC : SLComposeViewController = SLComposeViewController(forServiceType:SLServiceTypeFacebook)
//            VC.add(URL(string: strShareURL))
            VC.setInitialText(strShareURL)
            self.present(VC, animated: true, completion: nil)
        }
        else
        {
            //For Facebook
//            let shareURL = "https://www.facebook.com/sharer/sharer.php?u=" + strShareURL
//            let escapedShareString = shareURL.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
//
//            self.open(scheme: escapedShareString)

//            if let url = URL(string:shareURL)
//            {
//                let vc = SFSafariViewController(url: url, entersReaderIfAvailable: true)
//                vc.delegate=self
//                present(vc, animated: true)
//            }
            
            let alert = UIAlertController(title: "Accounts", message: "Please login to a Facebook account to share.", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func ShareApp()
    {
        let url : NSURL = NSURL(string: "https://itunes.apple.com/us/app/")!
        
        let activityViewController : UIActivityViewController = UIActivityViewController(
            activityItems: [url], applicationActivities: nil)
        
        // Anything you want to exclude
        activityViewController.excludedActivityTypes = [
            UIActivity.ActivityType.postToWeibo,
            UIActivity.ActivityType.print,
            UIActivity.ActivityType.assignToContact,
            UIActivity.ActivityType.saveToCameraRoll,
            UIActivity.ActivityType.addToReadingList,
            UIActivity.ActivityType.postToFlickr,
            UIActivity.ActivityType.postToVimeo,
            UIActivity.ActivityType.postToTencentWeibo
        ]
        self.present(activityViewController, animated: true, completion: nil)
        //        sideMenuController?.hideLeftViewAnimated()
    }
    
    //MARK:- Twitter Share
    func TwitterShare()
    {
        let isInstalled : Bool = UIApplication.shared.canOpenURL(URL(string: "twitter://")!)
        if isInstalled
        {
            let VC : SLComposeViewController = SLComposeViewController(forServiceType:SLServiceTypeTwitter)
//            VC.add(URL(string: strShareURL))
            VC.setInitialText(strShareURL)
            self.present(VC, animated: true, completion: nil)
        }
        else
        {
//            let tweetText = ""
//            let tweetUrl = "http://stackoverflow.com/"
//            let shareString = "https://twitter.com/intent/tweet?text=\(self.strShareURL)&url=\(tweetUrl)"
            let shareString = "https://twitter.com/intent/tweet?text=\(self.strShareURL)"
            // encode a space to %20 for example
            let escapedShareString = shareString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
            
            self.open(scheme: escapedShareString)
            //            let alert = UIAlertController(title: "Accounts", message: "Please login to a Twitter account to share.", preferredStyle: UIAlertController.Style.alert)
            //            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            //            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func open(scheme: String)
    {
        if let url = URL(string: scheme)
        {
            UIApplication.shared.open(url, options: [:], completionHandler:
                {
                    (success) in
                    print("Open \(scheme): \(success)")
            })
        }
    }
    
    //MARK:- Get All Detail API
    func GetAllDetailsAPI()
    {
        loadingNotification = MBProgressHUD.showAdded(to: self.view, animated: false)
        loadingNotification.mode = MBProgressHUDMode.indeterminate
        loadingNotification.label.text = "Loading".localized
        loadingNotification.dimBackground = true
        
        let headers : HTTPHeaders = ["Authorization": self.app.strToken,
                                     "Content-Type":"application/json"]
        print(JSON(headers))

        var strIsLogin = String()
        if self.app.strUserID.isEmpty
        {
            strIsLogin = "false"
        }
        else
        {
            strIsLogin = "true"
        }
        let parameters: Parameters = ["brand_id":self.strBranchID,
                                      "is_logged_in":strIsLogin]
        print(JSON(parameters))
        
        Alamofire.request("\(self.app.BaseURL)getAllVoucherByBrandId", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            debugPrint(response)
            
            self.loadingNotification.hide(animated: true)
            
            if response.response?.statusCode == 200
            {
                if response.result.isSuccess == true
                {
                    if let value = response.result.value
                    {
                        self.json = JSON(value)
                        print(self.json)
                        
                        let strStatus : String = self.json["status"].stringValue
                        self.strMessage = self.json["message"].stringValue
                        
                        if strStatus == "1"
                        {
                            self.viewTop.isHidden = false
                            self.btnComplete.isHidden = false
                            
                            if self.app.strUserID.isEmpty
                            {
                                self.btnShare.frame.origin.x = self.btnFavourite.frame.origin.x
                                self.btnFavourite.isHidden = true
                                self.btnComplete.isHidden = true
                            }
                            else
                            {
                                let is_favourite : Bool = self.json["is_favourite"].boolValue
                                if is_favourite
                                {
                                    self.isFavourite = 1
                                }
                                else
                                {
                                    self.isFavourite = 0
                                }
                                self.checkFavourite()
                            }
                            
//                            self.strShareURL = "\(self.json["brand_name"].stringValue) \(self.json["description"].stringValue)"
                            let strName : String = self.json["brand_name"].stringValue
                            let arabName : String = self.json["brand_name_arab"].stringValue
                            
                            if self.app.strLanguage == "ar"
                            {
                                self.app.isEnglish = false
                                self.lblName.text = arabName
                                           
                                if arabName.isEmpty{
                                               self.lblName.text = strName
                                }
                            }else
                            {
                                self.app.isEnglish = true
                                self.lblName.text = strName
                            }
                            
                           // self.lblName.text = self.json["brand_name"].stringValue
//                            self.lblSub.text = self.json["description"].stringValue

                            var strDescription : String = self.json["description"].stringValue
                            let strArabicDescription : String = self.json["brand_description_arab"].stringValue
                            if !self.app.isEnglish
                            {
                                if !strArabicDescription.isEmpty
                                {
                                    strDescription = strArabicDescription
                                }
                            }
                            self.lblSub.text = strDescription

                            self.lblDetails.text = "Electronic or Paper Gifts".localized
                            
                            var strImage : String = self.json["brand_image"].stringValue
                            strImage = strImage.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
                            self.imgProfile.sd_setImage(with: URL(string: "\(self.app.ImageURL)brand_images/\(strImage)"), placeholderImage: nil)
                            self.arrVouchers = self.json["data"].arrayValue
                            
                            var arrVoucherType : [String] = []
                            if self.arrVouchers.count > 0
                            {
                                for index in 0...self.arrVouchers.count - 1
                                {
                                    let check = Bool()
                                    self.arrAdded.append(check)
                                    
                                    var arrValue = JSON(self.arrVouchers)
                                    let voucher_type : String = arrValue[index]["voucher_type"].stringValue

                                    if !arrVoucherType.contains(voucher_type)
                                    {
                                        arrVoucherType.append(voucher_type)
                                    }
                                }
                            }
                            
                            let strVoucherTypes : String = arrVoucherType.joined(separator:", ")
                            self.lblDetails.text = strVoucherTypes

                            self.tblView.reloadData()
                            
                            let rectTitle = self.lblSub.text!.boundingRect(with: CGSize(width: self.lblSub.frame.size.width, height: CGFloat(50000)), options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: self.lblSub.font as Any], context: nil)
                            if rectTitle.height > 20
                            {
                                self.lblSub.frame = CGRect(x: self.lblSub.frame.origin.x, y: self.lblSub.frame.origin.y, width: self.lblSub.frame.size.width, height: 35)
                            }
                            self.lblDetails.frame = CGRect(x: self.lblDetails.frame.origin.x, y: self.lblSub.frame.origin.y + self.lblSub.frame.size.height, width: self.lblDetails.frame.size.width, height: self.lblDetails.frame.size.height)
                            self.btnFavourite.frame.origin.y = self.lblDetails.frame.origin.y + self.lblDetails.frame.size.height + 5
                            self.btnShare.frame.origin.y = self.lblDetails.frame.origin.y + self.lblDetails.frame.size.height + 5
                            self.imgLogo.frame.origin.y = self.lblDetails.frame.origin.y + self.lblDetails.frame.size.height + 2
                            /*
                            self.lblValue.frame.origin.y = self.btnFavourite.frame.origin.y + self.btnFavourite.frame.size.height + 8
                            self.lblDiscount.frame.origin.y = self.btnFavourite.frame.origin.y + self.btnFavourite.frame.size.height + 8
                            self.lblPay.frame.origin.y = self.btnFavourite.frame.origin.y + self.btnFavourite.frame.size.height + 8

                            self.viewLine.frame.origin.y = self.lblPay.frame.origin.y + self.lblPay.frame.size.height + 10 */
                            self.viewLine.frame.origin.y = self.btnFavourite.frame.origin.y + self.btnFavourite.frame.size.height + 10

                            self.viewTop.frame = CGRect(x: self.viewTop.frame.origin.x, y: self.viewTop.frame.origin.y, width: self.viewTop.frame.size.width, height: self.viewLine.frame.origin.y + self.viewLine.frame.size.height)
                            self.tblView.frame = CGRect(x:self.tblView.frame.origin.x, y: self.viewTop.frame.origin.y + self.viewTop.frame.size.height, width:self.tblView.frame.size.width, height: ScreenSize.SCREEN_HEIGHT - self.viewTop.frame.origin.y - self.viewTop.frame.size.height - 65)//122
                        }
                        else
                        {
                            Toast(text: self.strMessage).show()
                        }
                    }
                }
                else
                {
                    Toast(text: self.app.RequestTimeOut.localized).show()
                }
            }
            else
            {
                print(response.result.error.debugDescription)
                Toast(text: self.app.RequestTimeOut.localized).show()
            }
        }
    }
    
    func checkFavourite()
    {
        var img = UIImage()

        if self.isFavourite == 0
        {
            img = UIImage(named: "star (1).png")!
        }
        else
        {
            img = UIImage(named: "stayellow.png")!
        }
        self.btnFavourite.setImage(img, for: .normal)
    }
    
    //MARK:- Add To Cart API
    func AddToCartAPI(index : Int, strVoucherID : String)
    {
        loadingNotification = MBProgressHUD.showAdded(to: self.view, animated: false)
        loadingNotification.mode = MBProgressHUDMode.indeterminate
        loadingNotification.label.text = "Loading".localized
        loadingNotification.dimBackground = true
        
        let headers : HTTPHeaders = ["Authorization": self.app.strToken,
                                     "Content-Type": "application/json"]
        
        let parameters: Parameters = ["voucher_id":strVoucherID]
        print(JSON(parameters))
        
        Alamofire.request("\(self.app.BaseURL)add_to_cart", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            debugPrint(response)
            
            self.loadingNotification.hide(animated: true)
            
            if response.response?.statusCode == 200
            {
                if response.result.isSuccess == true
                {
                    if let value = response.result.value
                    {
                        self.json = JSON(value)
                        print(self.json)
                        
                        let strStatus : String = self.json["status"].stringValue
                        self.strMessage = self.json["message"].stringValue
                        self.arabMessage = self.json["arab_message"].stringValue
                        
                        if self.app.strLanguage == "ar"
                        {
                            self.app.isEnglish = false
                            Toast(text: self.arabMessage.localized).show()
                            
                            
                        }
                        else
                        {
                            self.app.isEnglish = true
                            Toast(text: self.strMessage).show()
                        }
                        //Toast(text: self.strMessage).show()
                        
                        self.isAdded = true

                        if strStatus == "1"
                        {
                            let check = true
                            self.arrAdded[index] = check
                            let indexPath = IndexPath(item: index, section: 0)
                            self.tblView.reloadRows(at: [indexPath], with: .automatic)
                            
                            UIApplication.shared.cancelAllLocalNotifications()
                            
                            self.app.strCart = self.json["total_cart_item"].stringValue

                            self.app.isCartAdded = true
                            self.app.defaults.setValue(self.app.isCartAdded, forKey: "isCartAdded")
                            self.app.defaults.synchronize()

                            self.app.AddNotification()
                        }
                    }
                }
                else
                {
                    Toast(text: self.app.RequestTimeOut.localized).show()
                }
            }
            else
            {
                print(response.result.error.debugDescription)
                Toast(text: self.app.RequestTimeOut.localized).show()
            }
        }
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent
        notification: UNNotification, withCompletionHandler completionHandler:
        @escaping (UNNotificationPresentationOptions) -> Void)
    {
        print(JSON(notification.request.content.userInfo))
        return completionHandler(UNNotificationPresentationOptions.alert)
    }

//    func userNotificationCenter(_ center: UNUserNotificationCenter,
//                                didReceive response: UNNotificationResponse, withCompletionHandler
//        completionHandler: @escaping () -> Void)
//    {
//        // do something with the notification
//        print(JSON(response.notification.request.content.userInfo))
//
//        let content = UNMutableNotificationContent()
//        content.title = "cart already added"
//        content.body = "scheduled"
//        content.userInfo = ["notification":"456"]
//        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 60, repeats: true)
//        let request = UNNotificationRequest(identifier: "123", content: content, trigger: trigger)
//
//        UNUserNotificationCenter.current().delegate = self
//
//        //adding the notification to notification center
//        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
//
//        self.gotoViewController(json: JSON(response.notification.request.content.userInfo))
//
//        return completionHandler()
//    }
    
    func gotoViewController(json : JSON)
    {
        var strViewController = "ViewController"
        
        if self.app.defaults.string(forKey: "user_id") != nil
        {
            if self.app.defaults.string(forKey: "user_type") != nil
            {
                self.app.strUserType = (self.app.defaults.value(forKey: "user_type") as! String)
            }
            else
            {
                self.app.strUserType = "users"
            }
            if self.app.strUserType == "users"
            {
                strViewController = "HomeView"
            }
            else
            {
                strViewController = "CouponView"
            }
        }
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let navigationController = storyboard.instantiateViewController(withIdentifier: "NavigationController") as! UINavigationController
        navigationController.setViewControllers([storyboard.instantiateViewController(withIdentifier: strViewController)], animated: false)
        let mainViewController = storyboard.instantiateInitialViewController() as! MainViewController
        mainViewController.rootViewController = navigationController
        mainViewController.setup(type: UInt(2))
        
        let window = UIApplication.shared.delegate!.window!!
        window.rootViewController = mainViewController
        
        UIView.transition(with: window, duration: 0.3, options: [.transitionCrossDissolve], animations: nil, completion: nil)
        let VC = storyboard.instantiateViewController(withIdentifier: "CartView") as! CartView
        navigationController.pushViewController(VC, animated: true)
    }
    
    //MARK:- Delete Favourite API
    func AddDeleteFavouriteAPI(status : Int)
    {
        loadingNotification = MBProgressHUD.showAdded(to: self.view, animated: false)
        loadingNotification.mode = MBProgressHUDMode.indeterminate
        loadingNotification.label.text = "Loading".localized
        loadingNotification.dimBackground = true
        
        let headers : HTTPHeaders = ["Authorization": self.app.strToken,
                                     "Content-Type": "application/json"]
        
        let parameters: Parameters = ["brand_id":self.strBranchID,
                                      "is_favourite":status]
        print(JSON(parameters))
        
        Alamofire.request("\(self.app.BaseURL)addremove_to_favourite", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            debugPrint(response)
            
            self.loadingNotification.hide(animated: true)
            
            if response.response?.statusCode == 200
            {
                if response.result.isSuccess == true
                {
                    if let value = response.result.value
                    {
                        self.json = JSON(value)
                        print(self.json)
                        
                        let strStatus : String = self.json["status"].stringValue
                        self.strMessage = self.json["message"].stringValue
                        
                        Toast(text: self.strMessage).show()

                        if strStatus == "1"
                        {
                            self.isFavourite = status
                            self.checkFavourite()
                        }
                    }
                }
                else
                {
                    Toast(text: self.app.RequestTimeOut.localized).show()
                }
            }
            else
            {
                print(response.result.error.debugDescription)
                Toast(text: self.app.RequestTimeOut.localized).show()
            }
        }
    }
    
    
    
    
}
