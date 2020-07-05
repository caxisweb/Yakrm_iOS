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

class PlaceOrderVC: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate {

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
    
    @IBOutlet weak var imgProductUpload: UIImageView!
    @IBOutlet weak var imgHeight: NSLayoutConstraint!
    @IBOutlet weak var btnClose: UIButton!

    @IBOutlet weak var tableProduct: UITableView!

    var dicData: [[String: String]] = [[String: String]]()
    let locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    var storeLocation: CLLocationCoordinate2D?
    var userLocation: CLLocationCoordinate2D?
    var app = AppDelegate()
    var isStoreAddress = false
    
    var picker = UIImagePickerController()

    var strAddPhoto = "Add Photo!"
    var strTakePhoto = "Take Photo"
    var strChoosefromGallery = "Choose from Gallery"
    var strCancel = "Cancel"

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
        
        self.picker.delegate = self

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
        
        let formatter: NumberFormatter = NumberFormatter()
        formatter.locale = NSLocale(localeIdentifier: "EN") as Locale!
        let final = formatter.number(from: qty)
        let doubleNumber = Double(final!)
        
        if  doubleNumber > 0 && name != "" {
            self.dicData.append(["product_title": name, "quantity": String(Int(doubleNumber))])
            self.tableProduct.reloadData()
            self.txtProductName.text = nil
            self.txtQty.text = nil
        }
    }

    @IBAction private func btnPlaceOrderTapped(_ sender: UIButton) {
        var param = Parameters()
        param["user_address"] = self.txtAddress.text
        param["user_latitude"] = String(Double(self.userLocation?.latitude ?? 0.0))
        param["user_longitude"] = String(Double(self.userLocation?.longitude ?? 0.0))
        param["shop_address"] = self.txtShopAddress.text
        param["shop_latitude"] = String(Double(self.storeLocation?.latitude ?? 0.0))
        param["shop_longitude"] = String(Double(self.storeLocation?.longitude ?? 0.0))
        param["order_detail"] = self.dicData
        param["notes"] = self.txtAdditionalNotes.text

        let headers: HTTPHeaders = ["Authorization": self.app.defaults.value(forKey: "tokan") as! String,
        "Content-Type": "application/json"]

        AppWebservice.shared.request("\(self.app.newBaseURL)users/orders/create", method: .post, parameters: param, headers: headers, loader: true) { (status, response, error) in
            if status == 200 {
                
                Toast(text: response?["message"].string ?? "").show()
                if (response!["status"].string ?? "") == "1" {
                    
                    self.txtAddress.text = ""
                    self.userLocation = nil
                    self.storeLocation = nil
                    self.txtShopAddress.text = ""
                    self.dicData.removeAll()
                    self.tableProduct.reloadData()
                    self.txtProductName.text  = nil
                    self.txtQty.text = nil
                    self.txtAdditionalNotes.text = nil
                    
                    if self.imgProductUpload.image != nil {
                        self.uploadImage(self.imgProductUpload.image!, orderId: response!["order_id"].stringValue)
                    }else{
                        let storyboard = UIStoryboard.init(name: "DeliveryModule", bundle: nil)
                        let vc = storyboard.instantiateViewController(withIdentifier: "DeliveryDetailVC") as! DeliveryDetailVC
                        vc.orderId = response!["order_id"].stringValue
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                    
                    
                }
                
            } else {
                Toast(text: error?.localizedDescription).show()
            }
        }

    }
    
    
    func uploadImage(_ imageFileName: UIImage, orderId: String) {

        let parameters = ["order_id":orderId]
        let headers: HTTPHeaders = ["Authorization": self.app.defaults.value(forKey: "tokan") as! String,
        "Content-Type": "application/json"]
        LoadingIndicator.shared.startLoading()
        
        AF.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(imageFileName.jpegData(compressionQuality: 0.3)!, withName: "order_image", fileName: "file.png", mimeType: "image/png")

            for (key, value) in parameters {
                multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
            }
        }, to: "\(self.app.newBaseURL)users/orders/update_order_image",method: .post,
        headers: headers).uploadProgress { progress in
            print("Upload Progress: \(progress.fractionCompleted)")
        }.responseJSON { (response) in
            print(response)
            LoadingIndicator.shared.stopLoading()
            
            let storyboard = UIStoryboard.init(name: "DeliveryModule", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "DeliveryDetailVC") as! DeliveryDetailVC
            vc.orderId = orderId
            self.navigationController?.pushViewController(vc, animated: true)
        }
            
        
    }
    

    @IBAction private func btnStoreLocationTapped(_ sender: UIButton) {
        self.isStoreAddress =  true
        let storyboard = UIStoryboard.init(name: "DeliveryModule", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "UpdateLocationViewController") as! UpdateLocationViewController
        vc.modalPresentationStyle = .fullScreen
        vc.delegate = self
        self.navigationController?.present(vc, animated: true, completion: nil)
    }

    @IBAction private func btnChangeAddressTapped(_ sender: UIButton) {
        self.isStoreAddress =  false
        let storyboard = UIStoryboard.init(name: "DeliveryModule", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "UpdateLocationViewController") as! UpdateLocationViewController
        vc.modalPresentationStyle = .fullScreen
        vc.delegate = self
        self.navigationController?.present(vc, animated: true, completion: nil)
    }
    
    @IBAction private func btnCloseTapped(_ sender : UIButton) {
        self.btnClose.isHidden = true
        self.imgHeight.constant = 0
        self.imgProductUpload.image = nil
    }
    
    @IBAction func btnPhotoTapped(_ sender: UIButton) {
        let alertController = UIAlertController(title: self.strAddPhoto.localized, message: nil, preferredStyle: .actionSheet)
        let ok = UIAlertAction(title: self.strTakePhoto.localized, style: .default, handler: { (_) -> Void in
            self.openCamera()
        })
        let cancel = UIAlertAction(title: self.strCancel.localized, style: .cancel, handler: { (_) -> Void in
        })
        let  delete = UIAlertAction(title: self.strChoosefromGallery.localized, style: .default) { (_) -> Void in
            self.openGallary()
        }

        alertController.addAction(ok)
        alertController.addAction(cancel)
        alertController.addAction(delete)

        present(alertController, animated: true, completion: nil)
    }

    func openCamera() {
        if UIImagePickerController .isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
            self.picker.mediaTypes = ["public.image"]
            picker.allowsEditing = false
            picker.sourceType = UIImagePickerController.SourceType.camera
            picker.cameraCaptureMode = .photo
            present(picker, animated: true, completion: nil)
        } else {
            //            let alert = UIAlertController(title: "Camera Not Found", message: "This device has no Camera", preferredStyle: .alert)
            //            let ok = UIAlertAction(title: "OK", style:.default, handler: nil)
            //            alert.addAction(ok)
            //            present(alert, animated: true, completion: nil)
            self.openGallary()
        }
    }

    func openGallary() {
        self.picker.mediaTypes = ["public.image"]
        picker.allowsEditing = false
        picker.sourceType = UIImagePickerController.SourceType.photoLibrary
        present(picker, animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        // Local variable inserted by Swift 4.2 migrator.
        let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)

        let imageSelected = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.originalImage)] as? UIImage

        picker .dismiss(animated: true, completion: nil)
        
        self.imgProductUpload.image = imageSelected
        self.imgHeight.constant = 120.0
        self.btnClose.isHidden = false
        
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
        self.userLocation = currentLocation?.coordinate
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
            cell.indexPath = indexPath
            cell.deleteCallBack = { (indexPath) in
                self.dicData.remove(at: indexPath.row - 1)
                self.tableProduct.reloadData()
            }
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

    func didSelectedLocation(_ vc: UpdateLocationViewController, _ location: CLLocationCoordinate2D?, _ address: String?) {
        if self.isStoreAddress {
            self.txtShopAddress.text = address
            self.storeLocation = location
        }else {
            self.txtAddress.text = address
            self.userLocation = location
        }
        
        vc.dismiss(animated: true, completion: nil)
    }
    func didCancelLocation(_ vc : UpdateLocationViewController) {
        vc.dismiss(animated: true, completion: nil)
    }
}

// Helper function inserted by Swift 4.2 migrator.
private func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
    return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}

// Helper function inserted by Swift 4.2 migrator.
private func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
    return input.rawValue
}
