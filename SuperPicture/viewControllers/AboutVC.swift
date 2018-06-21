//
//  AboutVC.swift
//  SuperPicture
//
//  Created by lcy on 2017/11/21.
//  Copyright © 2017年 lcy. All rights reserved.
//

import UIKit

class AboutVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "关于BQ-使用送大礼"
        let aboutView = Bundle.main.loadNibNamed("AboutView", owner: self, options: nil)?.first as! UIView
        
        view.addSubview(aboutView)
        if #available(iOS 11, *) {
            aboutView.snp.makeConstraints({ (make) in
                make.edges.equalTo(self.view.safeAreaLayoutGuide)
            })
        } else {
            aboutView.snp.makeConstraints({ (make) in
                make.top.equalTo(self.topLayoutGuide.snp.bottom)
                make.bottom.equalTo(self.bottomLayoutGuide.snp.bottom)
                make.left.right.equalTo(self.view)
            })
        }
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
