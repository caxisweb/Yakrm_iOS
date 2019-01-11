
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

class DetailsView: UIViewController,UITableViewDelegate,UITableViewDataSource,MFMailComposeViewControllerDelegate,SFSafariViewControllerDelegate,MFMessageComposeViewControllerDelegate
{
    //MARK:- Outlet
    
    @IBOutlet var viewNavigation: UIView!
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var viewTop: UIView!
    @IBOutlet var imgProfile: UIImageView!
    @IBOutlet var lblName: UILabel!
    @IBOutlet var lblSub: UILabel!
    @IBOutlet var lblDetails: UILabel!
    @IBOutlet var btnShare: UIButton!
    @IBOutlet var btnAdd: UIButton!
    @IBOutlet var imgLogo: UIImageView!
    
    @IBOutlet var tblView: UITableView!
    @IBOutlet var btnComplete: UIButton!
    
    
    @IBOutlet var viewAdded: UIView!
    
    @IBOutlet var viewPopup: UIView!
    @IBOutlet var viewShare: UIView!

    var app = AppDelegate()
    
    var strShareURL = "https://itunes.apple.com/us/app/hive-%D9%87%D8%A7%D9%8A%DA%A4/id1206432265?ls=1&mt=8"

    //MARK:-
    override func viewDidLoad()
    {
        super.viewDidLoad()
        app = UIApplication.shared.delegate as! AppDelegate
        
        self.viewNavigation.backgroundColor = UIColor.init(rgb: 0xEE4158)

        if DeviceType.IS_IPHONE_X || DeviceType.IS_IPHONE_XR
        {
            self.viewNavigation.frame = CGRect(x:self.viewNavigation.frame.origin.x, y: self.viewNavigation.frame.origin.y, width:self.viewNavigation.frame.size.width, height: 88)
            self.viewTop.frame = CGRect(x:self.viewTop.frame.origin.x, y: self.viewNavigation.frame.origin.y + self.viewNavigation.frame.size.height, width:self.viewTop.frame.size.width, height: self.viewTop.frame.size.height)
            self.tblView.frame = CGRect(x:self.tblView.frame.origin.x, y: self.viewTop.frame.origin.y + self.viewTop.frame.size.height, width:self.tblView.frame.size.width, height: ScreenSize.SCREEN_HEIGHT - self.viewTop.frame.origin.y - self.viewTop.frame.size.height - 65)//122
        }
        
        if DeviceType.IS_IPHONE_5
        {
//            self.imgProfile.frame = CGRect(x:self.imgProfile.frame.origin.x, y: self.imgProfile.frame.origin.y, width:self.imgProfile.frame.size.height, height: self.imgProfile.frame.size.height)
//
//            self.lblName.frame = CGRect(x:self.imgProfile.frame.origin.x + self.imgProfile.frame.size.width + 10, y: self.lblName.frame.origin.y, width:ScreenSize.SCREEN_WIDTH - self.imgProfile.frame.size.width - 40, height: self.lblName.frame.size.height)
//            self.lblSub.frame = CGRect(x:self.imgProfile.frame.origin.x + self.imgProfile.frame.size.width + 10, y: self.lblSub.frame.origin.y, width:ScreenSize.SCREEN_WIDTH - self.imgProfile.frame.size.width - 40, height: self.lblSub.frame.size.height)
//            self.lblDetails.frame = CGRect(x:self.imgProfile.frame.origin.x + self.imgProfile.frame.size.width + 10, y: self.lblDetails.frame.origin.y, width:ScreenSize.SCREEN_WIDTH - self.imgProfile.frame.size.width - 40, height: self.lblDetails.frame.size.height)
//            self.btnAdd.frame.origin.x = self.lblName.frame.origin.x + 5
//            self.btnShare.frame.origin.x = self.btnAdd.frame.origin.x + self.btnAdd.frame.size.width + 10
//
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
        }
        else
        {
            self.lblName.textAlignment = .right
            self.lblSub.textAlignment = .right
            self.lblDetails.textAlignment = .right
            self.lblTitle.textAlignment = .right
        }
        
        self.tblView.delegate = self
        self.tblView.dataSource = self
    
        self.btnComplete.layer.cornerRadius = 5
        self.viewAdded.layer.cornerRadius = 5
        self.viewAdded.clipsToBounds = true
        
        self.viewPopup.isHidden = true
        self.viewPopup.frame.origin.y = 0
        self.viewShare.center = self.view.center
        
        self.viewAdded.isHidden = true
    }
    
    @IBAction func btnBack(_ sender: UIButton)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK:- Tablview
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        var cell : DetailsCell!
        cell = tblView.dequeueReusableCell(withIdentifier: "DetailsCell") as! DetailsCell!
        if cell == nil
        {
            cell = Bundle.main.loadNibNamed("DetailsCell", owner: self, options: nil)?[0] as! DetailsCell!
        }
        var img = UIImage()
        if indexPath.row == 0
        {
            img = UIImage(named: "ic_fillcart.png")!
        }
        else
        {
            img = UIImage(named: "ic_addcart_plush.png")!
        }
        cell.imgProfile.image = img
        if DeviceType.IS_IPHONE_5
        {
            cell.lblValue.font = cell.lblValue.font.withSize(14)
            cell.lblPay.font = cell.lblPay.font.withSize(14)
            cell.lblDiscount.font = cell.lblDiscount.font.withSize(14)
        }
        
        cell.selectionStyle = .none
        tblView.rowHeight = cell.frame.size.height
        
        return cell
    }
    
    @IBAction func btnAllAction(_ sender: UIButton)
    {
        if sender.tag == 1
        {
            
        }
        else
        {
            let VC = self.storyboard?.instantiateViewController(withIdentifier: "PurchasedView") as! PurchasedView
            self.navigationController?.pushViewController(VC, animated: true)
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
            
        }
    }
    
    @IBAction func btnCancel(_ sender: UIButton)
    {
        self.viewPopup.isHidden = true
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
                controller.body = "Message Body"
                controller.recipients = [""]
                controller.messageComposeDelegate = self
                self.present(controller, animated: true, completion: nil)
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
