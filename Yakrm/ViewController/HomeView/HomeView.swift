//
//  HomeView.swift
//  Yakrm
//
//  Created by Krutik V. Poojara on 07/12/18.
//  Copyright © 2018 Krutik V. Poojara. All rights reserved.
//

import UIKit
import DLRadioButton

class HomeView: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UITextFieldDelegate
{
    //MARK:- Outlet

    @IBOutlet var viewNavigation: UIView!
    @IBOutlet var clTopView: UICollectionView!
    
    @IBOutlet var viewTop: UIView!
    @IBOutlet var lblMost: UILabel!
    @IBOutlet var clView: UICollectionView!
    
    @IBOutlet var btnFilter: UIButton!
    
    @IBOutlet var viewPopup: UIView!
    @IBOutlet var viewResearch: UIView!
    @IBOutlet var txtSearch: UITextField!
    @IBOutlet var viewSearch: UIView!
    
    @IBOutlet var viewFilter: UIView!
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var clFilterView: UICollectionView!
    
    @IBOutlet var viewDetails: UIView!
    
    @IBOutlet var btnElectronic: UIButton!
    @IBOutlet var btnPaper: UIButton!
    
    @IBOutlet var btnPopular: DLRadioButton!
    @IBOutlet var btnDiscounted: DLRadioButton!
    @IBOutlet var btnBrand: DLRadioButton!
    
    @IBOutlet var btnFilterAction: UIButton!
    @IBOutlet var btnCloseAction: UIButton!

    
    @IBOutlet var lblGIFTCLASSIFICATION: UILabel!
    @IBOutlet var lblGIFTTYPE: UILabel!
    @IBOutlet var lblELECTRONIC: UILabel!
    @IBOutlet var lblPAPER: UILabel!
    @IBOutlet var lblGIFTOLDER: UILabel!
    
    
    var cellTop = TopCell()
    var cell = HomeCell()
    var cellFilter = FilterCell()

    var IndexTop : Int = 0
    
    var arrTop = ["Buy".localized,
                  "Received".localized,
                  "Replace".localized,
                  "Auction".localized,
                  "My Wallet".localized]
    var arrBrands = ["Cuisine".localized,
                     "Books and Magazines".localized,
                     "Coffee".localized,
                     "Stores and  groceries".localized,
                     "Children Toys".localized,
                     "Fashion and Uniforms".localized,
                     "Care and makeup centers".localized,
                     "Hotels and Tourism".localized,
                     "Sport Clothes".localized,
                     "Phones and Electronics".localized,
                     "Sport Tools".localized,
                     "Clothes".localized,
                     "Jewelries and Golden".localized,
                     "Others".localized]
    var arrImage : [UIImage] = []
    var arrSelected : [String] = []
    
    var layout = FlowLayout()

    var Filter = Bool()
    var checkElectronic = Bool()
    var checkPepar = Bool()
    
    var strGiftOrder = String()
    
    var app = AppDelegate()
    
    var empty = Bool()
    var strCategoryID = String()
    
    var img = UIImage()

