//
//  DeliveryDetailVC.swift
//  Yakrm
//
//  Created by Gaurav Parmar on 11/05/20.
//  Copyright © 2020 Krutik V. Poojara. All rights reserved.
//

import UIKit
import Alamofire
import Toaster

class DeliveryDetailVC: UIViewController {

    @IBOutlet weak var imgProduct: UIImageView!
    @IBOutlet weak var imgDeliveryProduct: UIImageView!
    @IBOutlet weak var imgShopAddress: UIImageView!
    @IBOutlet weak var imgAdditionalNotes: UIImageView!

    @IBOutlet weak var txtAddress: UITextView!
    @IBOutlet weak var txtShopAddress: UITextView!
    @IBOutlet weak var txtAdditionalNotes: UITextView!

    @IBOutlet weak var tableProduct: UITableView!
    @IBOutlet weak var tableHeight: NSLayoutConstraint!

    @IBOutlet weak var lblProductCost: UILabel!
    @IBOutlet weak var lblProductCostValue: UILabel!

    @IBOutlet weak var lblServiceTax: UILabel!
    @IBOutlet weak var lblServiceTaxValue: UILabel!

    @IBOutlet weak var lblDeliveryCharge: UILabel!
    @IBOutlet weak var lblDeliveryChargeValue: UILabel!

    @IBOutlet weak var lblDeliveryName: UILabel!
    @IBOutlet weak var lblDeliveryNameValue: UILabel!

    @IBOutlet weak var lblDeliveryMobile: UILabel!
    @IBOutlet weak var lblDeliveryMobileValue: UILabel!

    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var btnChatWith: UIButton!
    @IBOutlet weak var btnPayment: UIButton!
    @IBOutlet weak var viewDriver: UIView!
    @IBOutlet weak var viewNoDriver: UIView!
    @IBOutlet weak var viewNoPrice: UIView!

    var app = AppDelegate()
    var orderId: String?
    var response: OrderDetailRootClass?

    override func viewDidLoad() {
        super.viewDidLoad()

        imgProduct.layer.cornerRadius = imgProduct.frame.size.height / 2
        imgProduct.clipsToBounds = true

        imgDeliveryProduct.layer.cornerRadius = imgDeliveryProduct.frame.size.height / 2
        imgDeliveryProduct.clipsToBounds = true

        imgShopAddress.layer.cornerRadius = imgShopAddress.frame.size.height / 2
        imgShopAddress.clipsToBounds = true

        imgAdditionalNotes.layer.cornerRadius = imgAdditionalNotes.frame.size.height / 2
        imgAdditionalNotes.clipsToBounds = true

        self.getOrderDetail()
    }

    private func getOrderDetail() {
        var param = Parameters()
        param["order_id"] = orderId ?? ""

        let headers: HTTPHeaders = ["Authorization": self.app.defaults.value(forKey: "tokan") as! String,
        "Content-Type": "application/json"]

        AppWebservice.shared.request("\(self.app.newBaseURL)users/orders/detail", method: .post, parameters: param, headers: headers, loader: true) { (status, response, error) in

            if status == 200 {
                self.response = OrderDetailRootClass.init(fromJson: response)
                self.tableProduct.reloadData()
                self.tableHeight?.constant = self.tableProduct.contentSize.height
                self.txtAddress.text = self.response?.userAddress ?? ""
                self.txtShopAddress.text = self.response?.shopAddress ?? ""

                if (self.response?.price ?? "0") == "0" {
                    self.lblProductCostValue.text = "0 Sr"
                    self.lblDeliveryChargeValue.text = "0 Sr"
                    self.lblServiceTaxValue.text = "0 Sr"
                }

                if (self.response?.price ?? "0") == "0" && self.response?.orderStatus == "1" {
                    self.btnCancel.isHidden = false
                    self.viewDriver.isHidden = true
                    self.btnChatWith.isHidden = true
                }
                if (self.response?.price ?? "0") == "0" && self.response?.orderStatus == "2" {
                    self.btnCancel.isHidden = true
                    self.btnChatWith.isHidden = false
                    self.viewDriver.isHidden = false

                    self.lblDeliveryNameValue.text = self.response?.name ?? ""
                    self.lblDeliveryMobileValue.text = self.response?.phone ?? ""
                    self.viewNoDriver.isHidden = true
                }

                if (self.response?.price ?? "0") != "0" && self.response?.orderStatus == "2" && self.response?.isPaymentComplete == "0" {

                    self.btnCancel.isHidden = false
                   self.btnChatWith.isHidden = false
                    self.lblProductCostValue.text = (self.response?.price ?? "") + " Sr"
                    self.lblDeliveryChargeValue.text = (self.response?.orderCharge ?? "") + " Sr"
                    self.lblServiceTaxValue.text = (self.response?.serviceCharge ?? "") + " Sr"

                    let price = "Total Cost " + (self.response?.totalPrice ?? "") + " Sr"

                    self.lblDeliveryNameValue.text = self.response?.name ?? ""
                    self.lblDeliveryMobileValue.text = self.response?.phone ?? ""
                    self.viewNoDriver.isHidden = true
                    self.viewNoPrice.isHidden = true
                    self.btnPayment.setTitle(price, for: .normal)
                    self.btnCancel.isHidden = true
                }

            } else {
                Toast(text: error?.localizedDescription).show()
            }

        }
    }

    @IBAction private func cancelOrderTapped(_ sender: UIButton) {

    }

    @IBAction private func chatOrderTapped(_ sender: UIButton) {

    }

    @IBAction private func payTapped(_ sender: UIButton) {
        let storyboard = UIStoryboard.init(name: "DeliveryModule", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "PaymentConfirmation") as! PaymentConfirmation
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve
        self.navigationController?.present(vc, animated: true, completion: nil)
    }

    @IBAction private func backButtonTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }

}
extension DeliveryDetailVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if response?.orderDetail.count == 0 {
            return 1
        } else {
            return (response?.orderDetail.count ?? 0) + 1
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            guard let firstCell = tableView.dequeueReusableCell(withIdentifier: "HeaderCell", for: indexPath) as? HeaderCell else { return UITableViewCell() }

            return firstCell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) as? ItemCell else { return UITableViewCell() }
            cell.setData(response!.orderDetail![indexPath.row - 1])
            return cell
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 30
    }
}
extension DeliveryDetailVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
}
