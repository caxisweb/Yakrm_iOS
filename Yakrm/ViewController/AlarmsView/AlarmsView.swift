//
//  AlarmsView.swift
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
class AlarmsView: UIViewController ,UITableViewDelegate,UITableViewDataSource
{
    //MARK:- Outlet
    @IBOutlet var viewNavigation: UIView!
    @IBOutlet var tblView: UITableView!
    
//    var loadingNotification : MBProgressHUD!
    var json : JSON!
    var strMessage : String!
    
    var app = AppDelegate()

//    var arrNotification : [Dictionary<String,Any>] = []
    var arrNotification : [[Any]] = []
    var arrTitle : [String] = []

    struct Notification
    {
        let date: String
        let arrVal: Any
        init(_ date: String, _ arrVal: Int)
        {
            self.date = date
            self.arrVal = arrVal
        }
    }
    
    //MARK:-
    override func viewDidLoad()
    {
        super.viewDidLoad()
        app = UIApplication.shared.delegate as! AppDelegate
        
        self.viewNavigation.backgroundColor = UIColor.init(rgb: 0xEE4158)

        if DeviceType.IS_IPHONE_X || DeviceType.IS_IPHONE_XR
        {
            self.viewNavigation.frame = CGRect(x:self.viewNavigation.frame.origin.x, y: self.viewNavigation.frame.origin.y, width:self.viewNavigation.frame.size.width, height: 88)
            self.tblView.frame = CGRect(x:self.tblView.frame.origin.x, y: self.viewNavigation.frame.origin.y + self.viewNavigation.frame.size.height, width:self.tblView.frame.size.width, height: ScreenSize.SCREEN_HEIGHT - self.viewNavigation.frame.size.height)
        }
        self.tblView.delegate = self
        self.tblView.dataSource = self
        
        if self.app.isConnectedToInternet()
        {
            self.GetNotificationAPI()
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
        return self.arrTitle.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        let value = self.arrNotification[section]
        return value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        var cell : AlarmsCell!
        cell = tblView.dequeueReusableCell(withIdentifier: "AlarmsCell") as! AlarmsCell?
        if cell == nil
        {
            cell = Bundle.main.loadNibNamed("AlarmsCell", owner: self, options: nil)?[1] as! AlarmsCell?
        }
        
        let value = self.arrNotification[indexPath.section]
        let arrValue = JSON(value)
        let strSubject : String = arrValue[indexPath.row]["subject"].stringValue
        let strDesc : String = arrValue[indexPath.row]["description"].stringValue
        let strDate : String = arrValue[indexPath.row]["created_at"].stringValue
        
        cell.lblName.text = strSubject
        cell.lblDetails.text = strDesc
        cell.lblDate.text = strDate
        
        if self.app.isEnglish
        {
            cell.lblName.textAlignment = .left
            cell.lblDetails.textAlignment = .left
            cell.lblDate.textAlignment = .left
        }
        else
        {
            cell.lblName.textAlignment = .right
            cell.lblDetails.textAlignment = .right
            cell.lblDate.textAlignment = .right
        }
        if DeviceType.IS_IPHONE_5
        {
            cell.lblName.font = cell.lblName.font.withSize(9)
            cell.lblDetails.font = cell.lblDetails.font.withSize(9)
            cell.lblDate.font = cell.lblDate.font.withSize(8)
        }
        
        let rectName = cell.lblName.text!.boundingRect(with: CGSize(width: cell.lblName.frame.size.width, height: CGFloat(50000)), options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: cell.lblName.font], context: nil)
        var NameHeight = cell.lblName.frame.size.height
        if rectName.height > NameHeight
        {
            NameHeight = rectName.height
        }
        
        cell.lblName.frame = CGRect(x: cell.lblName.frame.origin.x, y: cell.lblName.frame.origin.y, width: cell.lblName.frame.size.width, height: NameHeight)
        
        let rectDetails = cell.lblDetails.text!.boundingRect(with: CGSize(width: cell.lblDetails.frame.size.width, height: CGFloat(50000)), options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: cell.lblDetails.font], context: nil)
        
        var DetailsHeight = cell.lblName.frame.size.height
        if rectDetails.height > DetailsHeight
        {
            DetailsHeight = rectDetails.height
        }
        
        cell.lblDetails.frame = CGRect(x: cell.lblDetails.frame.origin.x, y: cell.lblName.frame.origin.y + cell.lblName.frame.size.height, width: cell.lblDetails.frame.size.width, height: DetailsHeight)
        
        cell.lblDate.frame = CGRect(x: cell.lblDate.frame.origin.x, y: cell.lblDetails.frame.origin.y + cell.lblDetails.frame.size.height + 5, width: cell.lblDate.frame.size.width, height: cell.lblDate.frame.size.height)
        cell.viewLine.frame = CGRect(x: cell.viewLine.frame.origin.x, y: cell.lblDate.frame.origin.y + cell.lblDate.frame.size.height + 10, width: cell.viewLine.frame.size.width, height: cell.viewLine.frame.size.height)
        
        cell.selectionStyle = .none
        tblView.rowHeight = cell.viewLine.frame.origin.y + cell.viewLine.frame.size.height//cell.frame.size.height
        
