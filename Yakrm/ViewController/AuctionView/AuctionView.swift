//
//  AuctionView.swift
//  Yakrm
//
//  Created by Krutik V. Poojara on 17/12/18.
//  Copyright © 2018 Krutik V. Poojara. All rights reserved.
//

import UIKit

class AuctionView: ViewPagerController,ViewPagerDelegate,ViewPagerDataSource
{
    //MARK:- Outlet
    @IBOutlet var viewNavigation: UIView!
    @IBOutlet var lblTitle: UILabel!
    
    var arrTitle = ["Auctions Of Other".localized,"Auction On My Vouchers".localized]

    var isMyAuction = Bool()
    var app = AppDelegate()
    //MARK:-
    override func viewDidLoad()
    {
        super.viewDidLoad()
        app = UIApplication.shared.delegate as! AppDelegate
//        if self.isMyAuction
//        {
//            self.arrTitle = self.arrTitle.reversed()
//        }
        self.viewNavigation.backgroundColor = UIColor.init(rgb: 0xEE4158)
        if DeviceType.IS_IPHONE_X || DeviceType.IS_IPHONE_XR
        {
            self.viewNavigation.frame = CGRect(x:self.viewNavigation.frame.origin.x, y: self.viewNavigation.frame.origin.y, width:self.viewNavigation.frame.size.width, height: 88)
        }
        //ViewPager
        
        indicatorColor = UIColor.white
        tabsViewBackgroundColor = UIColor.init(rgb: 0xEE4158)
        contentViewBackgroundColor = UIColor.clear
        dividerColor = UIColor.white
        startFromSecondTab = false
        centerCurrentTab = true
        tabLocation = ViewPagerTabLocation.top
        tabHeight = 49
        fixFormerTabsPositions = false
        fixLatterTabsPositions = false
        shouldShowDivider = true
        
        shouldAnimateIndicator = ViewPagerIndicator.animationWhileScrolling

        self.dataSource = self
        self.delegate = self
        self.reloadData()
        
        self.viewNavigation.dropShadow(color: .lightGray, opacity: 1, offSet: CGSize(width: 0, height: 1), radius: 1, scale: true)
        if self.app.isEnglish
        {
            self.lblTitle.textAlignment = .left
        }
        else
        {
            self.lblTitle.textAlignment = .right
        }
    }
    
    @IBAction func btnBack(_ sender: UIButton)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK:- View Pager Delegate Datasource
    func numberOfTabs(forViewPager viewPager: ViewPagerController!) -> UInt
    {
        return UInt(self.arrTitle.count)
    }
    
    func viewPager(_ viewPager: ViewPagerController!, viewForTabAt index: UInt) -> UIView!
    {
        let label = UILabel()
        
        let strTitle : String = self.arrTitle[Int(index)]
        
        label.backgroundColor = UIColor.clear
        
        var fontSize : CGFloat = 13
        if DeviceType.IS_IPHONE_5
        {
            fontSize = 12
        }
        else if DeviceType.IS_IPHONE_6P || DeviceType.IS_IPHONE_XR
        {
            fontSize = 14
        }
        label.font = UIFont.systemFont(ofSize: fontSize, weight: .medium)//UIFont(name: "GE SS Two Medium", size: 6)

        label.textColor = UIColor.white
        
        label.text = strTitle//.uppercased()
        label.textAlignment = .center
        label.tag = Int(index)
        
        label.sizeToFit()
        
//        let stringsize: CGSize = strTitle.size(withAttributes: [NSAttributedString.Key.font : label.font])
        
        self.tabWidth = ScreenSize.SCREEN_WIDTH / 2//stringsize.width + 30
        
//        let width = ScreenSize.SCREEN_WIDTH / 2
//
//        let img = UIImageView()
//        label.frame = CGRect(x:0, y: 25, width:width, height: 19)
//        img.frame = CGRect(x:(width - 40) / 2, y: 5, width:20, height: 20)
//        img.image = UIImage(named: "wallet.png")!
//
//        let vv = UIView()
//        vv.backgroundColor = UIColor.clear
//        vv.frame = CGRect(x:0, y: 0, width:width, height: 49)
//
//        vv.addSubview(label)
//        vv.addSubview(img)
        
        
        return label
    }
    
    func viewPager(_ viewPager: ViewPagerController!, contentViewControllerForTabAt index: UInt) -> UIViewController!
    {
        if self.isMyAuction
        {
            if index == 0
            {
                let VC = self.storyboard?.instantiateViewController(withIdentifier: "MyAuctionView") as! MyAuctionView
                return VC
            }
            else
            {
                let VC = self.storyboard?.instantiateViewController(withIdentifier: "OtherAuctionView") as! OtherAuctionView
                return VC
            }
        }
        else
        {
            if index == 0
            {
                let VC = self.storyboard?.instantiateViewController(withIdentifier: "OtherAuctionView") as! OtherAuctionView
                return VC
            }
            else
            {
                let VC = self.storyboard?.instantiateViewController(withIdentifier: "MyAuctionView") as! MyAuctionView
                return VC
            }
        }
    }
    
//    func viewPager(_ viewPager: ViewPagerController!, didChangeTabTo index: UInt)
//    {
//        for viewAll: UIView in viewPager.view.subviews
//        {
//            if (viewAll is UIScrollView)
//            {
//                let scrollAll: UIScrollView? = (viewAll as? UIScrollView)
//                for viewScroll: UIView in (scrollAll?.subviews)!
//                {
//                    for viewTab: UIView in viewScroll.subviews
//                    {
//                        let lblSelected: UILabel? = (viewTab as? UILabel)
//                        lblSelected?.textAlignment = .center
//
//                        if lblSelected?.tag == Int(index)
//                        {
//                            lblSelected?.textColor = UIColor(rgb: 0x07ac3e)
//                        }
//                        else
//                        {
//                            lblSelected?.textColor = UIColor.darkGray
//                        }
//                    }
//                }
//            }
//        }
//    }

}