    //MARK:-
    override func viewDidLoad()
    {
        super.viewDidLoad()
        app = UIApplication.shared.delegate as! AppDelegate

        self.viewNavigation.backgroundColor = UIColor.init(rgb: 0xEE4158)

        if self.app.defaults.string(forKey: "selectedLanguagebool") != nil
        {
            self.app.isEnglish = (self.app.defaults.value(forKey: "selectedLanguagebool") as! Bool)
        }
        
        sideMenuController?.isRightViewSwipeGestureEnabled = false
        sideMenuController?.isLeftViewSwipeGestureEnabled = false
        sideMenuController?.leftViewWidth = self.view.frame.size.width - 60

        var statusBarHeight : CGFloat = 20
        if DeviceType.IS_IPHONE_X || DeviceType.IS_IPHONE_XR
        {
            self.viewNavigation.frame = CGRect(x:self.viewNavigation.frame.origin.x, y: self.viewNavigation.frame.origin.y, width:self.viewNavigation.frame.size.width, height: 88)
            self.clTopView.frame = CGRect(x:self.clTopView.frame.origin.x, y: self.viewNavigation.frame.origin.y + self.viewNavigation.frame.size.height, width:self.clTopView.frame.size.width, height: self.clTopView.frame.size.height)
            self.viewTop.frame = CGRect(x:self.viewTop.frame.origin.x, y: self.clTopView.frame.origin.y + self.clTopView.frame.size.height, width:self.viewTop.frame.size.width, height: self.viewTop.frame.size.height)
            self.clView.frame = CGRect(x:self.clView.frame.origin.x, y: self.viewTop.frame.origin.y + self.viewTop.frame.size.height + 5, width:self.clView.frame.size.width, height: ScreenSize.SCREEN_HEIGHT - self.viewTop.frame.origin.y - self.viewTop.frame.size.height - 5)
            statusBarHeight = 44
        }
        self.scrollView.frame = CGRect(x:self.scrollView.frame.origin.x, y: statusBarHeight, width:self.scrollView.frame.size.width, height: ScreenSize.SCREEN_HEIGHT - statusBarHeight)

        if DeviceType.IS_IPHONE_5
        {
            self.lblMost.font = self.lblMost.font.withSize(self.lblMost.font.pointSize-1)
            self.btnFilter.titleLabel!.font = self.btnFilter.titleLabel!.font.withSize(self.btnFilter.titleLabel!.font.pointSize-1)
            
            self.lblGIFTCLASSIFICATION.font = self.lblGIFTCLASSIFICATION.font.withSize(self.lblGIFTCLASSIFICATION.font.pointSize-1)
            self.lblGIFTTYPE.font = self.lblGIFTTYPE.font.withSize(self.lblGIFTTYPE.font.pointSize-1)
            self.lblELECTRONIC.font = self.lblELECTRONIC.font.withSize(self.lblELECTRONIC.font.pointSize-1)
            self.lblPAPER.font = self.lblPAPER.font.withSize(self.lblPAPER.font.pointSize-1)
            self.lblGIFTOLDER.font = self.lblGIFTOLDER.font.withSize(self.lblGIFTOLDER.font.pointSize-1)

            self.btnPopular.titleLabel!.font = self.btnPopular.titleLabel!.font.withSize(self.btnPopular.titleLabel!.font.pointSize-1)
            self.btnDiscounted.titleLabel!.font = self.btnDiscounted.titleLabel!.font.withSize(self.btnDiscounted.titleLabel!.font.pointSize-1)
            self.btnBrand.titleLabel!.font = self.btnBrand.titleLabel!.font.withSize(self.btnBrand.titleLabel!.font.pointSize-1)
            
            self.txtSearch.font = self.txtSearch.font!.withSize(self.txtSearch.font!.pointSize-2)
        }
        
        self.arrImage.append(UIImage(named: "ic_offer_icon.png")!)
        self.arrImage.append(UIImage(named: "gift-box.png")!)
        self.arrImage.append(UIImage(named: "ic_dolor (1).png")!)
        self.arrImage.append(UIImage(named: "auction.png")!)
        self.arrImage.append(UIImage(named: "wallet.png")!)

        self.clTopView.register(UINib(nibName: "TopCell", bundle: nil), forCellWithReuseIdentifier: "TopCell")
        self.clTopView.delegate = self
        self.clTopView.dataSource = self

        self.clView.register(UINib(nibName: "HomeCell", bundle: nil), forCellWithReuseIdentifier: "HomeCell")
        self.clView.delegate = self
        self.clView.dataSource = self
    
        clFilterView.register(UINib(nibName: "FilterCell", bundle: nil), forCellWithReuseIdentifier: "FilterCell")
        clFilterView.delegate = self
        clFilterView.dataSource = self
        clFilterView.reloadData()
        
        if self.app.isEnglish
        {
            self.layout.alignment = FlowAlignment.left
            
            self.lblGIFTCLASSIFICATION.textAlignment = .left
            
            self.lblGIFTTYPE.textAlignment = .left
            self.lblELECTRONIC.textAlignment = .left
            self.lblPAPER.textAlignment = .left
            
            self.lblGIFTOLDER.textAlignment = .left
            self.btnPopular.contentHorizontalAlignment = .left
            self.btnDiscounted.contentHorizontalAlignment = .left
            self.btnBrand.contentHorizontalAlignment = .left
            
            self.btnElectronic.frame.origin.x = 15
            self.btnPaper.frame.origin.x = 15
            
            self.btnPopular.semanticContentAttribute = .forceLeftToRight
            self.btnDiscounted.semanticContentAttribute = .forceLeftToRight
            self.btnBrand.semanticContentAttribute = .forceLeftToRight
        }
        else
        {
            self.layout.alignment = FlowAlignment.right
            
            self.lblGIFTCLASSIFICATION.textAlignment = .right
            
            self.lblGIFTTYPE.textAlignment = .right
            self.lblELECTRONIC.textAlignment = .right
            self.lblPAPER.textAlignment = .right
            
            self.lblGIFTOLDER.textAlignment = .right
            self.btnPopular.contentHorizontalAlignment = .right
            self.btnDiscounted.contentHorizontalAlignment = .right
            self.btnBrand.contentHorizontalAlignment = .right
            
            self.btnElectronic.frame.origin.x = self.lblELECTRONIC.frame.origin.x + self.lblELECTRONIC.frame.size.width + 5
            self.btnPaper.frame.origin.x = self.lblPAPER.frame.origin.x + self.lblPAPER.frame.size.width + 5
            
            self.btnPopular.semanticContentAttribute = .forceRightToLeft
            self.btnDiscounted.semanticContentAttribute = .forceRightToLeft
            self.btnBrand.semanticContentAttribute = .forceRightToLeft
        }

        let edges = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        self.layout.sectionInset = edges
        self.clFilterView.collectionViewLayout = self.layout

        let lastIndexPath = IndexPath(item: self.arrBrands.count-1, section: 0);
        self.clFilterView.scrollToItem(at: lastIndexPath, at: .bottom, animated: true);

        self.clTopView.backgroundColor = UIColor.init(rgb: 0xEE4158)
        self.clTopView.dropShadow(color: .darkGray, opacity: 1, offSet: CGSize(width: 0, height: 1), radius: 3, scale: true)
        
        self.btnFilter.setTitleColor(UIColor.init(rgb: 0xEE4158), for: .normal)
        
        self.viewPopup.isHidden = true
        self.viewPopup.frame.origin.y = 0
        self.viewResearch.center = self.view.center

        self.viewFilter.frame.origin.x = -ScreenSize.SCREEN_WIDTH
        self.viewFilter.frame.origin.y = 0

        self.setTextfildDesign(txt: self.txtSearch, vv: self.viewSearch)
        
        self.btnFilterAction.layer.cornerRadius = 5
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        self.IndexTop = 0
        self.clTopView.reloadData()
    }
    
