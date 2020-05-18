//
//  PlaceOrderVC.swift
//  Yakrm
//
//  Created by Gaurav Parmar on 10/05/20.
//  Copyright © 2020 Krutik V. Poojara. All rights reserved.
//

import UIKit
import Alamofire
import Toaster
import CoreLocation
import SwiftyJSON

class PlaceOrderVC: UIViewController {

    // MARK: - IBOutlet
    @IBOutlet weak var imgProduct: UIImageView!
    @IBOutlet weak var imgDeliveryProduct: UIImageView!
    @IBOutlet weak var imgShopAddress: UIImageView!
    @IBOutlet weak var imgAdditionalNotes: UIImageView!

    @IBOutlet weak var txtProductName: UITextField!
    @IBOutlet weak var txtQty: UITextField!

    @IBOutlet weak var txtAddress: UITextView!
    @IBOutlet weak var txtShopAddress: UITextView!
    @IBOutlet weak var txtAdditionalNotes: UITextView!

    @IBOutlet weak var tableProduct: UITableView!

    var dicData: [[String: String]] = [[String: String]]()
    let locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    var app = AppDelegate()

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

        self.navigationController?.isNavigationBarHidden = true

        // Ask for Authorisation from the User.
        self.locationManager.requestAlwaysAuthorization()

        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()

        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestAlwaysAuthorization()
            locationManager.startUpdatingLocation()
        }

    }

    @IBAction private func btnAddTapped(_ sender: UIButton) {
        let name = txtProductName.text ?? ""
        let qty = txtQty.text ?? ""
        self.dicData.append(["product_title": name, "quantity": qty])
        self.tableProduct.reloadData()

    }

    @IBAction private func btnPlaceOrderTapped(_ sender: UIButton) {
        var param = Parameters()
        param["user_address"] = self.txtAddress.text
        param["user_latitude"] = "1.0"
        param["user_longitude"] = "2.0"
        param["shop_address"] = self.txtShopAddress.text
        param["shop_latitude"] = ""
        param["shop_longitude"] = ""
        param["order_detail"] = self.dicData
        param["notes"] = self.txtAdditionalNotes.text

        let headers: HTTPHeaders = ["Authorization": self.app.defaults.value(forKey: "tokan") as! String,
        "Content-Type": "application/json"]

        AppWebservice.shared.request("\(self.app.newBaseURL)users/orders/create", method: .post, parameters: param, headers: headers, loader: true) { (status, response, error) in
            if status == 200 {
                
                Toast(text: response?["message"].string ?? "").show()
                if (response!["status"].string ?? "") == "1" {
                    let storyboard = UIStoryboard.init(name: "DeliveryModule", bundle: nil)
                    let vc = storyboard.instantiateViewController(withIdentifier: "DeliveryDetailVC") as! DeliveryDetailVC
                    vc.orderId = response!["order_id"].stringValue
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                
            } else {
                Toast(text: error?.localizedDescription).show()
            }
        }

    }

    @IBAction private func btnStoreLocationTapped(_ sender: UIButton) {
        let storyboard = UIStoryboard.init(name: "DeliveryModule", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "UpdateLocationViewController") as! UpdateLocationViewController
        vc.modalPresentationStyle = .fullScreen
        vc.delegate = self
        self.navigationController?.present(vc, animated: true, completion: nil)
    }

    @IBAction private func btnPhotoTapped(_ sender: UIButton) {

    }

    private func validation() {
        if dicData.count > 0 {

        }
    }
}
extension PlaceOrderVC: CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last! as CLLocation
        currentLocation = location
        manager.stopUpdatingLocation()
    }

}
extension PlaceOrderVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if dicData.count == 0 {
            return 1
        } else {
            return dicData.count + 1
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            guard let firstCell = tableView.dequeueReusableCell(withIdentifier: "HeaderCell", for: indexPath) as? HeaderCell else { return UITableViewCell() }

            return firstCell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) as? ItemCell else { return UITableViewCell() }
            cell.setData(self.dicData[indexPath.row - 1])
            return cell
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 30
    }
}
extension PlaceOrderVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
}

extension PlaceOrderVC: LocationProtocol {

    func didSelectedLocation(_ vc: UpdateLocationViewController, _ location: CLLocationCoordinate2D, _ address: String) {
        self.txtShopAddress.text = address
        vc.dismiss(animated: true, completion: nil)
    }
}