        return cell
    }
    
    @objc func buttonAction(sender: UIButton!)
    {
        let buttonPosition : CGPoint = sender.convert(CGPoint.zero, to: self.tblView)
        let indexPath : IndexPath = self.tblView.indexPathForRow(at: buttonPosition)!
        
        let alertController = UIAlertController(title: "Are you sure You want to Delete ?".localized, message: nil, preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel".localized, style: .default) { (action:UIAlertAction!) in
            print("you have pressed the Cancel button")
        }
        alertController.addAction(cancelAction)
        
        let OKAction = UIAlertAction(title: "Delete".localized, style: .destructive) { (action:UIAlertAction!) in
            print("you have pressed OK button")
            print("Section : \(indexPath.section) Row : \(indexPath.row)")
        }
        alertController.addAction(OKAction)
        
        self.present(alertController, animated: true, completion:nil)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        let viewHeader = UIView()
        viewHeader.frame = CGRect(x:0, y: 0, width:tblView.frame.size.width, height: 40)
        viewHeader.backgroundColor = UIColor.white
        
        let vv = UIView()
        vv.frame =  viewHeader.frame
        vv.backgroundColor = UIColor.init(rgb: 0xCBCBCB).withAlphaComponent(0.5)
        
        let lbl = UILabel()
        lbl.frame = CGRect(x:15, y: 0, width:tblView.frame.size.width-30, height: 40)
        var lblFontSize : CGFloat = 10
        if DeviceType.IS_IPHONE_5
        {
            lblFontSize = 9
        }
//        lbl.font = UIFont (name: "GE SS Two Medium", size: lblFontSize)
        lbl.font = UIFont.systemFont(ofSize: lblFontSize, weight: .medium)
        lbl.backgroundColor = UIColor.clear
        if self.app.isEnglish
        {
            lbl.textAlignment = .left
        }
        else
        {
            lbl.textAlignment = .right
        }
        lbl.textColor = UIColor.darkGray
        viewHeader.addSubview(vv)
        viewHeader.addSubview(lbl)
        lbl.text = self.arrTitle[section]//"Yesterday".localized
        
        return viewHeader
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        return 40
    }
    
    @IBAction func btnDeleteAll(_ sender: UIButton)
    {
        let alertController = UIAlertController(title: "Are you sure You want to Delete All ?", message: nil, preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "NO", style: .default) { (action:UIAlertAction!) in
            print("you have pressed the Cancel button")
        }
        alertController.addAction(cancelAction)
        
        let OKAction = UIAlertAction(title: "YES", style: .destructive) { (action:UIAlertAction!) in
            print("you have pressed OK button")
            
        }
        alertController.addAction(OKAction)
        
        self.present(alertController, animated: true, completion:nil)
    }
    
    //MARK:- Get Notification API
    func GetNotificationAPI()
    {
        let loadingNotification = MBProgressHUD.showAdded(to: self.view, animated: false)
        loadingNotification.mode = MBProgressHUDMode.indeterminate
        loadingNotification.label.text = "Loading".localized
        loadingNotification.dimBackground = true
        
        let headers : HTTPHeaders = ["Authorization": self.app.strToken,
                                     "Content-Type": "application/json"]
        
//        let parameters: Parameters = ["brand_id":self.strBranchID,
//                                      "is_favourite":status]
//        print(JSON(parameters))
        
        Alamofire.request("\(self.app.BaseURL)get_users_notifications_history", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers).responseJSON
            { response in
            debugPrint(response)
            
            loadingNotification.hide(animated: true)
            
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
                            var arrValue = self.json["data"]
                            
                            if arrValue.count > 0
                            {
                                for index in 0...arrValue.count-1
                                {
                                    let strDate : String = arrValue[index]["created_at"].stringValue
                                    
                                    let dateFormatter = DateFormatter()
                                    dateFormatter.dateFormat = "dd MMM yyyy"
                                    let date = dateFormatter.date(from: strDate)
                                    
                                    var strText = String()
                                    if NSCalendar.current.isDateInToday(date!)
                                    {
                                        strText = "Today"
                                    }
                                    else if NSCalendar.current.isDateInYesterday(date!)
                                    {
                                        strText = "Yesterday"
                                    }
//                                    else if NSCalendar.current.isDateInTomorrow(date!)
//                                    {
//                                        strText = "Tomorrow"
//                                    }
                                    else
                                    {
//                                        dateFormatter.dateFormat = "dd MMM yyyy"
                                        strText = strDate//dateFormatter.string(from: date!)
                                    }
                                    if self.arrTitle.contains(strText)
                                    {
                                        if let ind = self.arrTitle.firstIndex(of: strText)//indexes(of: strText)
                                        {
                                            var values = self.arrNotification[ind]
                                            print(values)
                                            values.append(arrValue[index])
                                            self.arrNotification[ind] = values
                                        }
                                    }
                                    else
                                    {
                                        self.arrTitle.append(strText)
                                        var arrDic : [Any] = []
                                        arrDic.append(arrValue[index])
                                        self.arrNotification.append(arrDic)
                                    }
                                }
                                self.arrTitle = self.arrTitle.reversed()
                                self.arrNotification = self.arrNotification.reversed()
                            }
                            self.tblView.reloadData()
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
    
    
    
}