    @IBAction func btnMenu(_ sender: UIButton)
    {
        sideMenuController?.showLeftViewAnimated()
    }
    
    func HideShowFilter()
    {
        self.clFilterView.frame = CGRect(x:self.clFilterView.frame.origin.x, y:self.clFilterView.frame.origin.y, width:self.clFilterView.frame.size.width, height:self.clFilterView.contentSize.height)
        self.viewDetails.frame = CGRect(x:self.viewDetails.frame.origin.x, y:self.clFilterView.frame.origin.y + self.clFilterView.frame.size.height + 10, width:self.viewDetails.frame.size.width, height:self.viewDetails.frame.size.height)
        self.setScrollViewHeight()
        
        var X = CGFloat()
        if self.Filter
        {
            X = -ScreenSize.SCREEN_WIDTH
            self.Filter = false
            self.btnCloseAction.alpha = 1.0
        }
        else
        {
            X = 0
            self.Filter = true
            
            self.arrSelected.removeAll()
            self.clFilterView.reloadData()
            
            self.img = UIImage(named: "checkboxempty.png")!
            self.img = self.img.maskWithColor(color: UIColor.darkGray)
            self.btnElectronic.setImage(self.img, for: .normal)
            self.btnPaper.setImage(self.img, for: .normal)

            self.btnPopular.isSelected = false
            self.btnDiscounted.isSelected = false
            self.btnBrand.isSelected = false
            
            self.radioButtonSetDesign(btn: self.btnPopular)
            self.radioButtonSetDesign(btn: self.btnDiscounted)
            self.radioButtonSetDesign(btn: self.btnBrand)
            
            self.btnCloseAction.alpha = 0
        }
        UIView.animate(withDuration: 0.4)
        {
            self.viewFilter.frame = CGRect(x:X, y:self.viewFilter.frame.origin.y, width:self.viewFilter.frame.size.width, height:self.viewFilter.frame.size.height)
            if self.Filter
            {
                self.btnCloseAction.alpha = 1.0
            }
            else
            {
                self.btnCloseAction.alpha = 0
            }
        }
    }
    
