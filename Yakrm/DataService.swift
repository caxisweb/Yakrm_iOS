//
//  DataService.swift
//  CDBarcodes
//
//  Created by Matthew Maher on 1/29/16.
//  Copyright © 2016 Matt Maher. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import Toaster

class DataService {

    static let dataService = DataService()

    private(set) var ALBUM_FROM_DISCOGS = ""
    private(set) var YEAR_FROM_DISCOGS = ""

    static func searchAPI(codeNumber: String) {

        // The URL we will use to get out album data from Discogs

        let discogsURL = "\(DISCOGS_AUTH_URL)\(codeNumber)&?barcode&key=\(DISCOGS_KEY)&secret=\(DISCOGS_SECRET)"

        AppWebservice.shared.request(discogsURL, method: .get, parameters: nil, headers: nil, loader: true) { (statusCode, response, error) in
            if statusCode == 200 {
                let json = response!
                print(json)

            } else {
                Toast(text: error?.localizedDescription).show()
            }
        }
    }
}
