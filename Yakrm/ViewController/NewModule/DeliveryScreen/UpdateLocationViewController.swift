//
//  UpdateLocationViewController.swift
//  CannaPos
//
//  Created by Nimit Bagadiya on 01/01/20.
//  Copyright © 2020 Mohit. All rights reserved.
//

import UIKit
import GoogleMaps

protocol LocationProtocol: class {
    func didSelectedLocation(_ vc: UpdateLocationViewController, _ location: CLLocationCoordinate2D?, _ address: String?)
    func didCancelLocation(_ vc : UpdateLocationViewController)
}

class UpdateLocationViewController: UIViewController {

    @IBOutlet weak var viewMap: GMSMapView!
    @IBOutlet weak var txtAddress: UITextField!
    @IBOutlet weak var lblPrimaryAddress: UILabel!
    @IBOutlet weak var lblCityName: UILabel!
    @IBOutlet weak var lblPinCode: UILabel!
    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var btnLocation: UIButton!
    @IBOutlet weak var btnSatellite: UIButton!

    var tempLocation: CLLocationCoordinate2D?
    var strAddress: String!
    weak var delegate: LocationProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()
        txtAddress.delegate = self
        viewMap.delegate = self
        btnSave.layer.cornerRadius = 25
        btnSave.layer.masksToBounds = true
        btnSatellite.layer.cornerRadius = 25
        btnSatellite.layer.masksToBounds = true
        btnLocation.layer.cornerRadius = 25
        btnLocation.layer.masksToBounds = true

        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        LocationManager.shared.setLocationManager()
        
        guard let coordinate = LocationManager.shared.userLocation else {
            return
        }
        let marker = GMSMarker(position: coordinate)
        let camera = GMSCameraPosition(target: coordinate, zoom: 17)
        marker.map = viewMap
        viewMap.animate(to: camera)
        LocationManager.shared.geAddressFromLocation(location: coordinate) { (address, _) in
            guard let address = address else {
                return
            }
            self.strAddress = address.lines?.joined(separator: " ,")
            self.lblPrimaryAddress.text = address.lines?.joined(separator: " ,")
            self.lblCityName.text = address.locality ?? " "
            self.lblPinCode.text = address.postalCode ?? " "
        }

    }

    @IBAction func actionSatelliteClicked(_ sender: Any) {

        if viewMap.mapType == .normal {
            viewMap.mapType = .satellite
        } else {
            viewMap.mapType = .normal
        }

    }

    @IBAction func actionLocationClicked(_ sender: Any) {

        LocationManager.shared.startUpdatingLocation()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {

            guard let coordinate = LocationManager.shared.userLocation else {
                return
            }
            let marker = GMSMarker(position: coordinate)
            let camera = GMSCameraPosition(target: coordinate, zoom: 17)
            marker.map = self.viewMap
            self.viewMap.animate(to: camera)
            self.changeLocation(coordinate: coordinate)
            self.tempLocation = coordinate

        }

    }

    @IBAction func actionBAck(_ sender: Any) {
        self.delegate?.didCancelLocation(self)
//        self.navigationController?.dismiss(animated: true, completion: nil)
//        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func actionSaveAddress(_ sender: Any) {
        LocationManager.shared.userLocation = tempLocation
        self.delegate?.didSelectedLocation(self, tempLocation, self.strAddress)
    }

    @IBAction func actionSave(_ sender: Any) {

    }

    func changeLocation(coordinate: CLLocationCoordinate2D) {
        LocationManager.shared.geAddressFromLocation(location: coordinate) { (address, _) in
            guard let address = address else {
                return
            }

            self.strAddress = address.lines?.joined(separator: " ,")
            self.lblPrimaryAddress.text = address.lines?.joined(separator: " ,")
            self.lblCityName.text = address.locality ?? " "
            self.lblPinCode.text = address.postalCode ?? " "
        }
    }
}

extension UpdateLocationViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.txtAddress.endEditing(true)

        LocationManager.shared.getLocationFromAddress(addressString: txtAddress.text!) { (placemark, _) in

            guard let placemark = placemark else {
                return
            }
            self.strAddress = "\(placemark.name ?? "") \(placemark.administrativeArea ?? "") \(placemark.subAdministrativeArea ?? "")"
            self.lblPrimaryAddress.text = "\(placemark.name ?? "") \(placemark.administrativeArea ?? "") \(placemark.subAdministrativeArea ?? "")"
            self.lblCityName.text = placemark.administrativeArea ?? ""
            self.lblPinCode.text = placemark.postalCode ?? ""
            self.tempLocation = placemark.location?.coordinate
        }

        return true
    }
}

extension UpdateLocationViewController: GMSMapViewDelegate {

    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        self.viewMap.clear()
        self.changeLocation(coordinate: coordinate)
        self.tempLocation = coordinate
        let marker = GMSMarker(position: coordinate)
        let camera = GMSCameraPosition(target: coordinate, zoom: 17)
        marker.map = viewMap
        viewMap.animate(to: camera)

    }
}
