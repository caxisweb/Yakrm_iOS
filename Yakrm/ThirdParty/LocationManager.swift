//
//  LocationManager.swift
//  CannaPos
//
//  Created by Nimit Bagadiya on 01/01/20.
//  Copyright © 2020 Mohit. All rights reserved.
//

import Foundation
import CoreLocation
import GooglePlaces
import GoogleMaps

typealias ReverseGeoLocationResponse = (_ address: GMSAddress?, _ error: Error?) -> Void
typealias GeoLocationResponse = (_ address: CLPlacemark?, _ error: Error?) -> Void

class LocationManager: NSObject {

    static let shared = LocationManager()
    let locationManager = CLLocationManager()
    var userLocation: CLLocationCoordinate2D?
    var isCurrentLocation: Bool = true
    var product: String?
    var userAddress: String?

    private override init() {}

    func setLocationManager() {
        self.locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }

    func startUpdatingLocation() {
        locationManager.startUpdatingLocation()
    }

    func stopUpdatingLocation() {
        locationManager.stopUpdatingLocation()
    }

    func geAddressFromLocation(location: CLLocationCoordinate2D?, completion: @escaping ReverseGeoLocationResponse) {

        let coder = GMSGeocoder()

        guard let userLocation = location else {
            return
        }

        coder.reverseGeocodeCoordinate(userLocation) { (response, error) in

            guard let placemark = response?.firstResult() else {
                completion(nil, error)
                return
            }

            print(placemark.lines ?? [])
            completion(placemark, nil)
        }
    }

    func getLocationFromAddress(addressString: String, completion: @escaping GeoLocationResponse) {

        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(addressString) { (placemarks, error) in
            guard let placemark = placemarks?.first else {
                completion(nil, error)
                return
            }
            completion(placemark, error)
        }

    }

}

extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        self.userLocation = locValue
        self.locationManager.stopUpdatingLocation()
        NotificationCenter.default.post(name: NSNotification.Name("LocationUpdated"), object: nil)
    }
}
