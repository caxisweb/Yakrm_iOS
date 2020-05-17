//
//  PaymentCell.swift
//  Yakrm
//
//  Created by Krutik V. Poojara on 15/12/18.
//  Copyright © 2018 Krutik V. Poojara. All rights reserved.
//

import UIKit

class PaymentCell: UITableViewCell
{
    @IBOutlet var imgProfile: UIImageView!
    @IBOutlet var lblName: UILabel!
    @IBOutlet var lblDetails: UILabel!
    @IBOutlet var lblDate: UILabel!
    @IBOutlet var lblPrice: UILabel!
    @IBOutlet weak var imgEdit: UIImageView!
    
    @IBOutlet var btnEdit: UIButton!
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
