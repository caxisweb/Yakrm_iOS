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
    @IBOutlet weak var imgAdditionalNotes: UIImageView!
    @IBOutlet weak var imgPayment: UIImageView!
    @IBOutlet weak var imgDelivery: UIImageView!

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
    
    @IBOutlet weak var lblOrderID: UILabel!
    @IBOutlet weak var lblProductNumber: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblShopAddress: UILabel!
    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var viewStatus: UIView!
    @IBOutlet weak var viewPayment: UIView!
    

    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var btnChatWith: UIButton!
    @IBOutlet weak var lblPayment: UILabel!
    @IBOutlet weak var btnPayment: UIButton!
    @IBOutlet weak var viewDriver: UIView!
    @IBOutlet weak var viewNoDriver: UIView!
    @IBOutlet weak var viewNoPrice: UIView!
    @IBOutlet weak var viewPay: UIView!
    
    @IBOutlet weak var imgUpload: UIImageView!
    @IBOutlet weak var imgHeight: NSLayoutConstraint!
    
    @IBOutlet weak var lblTitle: UILabel!
    
    @IBOutlet weak var viewOrderInfo : UIView!
    @IBOutlet weak var viewPaymentInfo : UIView!
    @IBOutlet weak var viewDriverInfo : UIView!
    
    

    var app = AppDelegate()
    var orderId: String?
    var response: OrderDetailRootClass?

    override func viewDidLoad() {
        super.viewDidLoad()

        imgProduct.layer.cornerRadius = imgProduct.frame.size.height / 2
        imgProduct.clipsToBounds = true

        imgAdditionalNotes.layer.cornerRadius = imgAdditionalNotes.frame.size.height / 2
        imgAdditionalNotes.clipsToBounds = true
        
        imgPayment.layer.cornerRadius = imgPayment.frame.size.height / 2
        imgPayment.clipsToBounds = true
        
        imgDelivery.layer.cornerRadius = imgDelivery.frame.size.height / 2
        imgDelivery.clipsToBounds = true
        
        viewStatus.layer.cornerRadius = viewStatus.frame.size.height / 2
        viewStatus.clipsToBounds = true
        
        self.lblTitle.text = "Order details".localizeString()
        
        let floatRadius : CGFloat = 5
        
        self.viewOrderInfo.dropShadow(color: .lightGray, opacity: 1, offSet: CGSize(width: 0, height: 5), radius: floatRadius, scale: true)
        self.viewPaymentInfo.dropShadow(color: .lightGray, opacity: 1, offSet: CGSize(width: 0, height: 5), radius: floatRadius, scale: true)
        self.viewDriverInfo.dropShadow(color: .lightGray, opacity: 1, offSet: CGSize(width: 0, height: 5), radius: floatRadius, scale: true)
        self.txtAdditionalNotes.dropShadow(color: .lightGray, opacity: 1, offSet: CGSize(width: 0, height: 5), radius: floatRadius, scale: true)
        self.tableProduct.dropShadow(color: .lightGray, opacity: 1, offSet: CGSize(width: 0, height: 5), radius: floatRadius, scale: true)
        

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
                
                let count = self.response?.orderDetail?.count ?? 0
                
                self.lblOrderID.text = "Order Id".localizeString() + " : " + (self.response?.id ?? "")
                self.lblProductNumber.text = "Product".localizeString() + ":" + (String(count) ?? "")
            
                self.lblAddress.text = self.response?.userAddress ?? ""
                self.lblStatus.text = self.response?.statusString
                self.lblShopAddress.text = self.response?.shopAddress ?? ""

                if (self.response?.price ?? "0") == "0" {
                    self.lblProductCostValue.text = "0 Sr"
                    self.lblDeliveryChargeValue.text = "0 Sr"
                    self.lblServiceTaxValue.text = "0 Sr"
                    self.lblPayment.isHidden = true
                    self.btnPayment.isHidden = true
                    self.viewDriver.isHidden = true
                    self.viewPay.isHidden = true
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

                    let price = "Total Cost ".localizeString() + (self.response?.totalPrice ?? "") + " Sr"

                    self.lblDeliveryNameValue.text = self.response?.name ?? ""
                    self.lblDeliveryMobileValue.text = self.response?.phone ?? ""
                    self.viewNoDriver.isHidden = true
                    self.viewNoPrice.isHidden = true
                    self.lblPayment.text = price
                    self.btnCancel.isHidden = true
                }
                
                if (self.response?.price ?? "0") != "0" && self.response?.orderStatus == "2" && self.response?.isPaymentComplete == "1" {

                    self.btnCancel.isHidden = false
                   self.btnChatWith.isHidden = false
                    self.lblProductCostValue.text = (self.response?.price ?? "") + " Sr"
                    self.lblDeliveryChargeValue.text = (self.response?.orderCharge ?? "") + " Sr"
                    self.lblServiceTaxValue.text = (self.response?.serviceCharge ?? "") + " Sr"

                    let price = "Total Cost ".localizeString() + (self.response?.totalPrice ?? "") + " Sr"

                    self.lblDeliveryNameValue.text = self.response?.name ?? ""
                    self.lblDeliveryMobileValue.text = self.response?.phone ?? ""
                    self.viewNoDriver.isHidden = true
                    self.viewNoPrice.isHidden = true
                    self.lblPayment.text = price
                    self.btnCancel.isHidden = true
                    self.btnPayment.isHidden = true
                }else if self.response?.status == "6" {
                    self.btnCancel.isHidden = true
                    self.btnChatWith.isHidden = true
                    self.viewPay.isHidden = true
                }
                
                if self.response?.isPaymentComplete == "1" {
                    self.viewPayment.isHidden = false
                }else {
                    self.viewPayment.isHidden = true
                }
                
                if self.response?.orderImage != nil && self.response?.orderImage != "" {
                    self.imgHeight.constant = 120.0
                    let url = self.app.orderBaseURL + (self.response?.orderImage!)!
                    self.imgUpload.sd_setImage(with: URL.init(string: url), completed: nil)
                }
                
                
//                if self.app.strLanguage != "ar" {
//                    Toast(text: response?["message"].string ?? "").show()
//                }else {
//                    Toast(text: response?["arab_message"].string ?? "").show()
//                }
                

            } else {
                Toast(text: error?.localizedDescription).show()
            }

        }
    }
    
    private func cancelOrder() {
        var param = Parameters()
        param["order_id"] = orderId ?? ""
        
        let headers: HTTPHeaders = ["Authorization": self.app.defaults.value(forKey: "tokan") as! String,
                                    "Content-Type": "application/json"]
        
        AppWebservice.shared.request("\(self.app.newBaseURL)users/orders/cancel_order", method: .post, parameters: param, headers: headers, loader: true) { (status, response, error) in
            
            if status == 200 {
                if self.app.strLanguage != "ar" {
                    Toast(text: response?["message"].string ?? "").show()
                }else {
                    Toast(text: response?["arab_message"].string ?? "").show()
                }
                
                self.navigationController?.popViewController(animated: true)
            }
        }
    }

    @IBAction private func cancelOrderTapped(_ sender: UIButton) {
        self.cancelOrder()
    }

    @IBAction private func chatOrderTapped(_ sender: UIButton) {

        let storyboard = UIStoryboard.init(name: "DeliveryModule", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ChatVC") as! ChatVC
        vc.orderId = self.orderId
        vc.name = self.response!.name ?? ""
        vc.phone = self.response!.phone ?? ""
        self.navigationController?.pushViewController(vc, animated: true)
        
    }

    @IBAction private func payTapped(_ sender: UIButton) {
        let storyboard = UIStoryboard.init(name: "DeliveryModule", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "PaymentConfirmation") as! PaymentConfirmation
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve
        vc.delegate = self
        vc.price = self.response?.totalPrice ?? ""
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
            cell.btnDelete.isHidden = true
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
extension DeliveryDetailVC : PaymentDelegate {
    
    func didPayTapped(_ viewController: PaymentConfirmation) {
        viewController.dismiss(animated: true) {
            let storyboard = UIStoryboard.init(name: "DeliveryModule", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "DeliveryPaymentVC") as! DeliveryPaymentVC
            vc.strTotal = self.response?.totalPrice ?? ""
            vc.orderId = self.orderId ?? ""
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func didCancelTapped(_ viewController: PaymentConfirmation) {
        viewController.dismiss(animated: true) { }
    }
    
}
