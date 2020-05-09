//
//  ReceivedCell.swift
//  Yakrm
//
//  Created by Krutik V. Poojara on 15/12/18.
//  Copyright © 2018 Krutik V. Poojara. All rights reserved.
//

import UIKit

class ReceivedCell: UITableViewCell {

    @IBOutlet var lblName: UILabel!
    @IBOutlet var lblDate: UILabel!
    @IBOutlet var lblPrice: UILabel!
    @IBOutlet var lblDiscountedPrice: UILabel!
    @IBOutlet var lblDiscount: UILabel!

    @IBOutlet var lblFriends: UILabel!
    @IBOutlet var lblDetails: UILabel!
    @IBOutlet var lblAttached: UILabel!
    @IBOutlet var btnPress: UIButton!
    @IBOutlet var btnWallet: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
