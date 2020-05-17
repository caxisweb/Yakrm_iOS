//
//  OrderCell.swift
//  Yakrm
//
//  Created by Gaurav Parmar on 12/05/20.
//  Copyright © 2020 Krutik V. Poojara. All rights reserved.
//

import UIKit

class OrderCell: UITableViewCell {

    // MARK: - IBOutlet
    @IBOutlet weak var lblOrderID : UILabel!
    @IBOutlet weak var lblProductNumber : UILabel!
    @IBOutlet weak var lblAddress : UILabel!
    @IBOutlet weak var lblStatus : UILabel!
    @IBOutlet weak var viewStatus : UIView!
    @IBOutlet weak var btnViewDetail : UIButton!
    
    var viewDetailTapped: (() -> Void)? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        viewStatus.layer.cornerRadius = viewStatus.frame.size.height / 2
        viewStatus.clipsToBounds = true
        
        btnViewDetail.backgroundColor = .clear
        btnViewDetail.layer.cornerRadius = 5
        btnViewDetail.layer.borderWidth = 1
        if #available(iOS 11.0, *) {
            btnViewDetail.layer.borderColor = UIColor.init(named: "pinkColor")?.cgColor
        } else {
            // Fallback on earlier versions
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction private func btnViewDetail(_ sender : UIButton) {
        self.viewDetailTapped?()
    }
    
    func setData(_ data : Order) {
        self.lblOrderID.text = "Order Id :" + (data.orderId ?? "")
        self.lblProductNumber.text = "Product:" + (data.totalProducts ?? "")
        self.lblAddress.text = data.userAddress ?? ""
        self.lblStatus.text = data.statusString
    }
}
