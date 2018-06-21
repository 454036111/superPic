//
//  PackageVC.swift
//  SuperPicture
//
//  Created by lcy on 2017/11/17.
//  Copyright © 2017年 lcy. All rights reserved.
//

import UIKit

class PackageVC: UIViewController {
    var tableView: CommonTableView!
    var picDataSource: [PackageModel]!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "表情包"
        let back = UIBarButtonItem(title: "返回", style: .done, target: self, action: nil)
        self.navigationItem.backBarButtonItem = back

        automaticallyAdjustsScrollViewInsets = false
        tableView = CommonTableView()
        view.addSubview(tableView)
        tableView.picDataSource = picDataSource
//            DBOperator.sharedInstance.local.queryPackage()
        if #available(iOS 11, *) {
            tableView.snp.makeConstraints({ (make) in
                make.edges.equalTo(self.view.safeAreaLayoutGuide)
            })
        } else {
            tableView.snp.makeConstraints({ (make) in
                make.top.equalTo(topLayoutGuide.snp.bottom)
                make.left.right.equalTo(self.view)
                make.bottom.equalTo(bottomLayoutGuide.snp.top)
            })

        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