    func setScrollViewHeight()
    {
        for viewAll: UIView in scrollView.subviews
        {
            if viewAll.tag == 100
            {
                scrollView.contentSize = CGSize(width: CGFloat(scrollView.frame.size.width), height: CGFloat(viewAll.frame.origin.y + viewAll.frame.size.height))
            }
        }
    }
    
    func setTextfildDesign(txt : UITextField, vv : UIView)
    {
        txt.delegate = self
        txt.placeHolderColor = UIColor.darkGray
        txt.layer.borderWidth = 1
        txt.layer.borderColor = UIColor.darkGray.withAlphaComponent(0.5).cgColor
        let VV = UIView()
        VV.backgroundColor = UIColor.clear
        VV.frame = CGRect(x:0, y: 0, width:10, height: txt.frame.size.height)

        if self.app.isEnglish
        {
            if self.app.isLangEnglish
            {
                txt.setRightPaddingPoints(vv)
                txt.setLeftPaddingPoints(VV)
            }
            else
            {
                txt.setLeftPaddingPoints(vv)
                txt.setRightPaddingPoints(VV)
            }
            txt.textAlignment = .left
        }
        else
        {
            if self.app.isLangEnglish
            {
                txt.setLeftPaddingPoints(vv)
                txt.setRightPaddingPoints(VV)
            }
            else
            {
                txt.setRightPaddingPoints(vv)
                txt.setLeftPaddingPoints(VV)
            }
            txt.textAlignment = .right
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField .resignFirstResponder()
        return true
    }
    
    //MARK:- Collection view methods
    func numberOfSections(in collectionView: UICollectionView) -> Int
    {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        if collectionView == self.clTopView
        {
            return self.arrTop.count
        }
        else if collectionView == clFilterView
        {
            return self.arrBrands.count
        }
        else
        {
            return 20
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        if collectionView == self.clTopView
        {
            cellTop = collectionView.dequeueReusableCell(withReuseIdentifier: "TopCell", for: indexPath) as! TopCell
            
            cellTop.lblName.text = self.arrTop[indexPath.row]
            cellTop.imgProfile.image = self.arrImage[indexPath.row]
            
            if self.IndexTop == indexPath.row
            {
                cellTop.viewLine.isHidden = false
            }
            else
            {
                cellTop.viewLine.isHidden = true
            }
            
            if DeviceType.IS_IPHONE_5
            {
                cellTop.lblName.font = cellTop.lblName.font.withSize(10)
            }
            
            return cellTop
        }
        else if collectionView == clFilterView
        {
            cellFilter = collectionView.dequeueReusableCell(withReuseIdentifier: "FilterCell", for: indexPath) as! FilterCell
            
            cellFilter.lblName.text = self.arrBrands[indexPath.row].uppercased()

            cellFilter.lblName.layer.cornerRadius = cellFilter.lblName.frame.size.height / 2
            cellFilter.lblName.clipsToBounds = true
            cellFilter.lblName.backgroundColor = UIColor.init(rgb: 0xE1E1E1)
            
            if DeviceType.IS_IPHONE_5
            {
                cellFilter.lblName.font = cellFilter.lblName.font.withSize(10)
            }
            self.strCategoryID = "\(indexPath.row)"
            var textColor : UIColor = UIColor.black
            if self.arrSelected.contains(self.strCategoryID)
            {
                cellFilter.lblName.backgroundColor = UIColor.init(rgb: 0xEE4158)
                textColor = UIColor.white
            }
            cellFilter.lblName.textColor = textColor
            
            return cellFilter
        }
        else
        {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCell", for: indexPath) as! HomeCell
            
            var img = UIImage()
            if indexPath.row % 2 == 0
            {
                img = UIImage(named: "Screenshot 2018-12-11 at 3.53.07 PM.png")!
            }
            else
            {
                img = UIImage(named: "Screenshot 2018-12-11 at 3.53.18 PM.png")!
            }
            cell.imgProfile.image = img
            
            if self.app.isEnglish
            {
                let width = (collectionView.frame.size.width/2) - 8
                cell.lblName.textAlignment = .left
                cell.lblDiscount.textAlignment = .left
                cell.imgLogo.frame.origin.x = width - cell.imgLogo.frame.size.width - 10
            }
            else
            {
                cell.lblName.textAlignment = .right
                cell.lblDiscount.textAlignment = .right
                cell.imgLogo.frame.origin.x = 10
            }
            
            if DeviceType.IS_IPHONE_5
            {
                cell.lblName.font = cell.lblName.font.withSize(11)
                cell.lblDiscount.font = cell.lblDiscount.font.withSize(11)
            }
            let strDISCOUNT = "Discount".localized
            let strAttDiscount = NSMutableAttributedString(string: "\(strDISCOUNT) \(indexPath.row + 1)%")
            strAttDiscount.setColorForText("\(indexPath.row + 1)%", with: UIColor.init(rgb: 0xEE4158))
            cell.lblDiscount.attributedText = strAttDiscount
            cell.dropShadow(color: .lightGray, opacity: 1, offSet: CGSize(width: 0, height: 1), radius: 1, scale: true)

            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        if collectionView == self.clTopView
        {
            self.IndexTop = indexPath.row
            self.clTopView.reloadData()
            if indexPath.row == 1
            {
                let VC = self.storyboard?.instantiateViewController(withIdentifier: "ReceivedView") as! ReceivedView
                self.navigationController?.pushViewController(VC, animated: true)
            }
            else if indexPath.row == 2
            {
                let VC = self.storyboard?.instantiateViewController(withIdentifier: "ActiveVoucherView") as! ActiveVoucherView
                self.navigationController?.pushViewController(VC, animated: true)
            }
            else if indexPath.row == 3
            {
                let VC = self.storyboard?.instantiateViewController(withIdentifier: "AuctionView") as! AuctionView
                self.navigationController?.pushViewController(VC, animated: true)
            }
            else if indexPath.row == 4
            {
                let VC = self.storyboard?.instantiateViewController(withIdentifier: "WalletView") as! WalletView
                self.navigationController?.pushViewController(VC, animated: true)
            }
//            else
//            {
//                let VC = self.storyboard?.instantiateViewController(withIdentifier: "CouponView") as! CouponView
//                self.navigationController?.pushViewController(VC, animated: true)
//            }
        }
        else if collectionView == self.clFilterView
        {
            self.strCategoryID = "\(indexPath.row)"
            if self.arrSelected.contains(self.strCategoryID)
            {
                let indexOfA = self.arrSelected.index(of: self.strCategoryID)
                self.arrSelected.remove(at: indexOfA!)
            }
            else
            {
                self.arrSelected.append(self.strCategoryID)
            }
            self.clFilterView.reloadData()
        }
        else if collectionView == self.clView
        {
            let VC = self.storyboard?.instantiateViewController(withIdentifier: "DetailsView") as! DetailsView
            self.navigationController?.pushViewController(VC, animated: true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        if collectionView == self.clTopView
        {
            return CGSize(width: (collectionView.frame.size.width/5), height: 60)
        }
        else if collectionView == clFilterView
        {
            let strCity : String = self.arrBrands[indexPath.row].uppercased()
            var size : CGFloat = 11
            if DeviceType.IS_IPHONE_5
            {
                size = 10
            }
            let stringsize: CGSize = strCity.size(withAttributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: size, weight: .medium)])
            
            var final = CGFloat()
            final = stringsize.width + 25
            
            return CGSize(width: final, height: 35)
        }
        else
        {
            return CGSize(width: (collectionView.frame.size.width/2) - 8, height: 142)
        }
    }
  
    @IBAction func btnCancel(_ sender: UIButton)
    {
        if sender.tag == 1
        {
            self.HideShowFilter()
        }
        else
        {
            self.txtSearch.resignFirstResponder()
            self.viewPopup.isHidden = true
        }
    }
    
    @IBAction func btnResearch(_ sender: UIButton)
    {

    }
    
    @IBAction func btnAllAction(_ sender: UIButton)
    {
        if sender.tag == 1
        {
            ProjectUtility.animatePopupView(viewPopup: self.viewPopup, viewDetails: self.viewResearch)
        }
        else if sender.tag == 2
        {
            let VC = self.storyboard?.instantiateViewController(withIdentifier: "FavoritesView") as! FavoritesView
            self.navigationController?.pushViewController(VC, animated: true)
        }
        else if sender.tag == 3
        {
            let VC = self.storyboard?.instantiateViewController(withIdentifier: "AlarmsView") as! AlarmsView
            self.navigationController?.pushViewController(VC, animated: true)
        }
        else if sender.tag == 4
        {
            if self.empty
            {
                self.empty = false
            }
            else
            {
                self.empty = true
            }
            let VC = self.storyboard?.instantiateViewController(withIdentifier: "CartView") as! CartView
            VC.empty = self.empty
            self.navigationController?.pushViewController(VC, animated: true)
        }
        else if sender.tag == 5
        {
            if self.app.strUserID.isEmpty
            {
                let VC = self.storyboard?.instantiateViewController(withIdentifier: "ViewController") as! ViewController
                self.navigationController?.pushViewController(VC, animated: true)
            }
            else
            {
                let VC = self.storyboard?.instantiateViewController(withIdentifier: "PersonalView") as! PersonalView
                self.navigationController?.pushViewController(VC, animated: true)
            }
        }
    }
    
    @IBAction func btnGiftTypeAction(_ sender: UIButton)
    {
        if sender.tag == 1
        {
            if self.checkElectronic
            {
                self.checkElectronic = false
                self.img = UIImage(named: "checkboxempty.png")!
                self.img = self.img.maskWithColor(color: UIColor.darkGray)
            }
            else
            {
                self.checkElectronic = true
                self.img = UIImage(named: "checkboxselected.png")!
                self.img = img.maskWithColor(color: UIColor.init(rgb: 0x3C99C0))
            }
        }
        else
        {
            if self.checkPepar
            {
                self.checkPepar = false
                self.img = UIImage(named: "checkboxempty.png")!
                self.img = self.img.maskWithColor(color: UIColor.darkGray)
            }
            else
            {
                self.checkPepar = true
                self.img = UIImage(named: "checkboxselected.png")!
                self.img = img.maskWithColor(color: UIColor.init(rgb: 0x3C99C0))
            }
        }
        sender.setImage(img, for: .normal)
    }
    
    @IBAction func btnOrderAction(_ sender: UIButton)
    {
        self.btnPopular.isSelected = false
        self.btnDiscounted.isSelected = false
        self.btnBrand.isSelected = false

        if sender.tag == 1
        {
            self.strGiftOrder = "Popular"
        }
        else if sender.tag == 2
        {
            self.strGiftOrder = "Discounted"
        }
        else
        {
            self.strGiftOrder = "Brand"
        }
        
        sender.isSelected = true
        
        self.radioButtonSetDesign(btn: self.btnPopular)
        self.radioButtonSetDesign(btn: self.btnDiscounted)
        self.radioButtonSetDesign(btn: self.btnBrand)
    }
    
    @IBAction func btnOpenFilterAction(_ sender: UIButton)
    {
        self.HideShowFilter()
    }

    func radioButtonSetDesign(btn : DLRadioButton)
    {
        if btn.isSelected
        {
            btn.iconColor = UIColor.init(rgb: 0x3C99C0)
            btn.indicatorColor = UIColor.init(rgb: 0x3C99C0)
        }
        else
        {
            btn.iconColor = UIColor.darkGray
            btn.indicatorColor = UIColor.darkGray
        }
    }
    
    
    @IBAction func btnFilterActionDone(_ sender: UIButton)
    {
        
    }
    
}
