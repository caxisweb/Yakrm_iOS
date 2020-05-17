//
//  BaseViewController.swift
//  Itext2pay
//
//  Created by Gaurav Parmar on 04/12/16.
//  Copyright © 2016 Developer. All rights reserved.
//

import UIKit

extension NSObject {
    static var className: String {
        get {
            return String(describing: self)
        }
    }
}

@available(iOS 11.0, *)
class BaseViewController: UIViewController, SlideMenuDelegate {

    var app = AppDelegate()
    override func viewDidLoad() {
        super.viewDidLoad()
        app = UIApplication.shared.delegate as! AppDelegate

    }

    func slideMenuItemSelectedAtIndex(_ index: Int32) {
        let topViewController: UIViewController = self.navigationController!.topViewController!
        print("View Controller is : \(topViewController) \n", terminator: "")

        if self.app.strUserType == "S" {
            switch index {
            case 0:
                break
                //            self.openViewControllerBasedOnIdentifier("HomeView")

            case 1:
                self.openViewControllerBasedOnIdentifier("DashboardView")
                break

            case 2:
                self.openViewControllerBasedOnIdentifier("SellerProfileView")
                break

            case 3:
                self.openViewControllerBasedOnIdentifier("AddDishView")
                break

            case 4:
                self.openViewControllerBasedOnIdentifier("MyOrderListView")
                break

            case 5:
                self.openViewControllerBasedOnIdentifier("DemandRequestView")
                break

            case 6:

                let alertController = UIAlertController(title: "Are you sure You want to Logout ?", message: nil, preferredStyle: .alert)

                let cancelAction = UIAlertAction(title: "Cancel", style: .default) { (_: UIAlertAction!) in
                    print("you have pressed the Cancel button")
                }
                alertController.addAction(cancelAction)

                let OKAction = UIAlertAction(title: "Logout", style: .destructive) { (_: UIAlertAction!) in
                    print("you have pressed OK button")

                    let defaults = UserDefaults.standard
                    defaults.removeObject(forKey: "user_id")

                    defaults.synchronize()
                    self.openViewControllerBasedOnIdentifier("ViewController")
                }
                alertController.addAction(OKAction)

                self.present(alertController, animated: true, completion: nil)

            default:
                print("default\n", terminator: "")
            }
        } else {
            switch index {
            case 0:
                //            self.openViewControllerBasedOnIdentifier("HomeView")
                break

            case 1:
                self.openViewControllerBasedOnIdentifier("HomeView")
                break

            case 2:
                self.openViewControllerBasedOnIdentifier("MyProfileView")
                break

            case 3:
                self.openViewControllerBasedOnIdentifier("OrderDishView")
                break

            case 4:
                self.openViewControllerBasedOnIdentifier("OrderListView")
                break

            case 5:

                let alertController = UIAlertController(title: "Are you sure You want to Logout ?", message: nil, preferredStyle: .alert)

                let cancelAction = UIAlertAction(title: "Cancel", style: .default) { (_: UIAlertAction!) in
                    print("you have pressed the Cancel button")
                }
                alertController.addAction(cancelAction)

                let OKAction = UIAlertAction(title: "Logout", style: .destructive) { (_: UIAlertAction!) in
                    print("you have pressed OK button")

                    let defaults = UserDefaults.standard
                    defaults.removeObject(forKey: "user_id")

                    defaults.synchronize()
                    self.openViewControllerBasedOnIdentifier("ViewController")
                }
                alertController.addAction(OKAction)

                self.present(alertController, animated: true, completion: nil)

            default:
                print("default\n", terminator: "")
            }
        }
    }

    func openViewControllerBasedOnIdentifier(_ strIdentifier: String) {
        let destViewController: UIViewController = self.storyboard!.instantiateViewController(withIdentifier: strIdentifier)
        let topViewController: UIViewController = self.navigationController!.topViewController!
        let strFinal: String = String(describing: topViewController)

        if strFinal.range(of: strIdentifier) != nil {
            print("Same VC")
        } else {
            self.navigationController!.pushViewController(destViewController, animated: true)
        }
    }

    func addSlideMenuButton() {
        let btnShowMenu = UIButton(type: UIButton.ButtonType.system)
        btnShowMenu.setImage(self.defaultMenuImage(), for: UIControl.State())
        btnShowMenu.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        btnShowMenu.addTarget(self, action: #selector(BaseViewController.onSlideMenuButtonPressed(_:)), for: UIControl.Event.touchUpInside)
        let customBarItem = UIBarButtonItem(customView: btnShowMenu)
        self.navigationItem.leftBarButtonItem = customBarItem
    }

    func defaultMenuImage() -> UIImage {
        var defaultMenuImage = UIImage()

        defaultMenuImage = UIImage(named: "menu.png")!

        return defaultMenuImage
    }

    @objc func onSlideMenuButtonPressed(_ sender: UIButton) {
        if sender.tag == 10 {
            // To Hide Menu If it already there
            self.slideMenuItemSelectedAtIndex(-1)

            sender.tag = 0

            let viewMenuBack: UIView = view.subviews.last!

            UIView.animate(withDuration: 0.3, animations: { () -> Void in
                var frameMenu: CGRect = viewMenuBack.frame
                frameMenu.origin.x = -1 * UIScreen.main.bounds.size.width
                viewMenuBack.frame = frameMenu
                viewMenuBack.layoutIfNeeded()
                viewMenuBack.backgroundColor = UIColor.clear
            }, completion: { (_) -> Void in
                viewMenuBack.removeFromSuperview()
            })

            return
        }

        sender.isEnabled = false
        sender.tag = 10

        let menuVC: MenuViewController = self.storyboard!.instantiateViewController(withIdentifier: "MenuViewController") as! MenuViewController
        menuVC.btnMenu = sender
        menuVC.delegate = self
        self.view.addSubview(menuVC.view)
        self.addChild(menuVC)
        menuVC.view.layoutIfNeeded()

        menuVC.view.frame=CGRect(x: 0 - UIScreen.main.bounds.size.width, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)

        UIView.animate(withDuration: 0.3, animations: { () -> Void in
            menuVC.view.frame=CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
            sender.isEnabled = true
        }, completion: nil)
    }

}
