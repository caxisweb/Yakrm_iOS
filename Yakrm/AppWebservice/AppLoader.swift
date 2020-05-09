//
//  AppLoader.swift
//  WebService
//
//  Created by Gaurav Parmar on 09/05/20.
//  Copyright © 2020 Gaurav Parmar. All rights reserved.
//

import Foundation
import MBProgressHUD
import Toaster

class LoadingIndicator {

    static let shared = LoadingIndicator()
    var loadingNotification: MBProgressHUD!
    //Initializer access level change now
    private init() {}

    func startLoading() {
        let viewController = UIApplication.shared.windows.first!.rootViewController as! UIViewController

        loadingNotification = MBProgressHUD.showAdded(to: viewController.view, animated: false)
        loadingNotification.mode = MBProgressHUDMode.indeterminate
        loadingNotification.label.text = "Loading..."

//        KRProgressHUD.show(withMessage: "Loading...")
    }

    func stopLoading() {
        self.loadingNotification.hide(animated: true)
//        KRProgressHUD.dismiss()
    }

    func startNetworkIndicator() {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }

    func stopNetworkIndicator() {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
}
