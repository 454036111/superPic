//
//  MoreVC.swift
//  SuperPicture
//
//  Created by lcy on 2017/11/17.
//  Copyright © 2017年 lcy. All rights reserved.
//

import UIKit

class MoreVC: UIViewController {
    
    var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        automaticallyAdjustsScrollViewInsets = false
        self.navigationItem.title = "更多"
        let back = UIBarButtonItem(title: "返回", style: .done, target: self, action: nil)
        self.navigationItem.backBarButtonItem = back
        loadTableView()
        // Do any additional setup after loading the view.
    }
    
    func loadTableView() {
        tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        view.addSubview(tableView)
        if #available(iOS 11, *) {
            tableView.snp.makeConstraints({ (make) in
                make.top.left.right.bottom.equalTo(self.view.safeAreaLayoutGuide)
            })
        } else {
            tableView.snp.makeConstraints({ (make) in
                make.top.equalTo(self.topLayoutGuide.snp.bottom)
                make.bottom.equalTo(self.bottomLayoutGuide.snp.top)
                make.left.right.equalTo(self.view)
            })
        }
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "moreCell")
        tableView.tableFooterView = UIView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension MoreVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
//        return 3
        return 1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return " "
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if section == 2 {
//            return 3
//        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "moreCell") as! UITableViewCell
        
        cell.accessoryType = .disclosureIndicator
        cell.textLabel?.text = "关于BQ-表情"
//        if indexPath.section == 0 {
//            cell.textLabel?.text = "推荐表情给好友"
//        } else if indexPath.section == 1 {
//            cell.textLabel?.text = "微信表情设置教程"
//        } else if indexPath.section == 2 {
//            if indexPath.item == 0 {
//                cell.textLabel?.text = "在App Store给表情评分"
//            } else if indexPath.item == 1 {
//                cell.textLabel?.text = "意见反馈"
//            }else if indexPath.item == 2 {
//                cell.textLabel?.text = "表情"
//            }
//        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = AboutVC()
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
//        if indexPath.section == 0 {
//            //TODO ShareSDK操作
////            cell.textLabel?.text = "推荐表情给好友"
//
//        } else if indexPath.section == 1 {
//            let web = TGWebViewController()
//            web.url = "https://mp.weixin.qq.com/s?__biz=MzI0OTE5Njk4Mg==&mid=504391570&idx=1&sn=2781b18c3bd9488ea646b2046722df70"
//            web.webTitle = "微信表情设置教程"
//            web.progressColor = UIColor.green
//            web.hidesBottomBarWhenPushed = true
//            self.navigationController?.pushViewController(web, animated: true)
////            cell.textLabel?.text = "微信表情设置教程"
//        } else if indexPath.section == 2 {
//            if indexPath.item == 0 {
////                cell.textLabel?.text = "在App Store给表情评分"
//            } else if indexPath.item == 1 {
////                cell.textLabel?.text = "意见反馈"
//            }else if indexPath.item == 2 {
////                cell.textLabel?.text = "表情"
//                let vc = AboutVC()
//                vc.hidesBottomBarWhenPushed = true
//                navigationController?.pushViewController(vc, animated: true)
//            }
//        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
