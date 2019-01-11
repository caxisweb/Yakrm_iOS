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

enum UIUserInterfaceIdiom : Int
{
    case Unspecified
    case Phone
    case Pad
}

struct ScreenSize
{
    static let SCREEN_WIDTH         = UIScreen.main.bounds.size.width
    static let SCREEN_HEIGHT        = UIScreen.main.bounds.size.height
    static let SCREEN_MAX_LENGTH    = max(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
    static let SCREEN_MIN_LENGTH    = min(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
}

struct DeviceType
{
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

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate
{

    var window: UIWindow?

    
    let defaults = UserDefaults.standard
    
    var BaseURL = "http://codeclinic.in/demo/yakrm/api/"
    var ImageURL = "http://www.codeclinic.in/demo/yakrm/assets/uploads/user_profile/"
    
    var InternetConnectionMessage = "Internet Connetion in not availble.Try Again"
    
    var strUserID = String()
    var strUserType = String()
    var strName = String()
    var strEmail = String()
    var strGender = String()
    var strAge = String()
    var strCountry = String()
    var strCountryID = String()
    var strMobile = String()
    var strProfile = String()
    var strToken = String()

    var strLanguage = String()
    var isEnglish = Bool()
    var isLangEnglish = Bool()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool
    {
        UIApplication.shared.statusBarStyle = .lightContent
        UIApplication.shared.statusBarView?.backgroundColor = UIColor.init(rgb: 0xEE4158)//D93454)//D03251
        
        let langStr : String = Locale.current.languageCode!
        if langStr == "ar"
        {
            self.isLangEnglish = false
        }
        else
        {
            self.isLangEnglish = true
        }
        print(langStr)
        
        NotificationCenter.default.addObserver(self, selector: #selector(languageWillChange), name: NSNotification.Name(rawValue: "LANGUAGE_WILL_CHANGE"), object: nil)

        if self.defaults.string(forKey: "selectedLanguage") != nil
        {
            self.strLanguage = (self.defaults.value(forKey: "selectedLanguage") as! String)
            self.isEnglish = (self.defaults.value(forKey: "selectedLanguagebool") as! Bool)
        }
        else
        {
            let prefferedLanguage = Locale.preferredLanguages[0] as String
            let arr = prefferedLanguage.components(separatedBy: "-")
            self.strLanguage = arr.first!
            
            if self.strLanguage == "ar"
            {
                self.isEnglish = false
            }
            else
            {
                self.isEnglish = true
            }
            self.defaults.setValue(self.isEnglish, forKey: "selectedLanguagebool")
            self.defaults.setValue(self.strLanguage, forKey: "selectedLanguage") //String
            self.defaults.synchronize()
        }
        
        Bundle.setLanguage(self.strLanguage)

        var strViewController = "ViewController"

        if defaults.string(forKey: "user_id") != nil
        {
            self.strUserID = (defaults.value(forKey: "user_id") as! String)
            self.strName = (defaults.value(forKey: "name") as! String)
            self.strEmail = (defaults.value(forKey: "email") as! String)
            self.strMobile = (defaults.value(forKey: "mobile") as! String)
            strViewController = "HomeView"
            
            if defaults.string(forKey: "profile") != nil
            {
                self.strProfile = (defaults.value(forKey: "profile") as! String)
            }
            if defaults.string(forKey: "tokan") != nil
            {
                self.strToken = (defaults.value(forKey: "tokan") as! String)
            }
            else
            {
                strViewController = "ViewController"
            }
        }
        if DeviceType.IS_SIMULATOR
        {
//            strViewController = "RegisterView"
        }
//        strViewController = "MGPScannerViewController"
//        strViewController = "BarcodeView"

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let navigationController = storyboard.instantiateViewController(withIdentifier: "NavigationController") as! UINavigationController
        navigationController.setViewControllers([storyboard.instantiateViewController(withIdentifier: strViewController)], animated: false)
        let mainViewController = storyboard.instantiateInitialViewController() as! MainViewController
        mainViewController.rootViewController = navigationController
        mainViewController.setup(type: UInt(2))
        
        let window = UIApplication.shared.delegate!.window!!
        window.rootViewController = mainViewController
        
        UIView.transition(with: window, duration: 0.3, options: [.transitionCrossDissolve], animations: nil, completion: nil)
        
//        if DeviceType.IS_SIMULATOR
//        {
//            let rootController = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "HomeView") as! HomeView
//            let navigationVC = UINavigationController(rootViewController: rootController)
//            navigationVC.isNavigationBarHidden = true
//            self.window?.rootViewController = navigationVC
//        }
        
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enableAutoToolbar = true
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true

        return true
    }

    @objc func languageWillChange(notification:NSNotification)
    {
        let targetLang = notification.object as! String
        UserDefaults.standard.set(targetLang, forKey: "selectedLanguage")
        Bundle.setLanguage(targetLang)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "LANGUAGE_DID_CHANGE"), object: targetLang)
    }
    
    func applicationWillResignActive(_ application: UIApplication)
    {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    //MARK:- Internet Connection Check
    func isConnectedToInternet() ->Bool
    {
        return NetworkReachabilityManager()!.isReachable
    }
    //MARK:-
    
}


extension String
{
    var localized: String
    {
        return NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: "")
    }
}

extension UIColor
{
    convenience init(rgb: UInt)
    {
        self.init(
            red: CGFloat((rgb & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgb & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgb & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}

extension String
{
    func isValidEmail() -> Bool
    {
        // here, `try!` will always succeed because the pattern is valid
        let regex = try! NSRegularExpression(pattern: "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Z]{2,64}$", options: .caseInsensitive)
        return regex.firstMatch(in: self, options: [], range: NSRange(location: 0, length: characters.count)) != nil
    }
}

extension String
{
    func isValidNumberPlat() -> Bool
    {
        // ^[A-Z]{2}[ -][0-9]{1,2}(?: [A-Z])?(?: [A-Z]*)? [0-9]{4}$
        let regex = try! NSRegularExpression(pattern: "^[A-Z]{2}[ -][0-9]{1,2}(?: [A-Z])?(?: [A-Z]*)? [0-9]{4}$", options: .caseInsensitive)
        return regex.firstMatch(in: self, options: [], range: NSRange(location: 0, length: characters.count)) != nil
        //"^[A-Z]{2}[0-9]{1,2}(?: [A-Z])?(?: [A-Z]*)?[0-9]{4}"
    }
}

extension String
{
    func isPasswordValid() -> Bool
    {
        let passwordRegex = "^(?=.*[A-Za-z])(?=.*\\d)[A-Za-z\\d]{8,}$"//"^(?=.*[A-Z])(?=.*\\d)[A-Za-z\\d]{8,}$"
        return NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: self)
    }
}


extension UITextField
{
    func setLeftPaddingPoints(_ vv:UIView)
    {
        self.leftView = vv
        self.leftViewMode = .always
    }
    func setRightPaddingPoints(_ vv:UIView)
    {
        self.rightView = vv
        self.rightViewMode = .always
    }
}

extension UIImage
{
    public func maskWithColor(color: UIColor) -> UIImage
    {
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

extension UIImage
{
    func imageWithColor(color: UIColor) -> UIImage?
    {
        var image = withRenderingMode(.alwaysTemplate)
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        color.set()
        image.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
}

extension UITextField
{
    @IBInspectable var placeHolderColor: UIColor?
        {
        get {
            return self.placeHolderColor
        }
        set {
            self.attributedPlaceholder = NSAttributedString(string:self.placeholder != nil ? self.placeholder! : "", attributes:[NSAttributedString.Key.foregroundColor: newValue!])
        }
    }
}


extension NSMutableAttributedString
{
    func setColorForText(_ textToFind: String, with color: UIColor)
    {
        let range = self.mutableString.range(of: textToFind, options: .caseInsensitive)
        if range.location != NSNotFound
        {
            addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: range)
        }
    }
}


extension UIView
{
    // OUTPUT 1
    func dropShadow(scale: Bool = true)
    {
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
    func dropShadow(color: UIColor, opacity: Float = 0.5, offSet: CGSize, radius: CGFloat = 1, scale: Bool = true)
    {
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

extension UIView
{
    func roundCorners(_ corners:UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
}

extension UILabel
{
    func heightForLabel(text:String, font:UIFont, width:CGFloat) -> CGFloat
    {
        let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = font
        label.text = text
        
        label.sizeToFit()
        return label.frame.height
    }
    
}

extension Date
{
    func dateAt(hours: Int, minutes: Int) -> Date
    {
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

extension UITabBar
{
    override open func sizeThatFits(_ size: CGSize) -> CGSize
    {
        super.sizeThatFits(size)
        guard let window = UIApplication.shared.keyWindow else
        {
            return super.sizeThatFits(size)
        }
        var sizeThatFits = super.sizeThatFits(size)
        if #available(iOS 11.0, *)
        {
            sizeThatFits.height = window.safeAreaInsets.bottom + 40
        }
        else
        {
            sizeThatFits.height = 40
            // Fallback on earlier versions
        }
        return sizeThatFits
    }
}

extension UIApplication
{
    var statusBarView: UIView?
    {
        if responds(to: Selector(("statusBar")))
        {
            return value(forKey: "statusBar") as? UIView
        }
        return nil
    }
}

private var __maxLengths = [UITextField: Int]()
extension UITextField
{
    @IBInspectable var maxLength: Int
        {
        get {
            guard let l = __maxLengths[self] else
            {
                return 150 // (global default-limit. or just, Int.max)
            }
            return l
        }
        set {
            __maxLengths[self] = newValue
            addTarget(self, action: #selector(fix), for: .editingChanged)
        }
    }
    @objc func fix(textField: UITextField)
    {
        let t = textField.text
        textField.text = t?.safelyLimitedTo(length: maxLength)
    }
}

extension String
{
    func safelyLimitedTo(length n: Int)->String
    {
        if (self.count <= n)
        {
            return self
        }
        return String( Array(self).prefix(upTo: n) )
    }
}


