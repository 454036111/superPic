//
//  NavigationVC.swift
//  SuperPicture
//
//  Created by lcy on 2017/11/16.
//  Copyright © 2017年 lcy. All rights reserved.
//

import UIKit

class NavigationVC: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBar.barTintColor = UIColor(red: 252/255, green: 211/255, blue: 67/255, alpha: 1)
        navigationItem.backBarButtonItem?.tintColor = UIColor.darkGray
        if #available(iOS 11, *) {
//            navigationBar.prefersLargeTitles = false
//            navigationItem.largeTitleDisplayMode = .never
        } else {
            
        }
//        navigationBar.barTintColor = UIColor.red
        // Do any additional setup after loading the view.
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
