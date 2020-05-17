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

    @IBOutlet var lblCardName: UILabel!
    @IBOutlet var lblDisc: UILabel!
    var lefBubleConstraint: NSLayoutConstraint!
    var rightBubleConstraint: NSLayoutConstraint!
    var leftMessageLable: NSLayoutConstraint!
    var rightMessageLable: NSLayoutConstraint!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.addSubview(imgProfile)
       // self.addSubview(messageTextView)

        // Permanent constraints
        NSLayoutConstraint.activate(
            [
                self.imgProfile.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10),
                self.imgProfile.heightAnchor.constraint(equalToConstant: 44),
                self.imgProfile.widthAnchor.constraint(equalToConstant: 44)

            ]
        )

        // Buble constraint for configuration
        self.lefBubleConstraint = self.imgProfile.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10)
        self.rightBubleConstraint = self.imgProfile.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10)

        // Message constrait for congiguration
//        self.rightMessageLable = self.lblCardName.rightAnchor.constraint(equalTo: self.imgProfile.leftAnchor, constant: -10)
//        self.leftMessageLable = self.lblCardName.leftAnchor.constraint(equalTo: self.imgProfile.rightAnchor, constant: 10)

        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
