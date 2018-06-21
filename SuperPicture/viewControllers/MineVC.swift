//
//  MineVC.swift
//  SuperPicture
//
//  Created by lcy on 2017/11/17.
//  Copyright © 2017年 lcy. All rights reserved.
//

import UIKit
import HMSegmentedControl

class MineVC: UIViewController {
    var segmentedControl: HMSegmentedControl!
    var scrollView: UIScrollView!
    var vc1: SingleProduct_firesVC!
    var vc2: PackageVC!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "我的"
        let back = UIBarButtonItem(title: "返回", style: .done, target: self, action: nil)
        self.navigationItem.backBarButtonItem = back
        if #available(iOS 11.0, *) {
            navigationController?.navigationBar.prefersLargeTitles = false
        } else {
            // Fallback on earlier versions
        }
        buildSegment()
        buildScrollView()
        // Do any additional setup after loading the view.
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        scrollView.contentSize = CGSize(width: self.scrollView.frame.width * 2, height: self.scrollView.frame.height)
        scrollView.layoutIfNeeded()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //取消收藏要重新刷新
        vc1.collectionView.dataSource1 = DBOperator.sharedInstance.document.queryCacheSingle()
        vc1.collectionView.reloadData()
        vc2.tableView.picDataSource = DBOperator.sharedInstance.document.queryCachePackage()
        vc2.tableView.reloadData()
    }
    
    func buildSegment() {
        view.layoutIfNeeded()
        segmentedControl = HMSegmentedControl()
        self.view.addSubview(segmentedControl)
        if #available(iOS 11, *) {
            segmentedControl.snp.makeConstraints({ (make) in
                make.top.left.right.equalTo(self.view.safeAreaLayoutGuide)
                make.height.equalTo(35)
            })
        } else {
            segmentedControl.snp.makeConstraints({ (make) in
                make.top.equalTo(self.topLayoutGuide.snp.bottom)
                make.left.right.equalTo(self.view)
                make.height.equalTo(35)
            })
        }
        
        segmentedControl.sectionTitles = ["单品", "表情包"]
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.backgroundColor = UIColor(red: 239/255, green: 239/255, blue: 239/255, alpha: 1)
        segmentedControl.selectionIndicatorColor = UIColor.darkGray
        segmentedControl.selectionIndicatorHeight = 2
        segmentedControl.selectionStyle = .fullWidthStripe
        segmentedControl.selectionIndicatorLocation = .down
        segmentedControl.indexChangeBlock = { [weak self] index in
            guard let weakSelf = self else {
                return
            }
            weakSelf.scrollView.scrollRectToVisible(CGRect(x: (weakSelf.view.frame.width) * CGFloat(index), y: 0, width: (weakSelf.view.frame.width), height: (weakSelf.scrollView.frame.height))
                , animated: true)
        }
    }
    
    func buildScrollView() {
        scrollView = UIScrollView()
        scrollView.bounces = false
        view.addSubview(scrollView)
        if #available(iOS 11, *) {
            scrollView.snp.makeConstraints({ (make) in
                make.left.right.bottom.equalTo(self.view.safeAreaLayoutGuide)
                make.top.equalTo(segmentedControl.snp.bottom)
            })
        } else {
            scrollView.snp.makeConstraints({ (make) in
                make.left.right.equalTo(self.view)
                make.bottom.equalTo(self.bottomLayoutGuide.snp.top)
                make.top.equalTo(segmentedControl.snp.bottom)
            })
        }
        
        scrollView.layoutIfNeeded()
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.delegate = self
        scrollView.scrollRectToVisible(CGRect(x: 0, y: 0, width: scrollView.frame.width, height: scrollView.frame.height), animated: false)
        scrollView.contentSize = CGSize(width: self.scrollView.frame.width * 2, height: self.scrollView.frame.height)
        vc1 = SingleProduct_firesVC()
        vc1.dataSource = DBOperator.sharedInstance.document.queryCacheSingle()
        addChildViewController(vc1)
        let v1 = vc1.view!
        v1.frame = CGRect(x: 0, y: 0, width: scrollView.frame.width, height: scrollView.frame.height)
        vc2 = PackageVC()
        vc2.picDataSource = DBOperator.sharedInstance.document.queryCachePackage()
        vc2.view.frame = CGRect(x: scrollView.frame.width, y: 0, width: scrollView.frame.width, height: scrollView.frame.height)
        scrollView.addSubview(v1)
        scrollView.addSubview(vc2.view);
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

extension MineVC: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageWidth = scrollView.frame.size.width;
        let page = scrollView.contentOffset.x / pageWidth;
        segmentedControl.setSelectedSegmentIndex(UInt(page), animated: true)
    }
}

