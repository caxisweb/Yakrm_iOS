//
//  ItemCell.swift
//  Yakrm
//
//  Created by Gaurav Parmar on 12/05/20.
//  Copyright © 2020 Krutik V. Poojara. All rights reserved.
//

import UIKit

class ItemCell: UITableViewCell {

    // MARK: - IBOutlet
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblQty: UILabel!
    @IBOutlet weak var btnDelete: UIButton!

    var deleteCallBack: ((IndexPath) -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func setData(_ data: [String: String]) {
        self.lblName.text = data["product_title"]
        self.lblQty.text = data["quantity"]
    }

    func setData(_ data: OrderDetail) {
        self.lblName.text = data.productTitle ?? ""
        self.lblQty.text = data.quantity ?? ""
    }
    @IBAction private func btnDeleteTapped(_ sender: UIButton) {

    }

}
