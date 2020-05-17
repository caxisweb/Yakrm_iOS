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
    
    static func searchAPI(codeNumber: String)
    {
        
        // The URL we will use to get out album data from Discogs
        
        let discogsURL = "\(DISCOGS_AUTH_URL)\(codeNumber)&?barcode&key=\(DISCOGS_KEY)&secret=\(DISCOGS_SECRET)"
        
        Alamofire.request(discogsURL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON { response in
            debugPrint(response)
            
            if response.response?.statusCode == 200
            {
                if response.result.isSuccess == true
                {
                    if let value = response.result.value
                    {
                        let json = JSON(value)
                        print(json)
                    }
                }
                else
                {
                    Toast(text: "Request time out.").show()
                }
            }
            else
            {
                print(response.result.error.debugDescription)
                Toast(text: "Request time out.").show()
            }
        }
       
    }
}
