//
//  SearchView.swift
//  Yakrm
//
//  Created by Apple on 14/05/19.
//  Copyright © 2019 Krutik V. Poojara. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import MBProgressHUD
import Toaster

@available(iOS 11.0, *)
class SearchView: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet var viewNavigation: UIView!
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var clView: UICollectionView!

    var cell = HomeCell()

    var arrHome: [Any] = []

    var json: JSON!
    var strMessage: String!

    var app = AppDelegate()

    override func viewDidLoad() {
        super.viewDidLoad()
        app = UIApplication.shared.delegate as! AppDelegate

        if DeviceType.IS_IPHONE_X || DeviceType.IS_IPHONE_XR {
            self.viewNavigation.frame = CGRect(x: self.viewNavigation.frame.origin.x, y: self.viewNavigation.frame.origin.y, width: self.viewNavigation.frame.size.width, height: 88)
            self.clView.frame = CGRect(x: self.clView.frame.origin.x, y: self.viewNavigation.frame.origin.y + self.viewNavigation.frame.size.height + 15, width: self.clView.frame.size.width, height: ScreenSize.SCREEN_HEIGHT - self.viewNavigation.frame.origin.y - self.viewNavigation.frame.size.height - 15)
        }

        self.viewNavigation.backgroundColor = UIColor.init(rgb: 0xEE4158)

        self.clView.register(UINib(nibName: "HomeCell", bundle: nil), forCellWithReuseIdentifier: "HomeCell")
        self.clView.delegate = self
        self.clView.dataSource = self

        if self.app.isEnglish {
            self.lblTitle.textAlignment = .left
        } else {
            self.lblTitle.textAlignment = .right
//            self.lblTitle.text = "نتائج البحث"
        }
        self.lblTitle.text = "Search".localized

    }

    @IBAction func btnBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }

    // MARK: - Collection view methods
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.arrHome.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCell", for: indexPath) as! HomeCell

        var arrValue = JSON(self.arrHome)

        let strName: String = arrValue[indexPath.row]["brand_name"].stringValue
        let strDiscount: String = arrValue[indexPath.row]["discount"].stringValue
        var strImage: String = arrValue[indexPath.row]["brand_image"].stringValue
        strImage = strImage.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!

        cell.lblName.text = strName.uppercased()

        cell.imgProfile.sd_setImage(with: URL(string: "\(self.app.ImageURL)brand_images/\(strImage)"), placeholderImage: nil)

        if self.app.isEnglish {
            let width = (collectionView.frame.size.width/2) - 8
            cell.lblName.textAlignment = .left
            cell.lblDiscount.textAlignment = .left
            cell.imgLogo.frame.origin.x = width - cell.imgLogo.frame.size.width - 10
        } else {
            cell.lblName.textAlignment = .right
            cell.lblDiscount.textAlignment = .right
            cell.imgLogo.frame.origin.x = 10
        }

        if DeviceType.IS_IPHONE_5 {
            cell.lblName.font = cell.lblName.font.withSize(11)
            cell.lblDiscount.font = cell.lblDiscount.font.withSize(11)
        }
        let strDISCOUNT = "Discount".localized
        let strAttDiscount = NSMutableAttributedString(string: "\(strDISCOUNT) \(strDiscount)%")
        strAttDiscount.setColorForText("\(strDiscount)%", with: UIColor.init(rgb: 0xEE4158))
        cell.lblDiscount.attributedText = strAttDiscount
        cell.dropShadow(color: .lightGray, opacity: 1, offSet: CGSize(width: 0, height: 1), radius: 1, scale: true)

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var arrValue = JSON(self.arrHome)

        let VC = self.storyboard?.instantiateViewController(withIdentifier: "DetailsView") as! DetailsView
        VC.strBranchID = arrValue[indexPath.row]["brand_id"].stringValue
        self.navigationController?.pushViewController(VC, animated: true)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.frame.size.width/2) - 8, height: 142)
    }

}
