//
//  SideMenuCell.swift
//  DrawarMenu
//
//  Created by Developer on 23/11/16.
//  Copyright © 2016 Developer. All rights reserved.
//

import UIKit

class SideMenuCell: UITableViewCell {

    // MARK: - Outlet
    @IBOutlet var imgProfile: UIImageView!

    @IBOutlet var lblName: UILabel!

    @IBOutlet var imgSidebaar: UIImageView!
    @IBOutlet var viewLine: UIView!

    @IBOutlet var btnMail: UIButton!
    @IBOutlet var btnSMS: UIButton!
    @IBOutlet var btnUser: UIButton!
    @IBOutlet var btnCall: UIButton!
    @IBOutlet var btnTwitter: UIButton!
    @IBOutlet var btnFB: UIButton!

    // MARK: -

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
