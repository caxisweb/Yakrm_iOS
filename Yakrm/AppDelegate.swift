//
//  AppDelegate.swift
//  Yakrm
//
//  Created by Krutik V. Poojara on 06/12/18.
//  Copyright © 2018 Krutik V. Poojara. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import SystemConfiguration
import Alamofire
import UserNotifications
import SwiftyJSON
import Localize_Swift
import UserNotifications
import GoogleMaps
import GooglePlaces

enum UIUserInterfaceIdiom: Int {
    case Unspecified
    case Phone
    case Pad
}

struct ScreenSize {
    static let SCREEN_WIDTH         = UIScreen.main.bounds.size.width
    static let SCREEN_HEIGHT        = UIScreen.main.bounds.size.height
    static let SCREEN_MAX_LENGTH    = max(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
    static let SCREEN_MIN_LENGTH    = min(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
}

struct DeviceType {
    static let IS_IPHONE_4_OR_LESS  = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH < 568.0
    static let IS_IPHONE_5          = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 568.0
    static let IS_IPHONE_6          = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 667.0
    static let IS_IPHONE_6P         = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 736.0
    static let IS_IPHONE_X         = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 812.0
    static let IS_IPHONE_XR         = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 896.0
    static let IS_IPAD              = UIDevice.current.userInterfaceIdiom == .pad && ScreenSize.SCREEN_MAX_LENGTH == 1024.0
    static let IS_IPAD_PRO          = UIDevice.current.userInterfaceIdiom == .pad && ScreenSize.SCREEN_MAX_LENGTH == 1366.0
    static let IS_SIMULATOR          = TARGET_IPHONE_SIMULATOR == 1
}

@available(iOS 11.0, *)
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    var window: UIWindow?

    let defaults = UserDefaults.standard

    // MARK: Test API

    var BaseURL = "http://test.yakrm.com/api/"
    var ImageURL = "http://test.yakrm.com/assets/uploads/"
    var SalesURL = "http://test.yakrm.com/api_salesmen/"
    var newBaseURL = "http://test.yakrm.com/apis/v1/"

    // MARK: Live API
    //var BaseURL = "http://yakrm.com/api/"
    //var ImageURL = "http://yakrm.com/assets/uploads/"
    //var SalesURL = "http://yakrm.com/api_salesmen/"

    var InternetConnectionMessage = "No Internet Connection"
    var RequestTimeOut = "Request time out."

    var strUserID = String()
    var strUserType = "users"
    var strName = String()
    var strEmail = String()
    var strGender = String()
    var strAge = String()
    var strCountry = String()
    var strCountryID = String()
    var strMobile = String()
    var strProfile = String()
    var strToken = String()
    var strWallet = String()
    var strCart = ""
    var AdminProfitDiscount = Float()

    var strLanguage = String()
    var isEnglish = Bool()
    var isLangEnglish = Bool()
    var isCartAdded = Bool()

    var strDeviceToken = String()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        UIApplication.shared.statusBarStyle = .default
        //        UIApplication.shared.statusBarStyle = .lightContent
//        UIApplication.shared.statusBarView?.backgroundColor = UIColor.init(rgb: 0xEE4158)//D93454)//D03251

        let langStr: String = Locale.current.languageCode!
        if langStr == "ar" {
            self.isLangEnglish = false
        } else {
            self.isLangEnglish = true
        }
        print(langStr)
        
        GMSServices.provideAPIKey("AIzaSyBq46koOKR3Q3K2xdVRo0ib0okFV_WPnDE")
        GMSPlacesClient.provideAPIKey("AIzaSyBq46koOKR3Q3K2xdVRo0ib0okFV_WPnDE")
        

        NotificationCenter.default.addObserver(self, selector: #selector(languageWillChange), name: NSNotification.Name(rawValue: "LANGUAGE_WILL_CHANGE"), object: nil)

        if self.defaults.string(forKey: "selectedLanguage") != nil {
            self.strLanguage = (self.defaults.value(forKey: "selectedLanguage") as! String)
            self.isEnglish = (self.defaults.value(forKey: "selectedLanguagebool") as! Bool)
        } else {
            let prefferedLanguage = Locale.preferredLanguages[0] as String
            let arr = prefferedLanguage.components(separatedBy: "-")
            self.strLanguage = arr.first!

            if self.strLanguage == "ar" {
                self.isEnglish = false
            } else {
                self.isEnglish = true
            }
            self.defaults.setValue(self.isEnglish, forKey: "selectedLanguagebool")
            self.defaults.setValue(self.strLanguage, forKey: "selectedLanguage") //String
            self.defaults.synchronize()
        }
        Bundle.setLanguage(self.strLanguage)

        var strViewController = "ViewController"
        if defaults.string(forKey: "user_id") != nil {
            self.strUserID = (defaults.value(forKey: "user_id") as! String)
            self.strName = (defaults.value(forKey: "name") as! String)
            self.strEmail = (defaults.value(forKey: "email") as! String)
            self.strMobile = (defaults.value(forKey: "mobile") as! String)

            if defaults.string(forKey: "profile") != nil {
                self.strProfile = (defaults.value(forKey: "profile") as! String)
            }
            if defaults.string(forKey: "tokan") != nil {
                self.strToken = (defaults.value(forKey: "tokan") as! String)
            } else {
                strViewController = "ViewController"
            }
            if defaults.string(forKey: "wallet") != nil {
                self.strWallet = (defaults.value(forKey: "wallet") as! String)
            }
            if self.defaults.string(forKey: "user_type") != nil {
                self.strUserType = (defaults.value(forKey: "user_type") as! String)
            }
            if self.strUserType == "users" {
                strViewController = "HomeView"
            } else {
                strViewController = "CouponView"
            }
            if self.defaults.string(forKey: "isCartAdded") != nil {
                self.isCartAdded = (self.defaults.value(forKey: "isCartAdded") as! Bool)
            }
            //vickysalesman 12345
        }
        if DeviceType.IS_SIMULATOR {
//            strViewController = "NewAccountView"
        }
        
        let navigationBarAppearace = UINavigationBar.appearance()

        navigationBarAppearace.tintColor = UIColor.white
        navigationBarAppearace.barTintColor = UIColor.init(named: "pinkColor")
        

//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let navigationController = storyboard.instantiateViewController(withIdentifier: "NavigationController") as! UINavigationController
//        navigationController.setViewControllers([storyboard.instantiateViewController(withIdentifier: strViewController)], animated: false)
//        let mainViewController = storyboard.instantiateInitialViewController() as! MainViewController
//        mainViewController.rootViewController = navigationController
//        mainViewController.setup(type: UInt(2))
//
//        let window = UIApplication.shared.delegate!.window!!
//        window.rootViewController = mainViewController
        
        let storyboard = UIStoryboard.init(name: "DeliveryModule", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "StartScreenVC")
        let navigation  = UINavigationController.init(rootViewController: vc)
        
        let window = UIApplication.shared.delegate!.window!!
        window.rootViewController = navigation
        

        UIView.transition(with: window, duration: 0.3, options: [.transitionCrossDissolve], animations: nil, completion: nil)

        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enableAutoToolbar = true
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true

        registerForPushNotifications(application: application)

        return true
    }

    // MARK: - Registrer for Push Notification
    func registerForPushNotifications(application: UIApplication) {
        if #available(iOS 10.0, *) {
            let center = UNUserNotificationCenter.current()
            center.requestAuthorization(options: [.badge, .alert, .sound]) { (greanted, _) in
                if greanted {
                    UIApplication.shared.registerForRemoteNotifications()
                }
            }
        } else {
            let type: UIUserNotificationType = [UIUserNotificationType.badge, UIUserNotificationType.alert, UIUserNotificationType.sound]
            let setting = UIUserNotificationSettings(types: type, categories: nil)
            UIApplication.shared.registerUserNotificationSettings(setting)
            UIApplication.shared.registerForRemoteNotifications()
        }
    }

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        strDeviceToken = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        print(strDeviceToken)
    }

    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        strDeviceToken = ""
        print(error.localizedDescription)
        print(strDeviceToken)
    }

    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        if application.applicationState == .active {
//            print(JSON(userInfo))
            let Info = JSON(userInfo)
            let aps = Info["aps"]
            let alert = aps["alert"]
            let title: String = alert["title"].stringValue
            let message: String = alert["body"].stringValue

            let content = UNMutableNotificationContent()
            content.title = title
            content.body = message
            content.userInfo = userInfo
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 0.1, repeats: false)

            //getting the notification request
            let request = UNNotificationRequest(identifier: "SimplifiedIOSNotification", content: content, trigger: trigger)
            UNUserNotificationCenter.current().delegate = self
            UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
        }
    }

    // called when user interacts with notification (app not running in foreground)
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse, withCompletionHandler
        completionHandler: @escaping () -> Void) {
        // do something with the notification
        print(JSON(response.notification.request.content.userInfo))
        print(response.notification.request.identifier)
        self.gotoViewController(json: JSON(response.notification.request.content.userInfo), strType: response.notification.request.identifier)

        return completionHandler()
    }

    func gotoViewController(json: JSON, strType: String) {
        var strViewController = "ViewController"
        if defaults.string(forKey: "user_id") != nil {
            if self.defaults.string(forKey: "user_type") != nil {
                self.strUserType = (defaults.value(forKey: "user_type") as! String)
            } else {
                self.strUserType = "users"
            }
            if self.strUserType == "users" {
                strViewController = "HomeView"
            } else {
                strViewController = "CouponView"
            }
        }

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let navigationController = storyboard.instantiateViewController(withIdentifier: "NavigationController") as! UINavigationController
        navigationController.setViewControllers([storyboard.instantiateViewController(withIdentifier: strViewController)], animated: false)
        let mainViewController = storyboard.instantiateInitialViewController() as! MainViewController
        mainViewController.rootViewController = navigationController
        mainViewController.setup(type: UInt(2))

        let window = UIApplication.shared.delegate!.window!!
        window.rootViewController = mainViewController

        UIView.transition(with: window, duration: 0.3, options: [.transitionCrossDissolve], animations: nil, completion: nil)
//        let notification = json["notification"].stringValue
        if self.defaults.string(forKey: "isCartAdded") != nil {
            self.isCartAdded = (self.defaults.value(forKey: "isCartAdded") as! Bool)
        }

        if strType == "CartView"//!notification.isEmptyself.isCartAdded//
        {
            let VC = storyboard.instantiateViewController(withIdentifier: "CartView") as! CartView
            navigationController.pushViewController(VC, animated: true)
            UIApplication.shared.cancelAllLocalNotifications()
            self.AddNotification()
        }
//        let rootController = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "HomeView") as! HomeView
//        let navigation = UINavigationController(rootViewController: rootController)
//        //        navigation.isNavigationBarHidden = true
//        self.window!.rootViewController! = navigation
//
//        let strUpdate : String = json["update"].stringValue
//        if strUpdate.isEmpty
//        {
//            //            let rootViewController = self.window!.rootViewController as! UINavigationController
//            self.strPageName = ""
//            let VC = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "SnozeView") as! SnozeView
//            VC.json = json
//            navigation.pushViewController(VC, animated: true)
//        }//UIApplication.shared.applicationIconBadgeNumber = UIApplication.shared.applicationIconBadgeNumber + 1
    }

    // called if app is running in foreground
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent
        notification: UNNotification, withCompletionHandler completionHandler:
        @escaping (UNNotificationPresentationOptions) -> Void) {
        print(JSON(notification.request.content.userInfo))
        return completionHandler(UNNotificationPresentationOptions.alert)
    }

    func AddNotification() {
        let content = UNMutableNotificationContent()
        content.title = "cart already added"
        content.body = "Please proceed"
        content.userInfo = ["notification": "123"]
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 900, repeats: true)
        let request = UNNotificationRequest(identifier: "CartView", content: content, trigger: trigger)

        UNUserNotificationCenter.current().delegate = self

        //adding the notification to notification center
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
        print("Added")
    }

    @objc func languageWillChange(notification: NSNotification) {
        let targetLang = notification.object as! String
        UserDefaults.standard.set(targetLang, forKey: "selectedLanguage")
        Bundle.setLanguage(targetLang)
//        Localize.setCurrentLanguage(targetLang)
//        Bundle.setLanguage123(lang: targetLang)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "LANGUAGE_DID_CHANGE"), object: targetLang)
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        UIApplication.shared.applicationIconBadgeNumber = 0
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    // MARK: - Internet Connection Check
    func isConnectedToInternet() -> Bool {
        return NetworkReachabilityManager()!.isReachable
    }
    // MARK: -

    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any]) -> Bool {
        var handler: Bool = false
        //shopperResultUrl=com.inforaam.Yakrm.payments://result
        if url.scheme?.caseInsensitiveCompare("com.inforaam.Yakrm.payments") == .orderedSame {
            NotificationCenter.default.post(name: Notification.Name(rawValue: "AsyncPaymentCompletedNotificationKey"), object: nil)

            handler = true
        }
        return handler
    }

    func application(_ application: UIApplication, shouldAllowExtensionPointIdentifier extensionPointIdentifier: UIApplication.ExtensionPointIdentifier) -> Bool {
        if extensionPointIdentifier == UIApplication.ExtensionPointIdentifier.keyboard {
            return false
        }
        return true
    }

}

