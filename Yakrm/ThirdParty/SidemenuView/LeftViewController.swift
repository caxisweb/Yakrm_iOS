//
//  LeftViewController.swift
//  LGSideMenuControllerDemo
//

class LeftViewController: UITableViewController
{
    var arrayMenuOptions = [Dictionary<String,String>]()

    private let titlesArray = ["Open Right View",
                               "",
                               "Change Root VC",
                               "",
                               "Profile",
                               "News",
                               "Articles",
                               "Video",
                               "Music"]
        
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
//        tableView.contentInset = UIEdgeInsets(top: 44.0, left: 0.0, bottom: 44.0, right: 0.0)
        
        self.updateArrayMenuOptions()
    }
    
    func updateArrayMenuOptions()
    {
        arrayMenuOptions.append(["title":"Welcome", "icon":""])
        arrayMenuOptions.append(["title":"Home", "icon":""])
        arrayMenuOptions.append(["title":"News", "icon":""])
        arrayMenuOptions.append(["title":"Videos", "icon":""])
        arrayMenuOptions.append(["title":"Adverticements", "icon":""])
        arrayMenuOptions.append(["title":"E Paper", "icon":""])
        arrayMenuOptions.append(["title":"Share App", "icon":""])
        arrayMenuOptions.append(["title":"Rate App", "icon":""])
        
        tableView.reloadData()
    }
    

//    override var prefersStatusBarHidden: Bool {
//        return true
//    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent//default
    }

//    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
//        return .fade
//    }
    
    // MARK: - UITableViewDataSource
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return arrayMenuOptions.count//titlesArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        var cell : SideMenuCell!
        cell = tableView.dequeueReusableCell(withIdentifier: "SideMenuCell") as! SideMenuCell?
        
        if cell == nil
        {
            if indexPath.row == 0
            {
                cell = Bundle.main.loadNibNamed("SideMenuCell", owner: self, options: nil)?[0] as! SideMenuCell
                
                cell.lblName.text = arrayMenuOptions[indexPath.row]["title"]!
                cell.selectionStyle = .none
            }
            else
            {
                cell = Bundle.main.loadNibNamed("SideMenuCell", owner: self, options: nil)?[1] as! SideMenuCell
                cell.lblName.text = arrayMenuOptions[indexPath.row]["title"]!
                
                cell.selectionStyle = .default
            }
        }
        
        tableView.rowHeight = cell.frame.size.height
        return cell
    }
//    {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! LeftViewCell
//
//        cell.titleLabel.text = titlesArray[indexPath.row]
//        cell.separatorView.isHidden = (indexPath.row <= 3 || indexPath.row == self.titlesArray.count-1)
//        cell.isUserInteractionEnabled = (indexPath.row != 1 && indexPath.row != 3)
//
//        return cell
//    }
    
    // MARK: - UITableViewDelegate
    
//    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return (indexPath.row == 1 || indexPath.row == 3) ? 22.0 : 44.0
//    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let mainViewController = sideMenuController!
        
        let navigationController = mainViewController.rootViewController as! NavigationController
        let viewController: UIViewController!
        
        viewController = self.storyboard!.instantiateViewController(withIdentifier: "ViewController")
        
        navigationController.setViewControllers([viewController], animated: false)
        
        // Rarely you can get some visual bugs when you change view hierarchy and toggle side views in the same iteration
        // You can use delay to avoid this and probably other unexpected visual bugs
        mainViewController.hideLeftView(animated: true, delay: 0.0, completionHandler: nil)
        
        
        /*
        if indexPath.row == 0
        {
            if mainViewController.isLeftViewAlwaysVisibleForCurrentOrientation
            {
                mainViewController.showRightView(animated: true, completionHandler: nil)
            }
            else
            {
                mainViewController.hideLeftView(animated: true, completionHandler: {
                    mainViewController.showRightView(animated: true, completionHandler: nil)
                })
            }
        }
        else if indexPath.row == 2
        {
            let navigationController = mainViewController.rootViewController as! NavigationController
            let viewController: UIViewController!

            if navigationController.viewControllers.first is ViewController
            {
                viewController = self.storyboard!.instantiateViewController(withIdentifier: "OtherViewController")
            }
            else
            {
                viewController = self.storyboard!.instantiateViewController(withIdentifier: "ViewController")
            }

            navigationController.setViewControllers([viewController], animated: false)

            // Rarely you can get some visual bugs when you change view hierarchy and toggle side views in the same iteration
            // You can use delay to avoid this and probably other unexpected visual bugs
            mainViewController.hideLeftView(animated: true, delay: 0.0, completionHandler: nil)
        }
        else
        {
            let viewController = UIViewController()
            viewController.view.backgroundColor = .white
            viewController.title = "Test \(titlesArray[indexPath.row])"

            let navigationController = mainViewController.rootViewController as! NavigationController
            navigationController.pushViewController(viewController, animated: true)
            
            mainViewController.hideLeftView(animated: true, completionHandler: nil)
        }
 */
    }
    
}
