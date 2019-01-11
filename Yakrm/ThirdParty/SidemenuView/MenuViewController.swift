//
//  MenuViewController.swift
//  Itext2pay
//
//  Created by Gaurav Parmar on 04/12/16.
//  Copyright © 2016 Developer. All rights reserved.
//

import UIKit
import SDWebImage

protocol SlideMenuDelegate
{
    func slideMenuItemSelectedAtIndex(_ index : Int32)
}

class MenuViewController: UIViewController, UITableViewDataSource, UITableViewDelegate
{
    //MARK:- Outlet
    /**
     *  Array to display menu options
     */
    @IBOutlet var tblMenuOptions : UITableView!
    
    /**
     *  Transparent button to hide menu
     */
    @IBOutlet var btnCloseMenuOverlay : UIButton!
    
    /**
     *  Array containing menu options
     */
    var arrayMenuOptions = [Dictionary<String,String>]()
    
    /**
     *  Menu button which was tapped to display the menu
     */
    var btnMenu : UIButton!
    
    /**
     *  Delegate of the MenuVC
     */
    var delegate : SlideMenuDelegate?
    var cell = SideMenuCell()

    var app = AppDelegate()
    var strTitle = String()

    //MARK:-
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.app = UIApplication.shared.delegate as! AppDelegate
        
        self.tblMenuOptions.tableFooterView = UIView()
        self.tblMenuOptions.delegate = self
        self.tblMenuOptions.dataSource = self
        self.tblMenuOptions.separatorStyle = .none

        let vv = UIView()
        var height = CGFloat()
        if DeviceType.IS_IPHONE_X
        {
            height = 44
        }
        else
        {
            height = 20
        }
        vv.frame = CGRect(x: 0, y: 0, width: self.tblMenuOptions.frame.size.width, height: height)
        vv.backgroundColor = UIColor.init(rgb: 0xDD0E2C)
        self.view.addSubview(vv)
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        self.updateArrayMenuOptions()
    }
    
    func updateArrayMenuOptions()
    {
        self.arrayMenuOptions.removeAll()
        
        if self.app.strUserType == "S"
        {
            self.arrayMenuOptions.append(["title":"", "icon":""])
            self.arrayMenuOptions.append(["title":"Dashboard", "icon":"home-button.png"])
            self.arrayMenuOptions.append(["title":"Profile", "icon":"userBlack.png"])
            self.arrayMenuOptions.append(["title":"Add Dish", "icon":"restaurant-cutlery-circular-symbol-of-a-spoon-and-a-fork-in-a-circle.png"])
            self.arrayMenuOptions.append(["title":"My Dish List", "icon":"food.png"])
            self.arrayMenuOptions.append(["title":"Order Demand Request", "icon":"OrderDemandRequest.png"])
            self.arrayMenuOptions.append(["title":"Logout", "icon":"logout.png"])
        }
        else
        {
            self.arrayMenuOptions.append(["title":"", "icon":""])
            self.arrayMenuOptions.append(["title":"Home", "icon":"home-button.png"])
            self.arrayMenuOptions.append(["title":"Profile", "icon":"userBlack.png"])
            self.arrayMenuOptions.append(["title":"Order Dish", "icon":"restaurant-cutlery-circular-symbol-of-a-spoon-and-a-fork-in-a-circle.png"])
            self.arrayMenuOptions.append(["title":"My Ordered Dishes", "icon":"food.png"])
            self.arrayMenuOptions.append(["title":"Logout", "icon":"logout.png"])
        }
        
        self.tblMenuOptions.reloadData()
    }
    
    @IBAction func onCloseMenuClick(_ button:UIButton!)
    {
        self.btnMenu.tag = 0
        
        if (self.delegate != nil)
        {
            var index = Int32(button.tag)
            if(button == self.btnCloseMenuOverlay)
            {
                index = -1
            }
            delegate?.slideMenuItemSelectedAtIndex(index)
        }
        
        UIView.animate(withDuration: 0.3, animations: { () -> Void in
            self.view.frame = CGRect(x: -UIScreen.main.bounds.size.width, y: 0, width: UIScreen.main.bounds.size.width,height: UIScreen.main.bounds.size.height)
            self.view.layoutIfNeeded()
            self.view.backgroundColor = UIColor.clear
        }, completion: { (finished) -> Void in
            self.view.removeFromSuperview()
            self.removeFromParent()
        })
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
                cell.lblName.text = self.app.strName
                
                var strFullImage = String()
                if self.app.strUserType == "B"
                {
                    strFullImage = "\(self.app.ImageURL)buyer_img/\(self.app.strProfile)"
                }
                else
                {
                    strFullImage = "\(self.app.ImageURL)seller_img/\(self.app.strProfile)"
                }
                
                cell.imgProfile.sd_setImage(with: URL(string: strFullImage), placeholderImage: UIImage(named: "user-web.png"))
                cell.imgProfile.layer.cornerRadius = cell.imgProfile.frame.size.height / 2
                cell.imgProfile.clipsToBounds = true
            }
            else
            {
                cell = Bundle.main.loadNibNamed("SideMenuCell", owner: self, options: nil)?[1] as! SideMenuCell
                cell.lblName.text = arrayMenuOptions[indexPath.row]["title"]!
                
                let img = UIImage(named: arrayMenuOptions[indexPath.row]["icon"]!)
                cell.imgProfile.image =  img?.maskWithColor(color: UIColor.darkGray)
                cell.imgProfile.clipsToBounds = true
            }
        }
        
        cell.selectionStyle = .none

        self.tblMenuOptions.rowHeight = cell.frame.size.height
        return cell
    }
    
    func buttonAction(sender: UIButton!)
    {

    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if indexPath.row != 0
        {
            let btn = UIButton(type: UIButton.ButtonType.custom)
            btn.tag = indexPath.row
            self.onCloseMenuClick(btn)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return arrayMenuOptions.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
}
