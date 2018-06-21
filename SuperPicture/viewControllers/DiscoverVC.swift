//
//  DiscoverVC.swift
//  SuperPicture
//
//  Created by lcy on 2017/11/17.
//  Copyright © 2017年 lcy. All rights reserved.
//

import UIKit

class DiscoverVC: UIViewController {
    var discoverView: DiscoverView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        discoverView = Bundle.main.loadNibNamed("DiscoverView", owner: self, options: nil)?.first as! DiscoverView
        view.addSubview(discoverView)
        if #available(iOS 11, *) {
            discoverView.snp.makeConstraints({ (make) in
                make.top.left.right.equalTo(self.view.safeAreaLayoutGuide)
                make.height.equalTo(100)
            })
        } else {
            discoverView.snp.makeConstraints({ (make) in
                make.top.equalTo(self.topLayoutGuide.snp.bottom)
                make.left.right.equalTo(self.view)
                make.height.equalTo(100)
            })
        }
        discoverView.newPic.addOnClickListener(target: self, action: #selector(newPicClick(gesture:)))
        discoverView.newVidio.addOnClickListener(target: self, action: #selector(newPicClick(gesture:)))
        discoverView.newJoke.addOnClickListener(target: self, action: #selector(newPicClick(gesture:)))
        self.navigationItem.title = "发现"
        let back = UIBarButtonItem(title: "返回", style: .done, target: self, action: nil)
        self.navigationItem.backBarButtonItem = back
        
    }
    @objc func newPicClick(gesture: UITapGestureRecognizer) {
        let tag = gesture.view?.tag
        let web = TGWebViewController()
        switch tag! {
        case 1:
            web.url = "http://m.budejie.com/new/pic/"
            web.webTitle = "爆笑图片"
        case 2:
            web.url = "http://m.budejie.com/new/video/"
            web.webTitle = "搞笑视频"
        case 3:
            web.url = "http://m.budejie.com/new/text/"
            web.webTitle = "最新笑话"
        default:
            break
        }
        
        web.progressColor = UIColor.green
        web.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(web, animated: true)
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
