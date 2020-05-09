//
//  FavoritesCell.swift
//  Yakrm
//
//  Created by Krutik V. Poojara on 10/12/18.
//  Copyright © 2018 Krutik V. Poojara. All rights reserved.
//

import UIKit

class FavoritesCell: UITableViewCell {

    @IBOutlet var lblName: UILabel!
    @IBOutlet var lblDesc: UILabel!
    @IBOutlet var lblDiscount: UILabel!
    @IBOutlet var imgProfile: UIImageView!

    @IBOutlet var lblDate: UILabel!
    @IBOutlet var lblPrice: UILabel!
    @IBOutlet var lblDiscountedPrice: UILabel!
    @IBOutlet var btnDelete: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
