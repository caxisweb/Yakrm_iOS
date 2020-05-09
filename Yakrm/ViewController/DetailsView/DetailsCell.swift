//
//  DetailsCell.swift
//  Yakrm
//
//  Created by Krutik V. Poojara on 07/12/18.
//  Copyright © 2018 Krutik V. Poojara. All rights reserved.
//

import UIKit

class DetailsCell: UITableViewCell {

    @IBOutlet var imgProfile: UIImageView!
    @IBOutlet var lblValue: UILabel!
    @IBOutlet var lblDiscount: UILabel!
    @IBOutlet var lblPay: UILabel!
    @IBOutlet var btnCart: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