//extension String
//{
//    var localized: String
//    {
//        return NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: "")
//    }
//}

extension String {
    var localized: String {return NSLocalizedString(self, comment: "")}
}

extension Bundle {
    private static var bundle: Bundle!
    public static func localizedBundle() -> Bundle! {
        if bundle == nil {
            let appLang = UserDefaults.standard.string(forKey: "app_lang") ?? "en"
            let path = Bundle.main.path(forResource: appLang, ofType: "lproj")
            bundle = Bundle(path: path!)
        }
        return bundle
    }

    public static func setLanguage123(lang: String) {
        UserDefaults.standard.set(lang, forKey: "app_lang")
        let path = Bundle.main.path(forResource: lang, ofType: "lproj")
        bundle = Bundle(path: path!)
    }

}

extension UIColor {
    convenience init(rgb: UInt) {
        self.init(
            red: CGFloat((rgb & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgb & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgb & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}

extension String {
    func isValidEmail() -> Bool {
        // here, `try!` will always succeed because the pattern is valid
        let regex = try! NSRegularExpression(pattern: "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Z]{2,64}$", options: .caseInsensitive)
        return regex.firstMatch(in: self, options: [], range: NSRange(location: 0, length: count)) != nil
    }
}

extension String {
    func isValidNumberPlat() -> Bool {
        // ^[A-Z]{2}[ -][0-9]{1,2}(?: [A-Z])?(?: [A-Z]*)? [0-9]{4}$
        let regex = try! NSRegularExpression(pattern: "^[A-Z]{2}[ -][0-9]{1,2}(?: [A-Z])?(?: [A-Z]*)? [0-9]{4}$", options: .caseInsensitive)
        return regex.firstMatch(in: self, options: [], range: NSRange(location: 0, length: count)) != nil
        //"^[A-Z]{2}[0-9]{1,2}(?: [A-Z])?(?: [A-Z]*)?[0-9]{4}"
    }
}

extension String {
    func isPasswordValid() -> Bool {
        let passwordRegex = "^(?=.*[A-Za-z])(?=.*\\d)[A-Za-z\\d]{8,}$"//"^(?=.*[A-Z])(?=.*\\d)[A-Za-z\\d]{8,}$"
        return NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: self)
    }
}

extension UITextField {
    func setLeftPaddingPoints(_ vv: UIView) {
        self.leftView = vv
        self.leftViewMode = .always
    }
    func setRightPaddingPoints(_ vv: UIView) {
        self.rightView = vv
        self.rightViewMode = .always
    }
}

extension UIImage {
    public func maskWithColor(color: UIColor) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        let context = UIGraphicsGetCurrentContext()!

        let rect = CGRect(origin: CGPoint.zero, size: size)

        color.setFill()
        self.draw(in: rect)

        context.setBlendMode(.sourceIn)
        context.fill(rect)

        let resultImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return resultImage
    }

}

extension UIImage {
    func imageWithColor(color: UIColor) -> UIImage? {
        var image = withRenderingMode(.alwaysTemplate)
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        color.set()
        image.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
}

extension UITextField {
    @IBInspectable var placeHolderColor: UIColor? {
        get {
            return self.placeHolderColor
        }
        set {
            self.attributedPlaceholder = NSAttributedString(string: self.placeholder != nil ? self.placeholder! : "", attributes: [NSAttributedString.Key.foregroundColor: newValue!])
        }
    }
}

extension NSMutableAttributedString {
    func setColorForText(_ textToFind: String, with color: UIColor) {
        let range = self.mutableString.range(of: textToFind, options: .caseInsensitive)
        if range.location != NSNotFound {
            addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: range)
        }
    }
}

extension UIView {
    // OUTPUT 1
    func dropShadow(scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.5
        layer.shadowOffset = CGSize(width: -1, height: 1)
        layer.shadowRadius = 1

        layer.shadowPath = UIBezierPath(rect: bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }

    // OUTPUT 2
    func dropShadow(color: UIColor, opacity: Float = 0.5, offSet: CGSize, radius: CGFloat = 1, scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = offSet
        layer.shadowRadius = radius

        layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        layer.shouldRasterize = true
        layer.frame = self.frame
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
}

extension UIView {
    func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
}

extension UILabel {
    func heightForLabel(text: String, font: UIFont, width: CGFloat) -> CGFloat {
        let label: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = font
        label.text = text

        label.sizeToFit()
        return label.frame.height
    }

}

extension Date {
    func dateAt(hours: Int, minutes: Int) -> Date {
        let calendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)!

        //get the month/day/year componentsfor today's date.

        var date_components = calendar.components(
            [NSCalendar.Unit.year,
             NSCalendar.Unit.month,
             NSCalendar.Unit.day],
            from: self)

        //Create an NSDate for the specified time today.
        date_components.hour = hours
        date_components.minute = minutes
        date_components.second = 0

        let newDate = calendar.date(from: date_components)!
        return newDate
    }
}

extension UITabBar {
    override open func sizeThatFits(_ size: CGSize) -> CGSize {
        super.sizeThatFits(size)
        guard let window = UIApplication.shared.keyWindow else {
            return super.sizeThatFits(size)
        }
        var sizeThatFits = super.sizeThatFits(size)
        if #available(iOS 11.0, *) {
            sizeThatFits.height = window.safeAreaInsets.bottom + 40
        } else {
            sizeThatFits.height = 40
            // Fallback on earlier versions
        }
        return sizeThatFits
    }
}

extension UIApplication {
    var statusBarView: UIView? {
        if responds(to: Selector(("statusBar"))) {
            return value(forKey: "statusBar") as? UIView
        }
        return nil
    }
}

private var __maxLengths = [UITextField: Int]()
extension UITextField {
    @IBInspectable var maxLength: Int {
        get {
            guard let l = __maxLengths[self] else {
                return 150 // (global default-limit. or just, Int.max)
            }
            return l
        }
        set {
            __maxLengths[self] = newValue
            addTarget(self, action: #selector(fix), for: .editingChanged)
        }
    }
    @objc func fix(textField: UITextField) {
        let t = textField.text
        textField.text = t?.safelyLimitedTo(length: maxLength)
    }
}

extension String {
    func safelyLimitedTo(length n: Int) -> String {
        if self.count <= n {
            return self
        }
        return String( Array(self).prefix(upTo: n) )
    }
}

class MyClass: UIView {
    class func instanceFromNib() -> UIView {
        return UINib(nibName: "PTFWInitialSetupView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! UIView
    }
}

extension Bundle {
    static func loadView<T>(fromNib name: String, withType type: T.Type) -> T {
        if let view = Bundle.main.loadNibNamed(name, owner: nil, options: nil)?.first as? T {
            return view
        }
        fatalError("Could not load view with type " + String(describing: type))
    }
}

extension Data {
    var html2AttributedString: NSAttributedString? {
        do {
            return try NSAttributedString(data: self, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            print("error:", error)
            return  nil
        }
    }
    var html2String: String {
        return html2AttributedString?.string ?? ""
    }
}

extension String {
    var html2AttributedString: NSAttributedString? {
        return Data(utf8).html2AttributedString
    }
    var html2String: String {
        return html2AttributedString?.string ?? ""
    }
}
