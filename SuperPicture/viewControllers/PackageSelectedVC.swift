//
//  PackageSelectedVC.swift
//  SuperPicture
//
//  Created by lcy on 2017/11/20.
//  Copyright © 2017年 lcy. All rights reserved.
//

import UIKit

class PackageSelectedVC: UIViewController {
    
    var topView: UIView!
    var packageSelectBtn: UIButton!
    var collectionView: CommonCollectionView!
    var dataSource: [SinglePicModel]!
    var packageStr: String?
    var pics: String?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        let back = UIBarButtonItem(title: "返回", style: .done, target: self, action: nil)
        self.navigationItem.backBarButtonItem = back

        buildTopView()
        buildCollectionView()
        // Do any additional setup after loading the view.
    }
    
    func buildTopView() {
        topView = UIView()
        
        self.view.addSubview(topView)
        
        if #available(iOS 11, *) {
            topView.snp.makeConstraints { (make) in
                make.top.left.right.equalTo(self.view.safeAreaLayoutGuide)
                make.height.equalTo(50)
            }
        } else {
            topView.snp.makeConstraints { (make) in
                make.top.equalTo(self.topLayoutGuide.snp.bottom)
                make.left.right.equalTo(self.view)
                make.height.equalTo(50)
            }
        }
        
        let packageName = UILabel()
        packageName.text = packageStr!
        topView.addSubview(packageName)
        packageName.snp.makeConstraints { (make) in
            make.centerY.equalTo(topView)
            make.left.equalTo(10)
        }
        
        packageSelectBtn = UIButton()
        packageSelectBtn.setTitleColor(UIColor.black, for: .normal)
        packageSelectBtn.backgroundColor = UIColor(red: 252/255, green: 211/255, blue: 67/255, alpha: 1)
        packageSelectBtn.layer.cornerRadius = 3
        packageSelectBtn.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        packageSelectBtn.addTarget(self, action: #selector(collect(gesture:)), for: .touchUpInside)
//            Bundle.main.loadNibNamed("PackageCollectBtn", owner: self, options: nil)?.first as! PackageCollectBtn
        
        topView.addSubview(packageSelectBtn)
        packageSelectBtn.snp.makeConstraints { (make) in
            make.centerY.equalTo(topView)
            make.width.equalTo(100)
            make.height.equalTo(30)
            make.right.equalTo(-10)
        }
        updateCollectBtnState()
        
        let cutLine = UIImageView(image: #imageLiteral(resourceName: "dotline"))
        view.addSubview(cutLine)
        cutLine.snp.makeConstraints { (make) in
            make.height.equalTo(5)
            make.left.equalTo(10)
            make.right.equalTo(-10)
            make.bottom.equalTo(topView.snp.bottom)
        }
    }
    
    func buildCollectionView() {
        collectionView = CommonCollectionView()
        collectionView.dataSource1 = dataSource
        self.view.addSubview(collectionView)
        if #available(iOS 11, *) {
            collectionView.snp.makeConstraints({ (make) in
                make.top.equalTo(self.topView.snp.bottom).offset(1)
                make.left.right.equalTo(self.view)
                make.bottom.equalTo(self.view.safeAreaLayoutGuide)
            })
        } else {
            collectionView.snp.makeConstraints({ (make) in
                make.top.equalTo(self.topView.snp.bottom).offset(1)
                make.left.right.bottom.equalTo(self.view)
            })
        }

    }
    
    //收藏或取消收藏
    @objc func collect(gesture: UITapGestureRecognizer) {
        
        if(DBOperator.sharedInstance.document.checkCachePackage(packageName: packageStr!)) {
            //
            DBOperator.sharedInstance.document.removeCachePackage(packageName: packageStr!)
        } else {
            DBOperator.sharedInstance.document.insertCachePackage(packageName: packageStr!,pics: pics!)
        }
        updateCollectBtnState()
    }
    
    func updateCollectBtnState() {
        if(DBOperator.sharedInstance.document.checkCachePackage(packageName: packageStr!)) {
            //
            packageSelectBtn.setTitle("❤ 已收藏", for: .normal)
        } else {
            packageSelectBtn.setTitle("♡ 收藏表情包", for: .normal)
        }
        packageSelectBtn.layoutIfNeeded()
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
