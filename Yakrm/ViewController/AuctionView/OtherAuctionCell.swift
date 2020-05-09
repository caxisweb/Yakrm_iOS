//
//  OtherAuctionCell.swift
//  Yakrm
//
//  Created by Krutik V. Poojara on 17/12/18.
//  Copyright © 2018 Krutik V. Poojara. All rights reserved.
//

import UIKit

class OtherAuctionCell: UITableViewCell {

    @IBOutlet var imgProfile: UIImageView!
    @IBOutlet var lblName: UILabel!
    @IBOutlet var lblDetails: UILabel!

    @IBOutlet var lblLastBid: UILabel!
    @IBOutlet var lblBidDetails: UILabel!

    @IBOutlet var txtQue: UITextField!
    @IBOutlet var viewQue: UIView!

    @IBOutlet var lblTime: UILabel!

    @IBOutlet var lblPrice: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
