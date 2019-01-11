//
//  SideMenuView.swift
//  LGMenu
//
//  Created by INFORAAM on 04/08/17.
//  Copyright © 2017 INFORAAM. All rights reserved.
//

import UIKit
import MessageUI
import SafariServices
import Social


class SideMenuView: UIViewController,UITableViewDelegate,UITableViewDataSource, MFMailComposeViewControllerDelegate,SFSafariViewControllerDelegate,MFMessageComposeViewControllerDelegate
{
    //MARK:- Outlet
    
    
    @IBOutlet var tblMenuOptions : UITableView!
    var arrayMenuOptions = [Dictionary<String,String>]()
    var cell = SideMenuCell()
    
    var row = Int()
    var app = AppDelegate()
    
    var strShareURL = "https://itunes.apple.com/us/app/hive-%D9%87%D8%A7%D9%8A%DA%A4/id1206432265?ls=1&mt=8"

    //MARK:-
    override func viewDidLoad()
    {
        super.viewDidLoad()
        app = UIApplication.shared.delegate as! AppDelegate
        
        self.navigationController?.isNavigationBarHidden = true
        
        if self.app.defaults.string(forKey: "selectedLanguagebool") != nil
        {
            self.app.isEnglish = (self.app.defaults.value(forKey: "selectedLanguagebool") as! Bool)
        }
        
        if DeviceType.IS_IPHONE_X || DeviceType.IS_IPHONE_XR
        {
            let vv = UIView()
            vv.backgroundColor = UIColor(rgb: 0xD93454)//UIColor.red
            vv.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 24)
            self.view.addSubview(vv)
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.showCartView(_:)), name: NSNotification.Name(rawValue: "SidemenuView"), object: nil)

        self.updateArrayMenuOptions()
    }
    
    @objc func showCartView(_ notification: NSNotification)
    {
        self.updateArrayMenuOptions()
    }

    func updateArrayMenuOptions()
    {
        self.arrayMenuOptions.removeAll()
        
        self.arrayMenuOptions.append(["title":"Main Page".localized, "icon":"1.Main.png"])
        self.arrayMenuOptions.append(["title":"My Personal Account".localized, "icon":"2.myProfile.png"])
        self.arrayMenuOptions.append(["title":"Active Vouchers".localized, "icon":"3.Active.png"])
        self.arrayMenuOptions.append(["title":"Favorite Vouchers".localized, "icon":"4.Favorite.png"])
        self.arrayMenuOptions.append(["title":"Best Brands".localized, "icon":"5.Best.png"])
        self.arrayMenuOptions.append(["title":"Transactions Record".localized, "icon":"6.Transaction.png"])
        self.arrayMenuOptions.append(["title":"Auctions".localized, "icon":"7.Auction.png"])
        self.arrayMenuOptions.append(["title":"Payment Methods".localized, "icon":"8.Payment.png"])
        self.arrayMenuOptions.append(["title":"Support And Contact".localized, "icon":"9.Support.png"])
        self.arrayMenuOptions.append(["title":"About The Application".localized, "icon":"10.About.png"])
        self.arrayMenuOptions.append(["title":"Instructions And Conditions".localized, "icon":"11.Instruction.png"])
        self.arrayMenuOptions.append(["title":"Sign Out".localized, "icon":"12.SignOut.png"])
//        if self.app.isEnglish
//        {
//        self.arrayMenuOptions.append(["title":"النسخة الإنجليزية", "icon":"user"])
//        }
//        else
//        {
        self.arrayMenuOptions.append(["title":"English Version".localized, "icon":"13.Language.png"])
//        }
        self.arrayMenuOptions.append(["title":"Share With Your Friends".localized, "icon":"user"])
        
        self.tblMenuOptions.delegate = self
        self.tblMenuOptions.dataSource = self
        self.tblMenuOptions.separatorStyle = .none
        self.tblMenuOptions.reloadData()
    }

    //MARK:- TablView Methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return arrayMenuOptions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        var cell : SideMenuCell!
        cell = tableView.dequeueReusableCell(withIdentifier: "SideMenuCell") as! SideMenuCell!
        
        if cell == nil
        {
            if indexPath.row == 0
            {
                cell = Bundle.main.loadNibNamed("SideMenuCell", owner: self, options: nil)?[0] as! SideMenuCell
            }
            else if indexPath.row == self.arrayMenuOptions.count - 1
            {
                cell = Bundle.main.loadNibNamed("SideMenuCell", owner: self, options: nil)?[2] as! SideMenuCell
                
                if DeviceType.IS_IPHONE_5
                {
                    cell.btnMail.frame = CGRect(x:cell.btnMail.frame.origin.x, y: cell.btnMail.frame.origin.y, width:30, height: 30)
                    cell.btnSMS.frame = CGRect(x:cell.btnSMS.frame.origin.x, y: cell.btnSMS.frame.origin.y, width:30, height: 30)
                    cell.btnUser.frame = CGRect(x:cell.btnUser.frame.origin.x, y: cell.btnUser.frame.origin.y, width:30, height: 30)
                    cell.btnTwitter.frame = CGRect(x:cell.btnTwitter.frame.origin.x, y: cell.btnTwitter.frame.origin.y, width:30, height: 30)
                    cell.btnFB.frame = CGRect(x:cell.btnFB.frame.origin.x, y: cell.btnFB.frame.origin.y, width:30, height: 30)
                    
                    cell.btnCall.frame = CGRect(x:cell.btnCall.frame.origin.x, y:
                        15, width:30, height: 30)
                }
                
                cell.btnMail.layer.cornerRadius = cell.btnMail.frame.size.height / 2
                cell.btnSMS.layer.cornerRadius = cell.btnMail.frame.size.height / 2
                cell.btnUser.layer.cornerRadius = cell.btnMail.frame.size.height / 2
                cell.btnTwitter.layer.cornerRadius = cell.btnMail.frame.size.height / 2
                cell.btnFB.layer.cornerRadius = cell.btnMail.frame.size.height / 2

                cell.btnMail.addTarget(self, action:#selector(self.buttonClicked), for: .touchUpInside)
                cell.btnSMS.addTarget(self, action:#selector(self.buttonClicked), for: .touchUpInside)
                cell.btnCall.addTarget(self, action:#selector(self.buttonClicked), for: .touchUpInside)
                cell.btnUser.addTarget(self, action:#selector(self.buttonClicked), for: .touchUpInside)
                cell.btnTwitter.addTarget(self, action:#selector(self.buttonClicked), for: .touchUpInside)
                cell.btnFB.addTarget(self, action:#selector(self.buttonClicked), for: .touchUpInside)
            }
            else
            {
                cell = Bundle.main.loadNibNamed("SideMenuCell", owner: self, options: nil)?[1] as! SideMenuCell
            }
        }
        let img : UIImage = UIImage(named: arrayMenuOptions[indexPath.row]["icon"]!)!
        cell.lblName.text = arrayMenuOptions[indexPath.row]["title"]!
        
        if self.app.isEnglish
        {
            cell.lblName.textAlignment = .left
        }
        else
        {
            cell.lblName.textAlignment = .right
        }
        if indexPath.row == self.arrayMenuOptions.count - 1
        {
            if DeviceType.IS_IPHONE_5
            {
                cell.lblName.font = cell.lblName.font.withSize(14)
            }
            cell.lblName.textAlignment = .center
        }
        else
        {
            cell.imgSidebaar.image = img//.maskWithColor(color: UIColor.white)
            cell.imgSidebaar.clipsToBounds = true

            if DeviceType.IS_IPHONE_5
            {
                cell.lblName.font = cell.lblName.font.withSize(12)
            }
        }

        cell.selectionStyle = .none
        cell.backgroundColor = UIColor.init(rgb: 0xEE4158)//DF1C4E)
        
        tblMenuOptions.rowHeight = cell.frame.size.height
        return cell
    }
    
    @objc func buttonClicked(sender : UIButton)
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
                controller.body = "Message Body"
                controller.recipients = [""]
                controller.messageComposeDelegate = self
                self.present(controller, animated: true, completion: nil)
            }
            else
            {
                self.AlertAction(strTitle: "Error Accessing SMS")
            }
        }
        else if sender.tag == 3
        {
            
        }
        else if sender.tag == 4
        {
            let date = Date()
            let msg = "Hi my dear friends\(date)"
            var urlWhats = "whatsapp://send?text=\(msg)"
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
//        print("\(sender.tag)")
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
  
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        self.row = indexPath.row
        let mainViewController = sideMenuController!
        let row : Int = indexPath.row
        
        if row == 0
        {
            mainViewController.hideLeftViewAnimated()
//            let VC = self.storyboard?.instantiateViewController(withIdentifier: "HomeView") as! HomeView
//
//            let navigationController = mainViewController.rootViewController as! NavigationController
//            navigationController.pushViewController(VC, animated: true)
//
//            mainViewController.hideLeftView(animated: true, completionHandler: nil)
        }
        else if row == 1
        {
            if self.app.strUserID.isEmpty
            {
                let VC = self.storyboard?.instantiateViewController(withIdentifier: "ViewController") as! ViewController
                
                let navigationController = mainViewController.rootViewController as! NavigationController
                navigationController.pushViewController(VC, animated: true)
                
                mainViewController.hideLeftView(animated: true, completionHandler: nil)
            }
            else
            {
                let VC = self.storyboard?.instantiateViewController(withIdentifier: "PersonalView") as! PersonalView
                
                let navigationController = mainViewController.rootViewController as! NavigationController
                navigationController.pushViewController(VC, animated: true)
                
                mainViewController.hideLeftView(animated: true, completionHandler: nil)
            }
        }
        else if row == 2
        {
            let VC = self.storyboard?.instantiateViewController(withIdentifier: "ActiveVoucherView") as! ActiveVoucherView

            let navigationController = mainViewController.rootViewController as! NavigationController
            navigationController.pushViewController(VC, animated: true)
            
            mainViewController.hideLeftView(animated: true, completionHandler: nil)
        }
        else if row == 3
        {
            let VC = self.storyboard?.instantiateViewController(withIdentifier: "FavoritesView") as! FavoritesView

            let navigationController = mainViewController.rootViewController as! NavigationController
            navigationController.pushViewController(VC, animated: true)
            
            mainViewController.hideLeftView(animated: true, completionHandler: nil)
        }
        else if row == 4
        {
            let VC = self.storyboard?.instantiateViewController(withIdentifier: "FavoriteBrandView") as! FavoriteBrandView
            
            let navigationController = mainViewController.rootViewController as! NavigationController
            navigationController.pushViewController(VC, animated: true)
            
            mainViewController.hideLeftView(animated: true, completionHandler: nil)
        }
        else if row == 5
        {
            let VC = self.storyboard?.instantiateViewController(withIdentifier: "OprationlogView") as! OprationlogView

            let navigationController = mainViewController.rootViewController as! NavigationController
            navigationController.pushViewController(VC, animated: true)

            mainViewController.hideLeftView(animated: true, completionHandler: nil)
        }
        else if row == 6
        {
            let VC = self.storyboard?.instantiateViewController(withIdentifier: "AuctionView") as!
            AuctionView

            let navigationController = mainViewController.rootViewController as! NavigationController
            navigationController.pushViewController(VC, animated: true)

            mainViewController.hideLeftView(animated: true, completionHandler: nil)
        }
        else if row == 7
        {
//            let VC = self.storyboard?.instantiateViewController(withIdentifier: "VoucherExpiredView") as! VoucherExpiredView
//
//            let navigationController = mainViewController.rootViewController as! NavigationController
//            navigationController.pushViewController(VC, animated: true)
//
//            mainViewController.hideLeftView(animated: true, completionHandler: nil)
        }
        else if row == 8
        {
            let VC = self.storyboard?.instantiateViewController(withIdentifier: "FeedbackView") as! FeedbackView
            
            let navigationController = mainViewController.rootViewController as! NavigationController
            navigationController.pushViewController(VC, animated: true)
            
            mainViewController.hideLeftView(animated: true, completionHandler: nil)
        }
        else if row == 9
        {
            let VC = self.storyboard?.instantiateViewController(withIdentifier: "GeneralView") as! GeneralView
            
            let navigationController = mainViewController.rootViewController as! NavigationController
            navigationController.pushViewController(VC, animated: true)
            
            mainViewController.hideLeftView(animated: true, completionHandler: nil)
        }
        else if row == 10
        {
            let VC = self.storyboard?.instantiateViewController(withIdentifier: "TermsView") as! TermsView
            
            let navigationController = mainViewController.rootViewController as! NavigationController
            navigationController.pushViewController(VC, animated: true)
            
            mainViewController.hideLeftView(animated: true, completionHandler: nil)
        }
        else if row == 11
        {
            let alertController = UIAlertController(title: "Are you sure ?", message: "You want to log out ?", preferredStyle: .alert)
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .default) { (action:UIAlertAction!) in
                print("you have pressed the Cancel button")
            }
            alertController.addAction(cancelAction)
            
            let OKAction = UIAlertAction(title: "Logout", style: .destructive) { (action:UIAlertAction!) in
                print("you have pressed OK button")
                
                self.app.strUserID = ""
                self.app.defaults.removeObject(forKey: "user_id")
                self.app.defaults.synchronize()
                
                let VC = self.storyboard?.instantiateViewController(withIdentifier: "ViewController") as! ViewController
                
                let navigationController = mainViewController.rootViewController as! NavigationController
                navigationController.pushViewController(VC, animated: true)
                
                mainViewController.hideLeftView(animated: true, completionHandler: nil)

            }
            alertController.addAction(OKAction)
            
            self.present(alertController, animated: true, completion:nil)
        }
        else if row == 12
        {
            if self.app.strLanguage == "ar"
            {
                self.app.strLanguage = "en"
                self.app.isEnglish = true
            }
            else
            {
                self.app.strLanguage = "ar"
                self.app.isEnglish = false
            }
            self.app.defaults.setValue(self.app.strLanguage, forKey: "selectedLanguage")
            self.app.defaults.setValue(self.app.isEnglish, forKey: "selectedLanguagebool")
            self.app.defaults.synchronize()
            sideMenuController?.hideLeftViewAnimated()
            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "SidemenuView"), object: nil, userInfo: nil)

            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "LANGUAGE_WILL_CHANGE"), object: self.app.strLanguage)

            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let navigationController = storyboard.instantiateViewController(withIdentifier: "NavigationController") as! UINavigationController
            navigationController.setViewControllers([storyboard.instantiateViewController(withIdentifier: "HomeView")], animated: false)
            let mainViewController = storyboard.instantiateInitialViewController() as! MainViewController
            mainViewController.rootViewController = navigationController
            mainViewController.setup(type: UInt(2))
            
            let window = UIApplication.shared.delegate!.window!!
            window.rootViewController = mainViewController
            
            UIView.transition(with: window, duration: 0.3, options: [.transitionCrossDissolve], animations: nil, completion: nil)
        }
        
    }
    
    func ShareApp()
    {
        let url : NSURL = NSURL(string: "https://play.google.com/store/apps/details?id=com.geetganga&hl=en")!
        
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
    
    //MARK:- Mail Methods
    func configuredMailComposeViewController() -> MFMailComposeViewController
    {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self
        
        mailComposerVC.setToRecipients(["abc@gmail.com"])//"smile@momentsunlimited.in"
        mailComposerVC.setSubject("Sending you an in-app e-mail...")
        mailComposerVC.setMessageBody("Message From iPhone...", isHTML: false)
        
        return mailComposerVC
    }
    
    func showSendMailErrorAlert()
    {
        let alertController = UIAlertController(title: "Could Not Send Email", message: "Your device could not send e-mail.  Please check e-mail configuration and try again.", preferredStyle: .alert)
        
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

    //MARK:- FB Share
    func FBShare()
    {
        let isInstalled : Bool = UIApplication.shared.canOpenURL(URL(string: "fb://")!)
        if isInstalled
        {
            let VC : SLComposeViewController = SLComposeViewController(forServiceType:SLServiceTypeFacebook)
            VC.add(URL(string: strShareURL))
            self.present(VC, animated: true, completion: nil)
        }
        else
        {
            //For Facebook
            let shareURL = "https://www.facebook.com/sharer/sharer.php?u=" + strShareURL
            if let url = URL(string:shareURL)
            {
                let vc = SFSafariViewController(url: url, entersReaderIfAvailable: true)
                vc.delegate=self
                present(vc, animated: true)
            }

//            let alert = UIAlertController(title: "Accounts", message: "Please login to a Facebook account to share.", preferredStyle: UIAlertController.Style.alert)
//            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
//            self.present(alert, animated: true, completion: nil)
        }
    }

    //MARK:- Twitter Share
    func TwitterShare()
    {
        let isInstalled : Bool = UIApplication.shared.canOpenURL(URL(string: "twitter://")!)
        if isInstalled
        {
            let VC : SLComposeViewController = SLComposeViewController(forServiceType:SLServiceTypeTwitter)
            VC.add(URL(string: strShareURL))
            self.present(VC, animated: true, completion: nil)
        }
        else
        {
            let tweetText = ""
            let tweetUrl = "http://stackoverflow.com/"
            let shareString = "https://twitter.com/intent/tweet?text=\(tweetText)&url=\(tweetUrl)"
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
}
