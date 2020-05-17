//
//  PaymentConfirmation.swift
//  Yakrm
//
//  Created by Gaurav Parmar on 17/05/20.
//  Copyright © 2020 Krutik V. Poojara. All rights reserved.
//

import UIKit

protocol PaymentDelegate: class {
    func didPayTapped(_ viewController: PaymentConfirmation)
    func didCancelTapped(_ viewController: PaymentConfirmation)
}

class PaymentConfirmation: UIViewController {

    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var btnPay: UIButton!

    weak var delegate: PaymentDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction private func btnCancelTapped(_ sender: UIButton) {
        self.delegate?.didCancelTapped(self)
    }

    @IBAction private func btnPayTapped(_ sender: UIButton) {
        self.delegate?.didPayTapped(self)
    }
}
