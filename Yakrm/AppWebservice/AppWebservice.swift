//
//  AppWebservice.swift
//  WebService
//
//  Created by Gaurav Parmar on 09/05/20.
//  Copyright © 2020 Gaurav Parmar. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

enum ApiError: Error {
    case forbidden              //Status code 403
    case notFound               //Status code 404
    case conflict               //Status code 409
    case internalServerError    //Status code 500
}

class Connectivity {
    class var isConnectedToInternet: Bool {
        return NetworkReachabilityManager()?.isReachable ?? false
    }
}

enum NetworkError: Error {
    case networkConnection
}

extension NetworkError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .networkConnection:
            return NSLocalizedString("No internet connection found.", comment: "Network Error")
        }
    }
}

class AppWebservice {

    static let shared = AppWebservice()

    //Initializer access level change now
    private init() {}

    func request(_ url: String, method: HTTPMethod = .get, parameters: Parameters? = nil, headers: HTTPHeaders? = nil, loader: Bool, completion: @escaping (Int, JSON?, Error?) -> Void) {

        if Connectivity.isConnectedToInternet {
            if loader {
                LoadingIndicator.shared.startLoading()
            } else {
                LoadingIndicator.shared.startNetworkIndicator()
            }
            print(JSON(parameters))
            AF.request(url, method: method, parameters: parameters, encoding: JSONEncoding.default, headers: headers).response { response in

                if loader {
                    LoadingIndicator.shared.stopLoading()
                } else {
                    LoadingIndicator.shared.stopNetworkIndicator()
                }

                switch response.result {
                case .success(let data):
                    let json = JSON(data!)
                    print(json)
                    completion(200, json, nil)
                case .failure(let error):
                    completion(response.response?.statusCode ?? 500, nil, error)
                }
            }
        } else {
            completion(500, nil, NetworkError.networkConnection)
        }

    }

}
