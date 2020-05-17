//
//  OprationlogCell.swift
//  Yakrm
//
//  Created by Krutik V. Poojara on 17/12/18.
//  Copyright © 2018 Krutik V. Poojara. All rights reserved.
//

import UIKit

class OprationlogCell: UITableViewCell {

    @IBOutlet var viewLine: UIView!
    @IBOutlet var lblName: UILabel!
    @IBOutlet var lblDetails: UILabel!

    @IBOutlet var lblDate: UILabel!
    @IBOutlet var lblPrice: UILabel!
    @IBOutlet var lblType: UILabel!

    @IBOutlet var lblVoucherType: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
