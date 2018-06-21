//
//  SingleProductVC.swift
//  SuperPicture
//
//  Created by lcy on 2017/11/8.
//  Copyright © 2017年 lcy. All rights reserved.
//

import UIKit
import HMSegmentedControl
import SnapKit

class SingleProductVC: UIViewController {
    
    var segmentedControl: HMSegmentedControl!
    var scrollView: UIScrollView!
    override func viewDidLoad() {
        super.viewDidLoad()
        buildSegment()
        buildScrollView()
        view.backgroundColor = UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1)
        self.navigationItem.title = "超级单品"
        let back = UIBarButtonItem(title: "返回", style: .done, target: self, action: nil)
        self.navigationItem.backBarButtonItem = back
//        self.navigationController?.navigationItem.title = "超级表情"
        if #available(iOS 11, *) {
//            navigationItem.largeTitleDisplayMode = .never
        } else {
            
        }
        
//        DBOperator.sharedInstance.query(sql: "select * from PackageList", values: nil) { (rs) in
//            while rs.next() {
//                let name = rs.string(forColumn: "Name");
//                let url = rs.string(forColumn: "Singles");
//                print("\(name)-----\(url)")
//            }
//        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        scrollView.contentSize = CGSize(width: self.scrollView.frame.width * 2, height: self.scrollView.frame.height)
        scrollView.layoutIfNeeded()
    }
    
    func buildSegment() {
        view.layoutIfNeeded()
        segmentedControl = HMSegmentedControl()
        self.view.addSubview(segmentedControl)
        if #available(iOS 11, *) {
            navigationController?.navigationBar.prefersLargeTitles = true
            segmentedControl.snp.makeConstraints({ (make) in
//                make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
//                make.right.equalTo(self.view.safeAreaLayoutGuide.snp.rightMargin)
//                make.left.equalTo(self.view.safeAreaLayoutGuide.snp.leftMargin)
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

        segmentedControl.sectionTitles = ["最热", "最新"]
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
            navigationController?.navigationBar.prefersLargeTitles = true
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
        let vc1 = SingleProduct_firesVC()
        vc1.dataSource = DBOperator.sharedInstance.local.querySingle()
        addChildViewController(vc1)
        let v1 = vc1.view!
        v1.frame = CGRect(x: 0, y: 0, width: scrollView.frame.width, height: scrollView.frame.height)
        let vc2 = SingleProduct_firesVC()
        let reversedDataSource = Array(DBOperator.sharedInstance.local.querySingle().reversed())
        vc2.dataSource = reversedDataSource
        vc2.view.frame = CGRect(x: scrollView.frame.width, y: 0, width: scrollView.frame.width, height: scrollView.frame.height)
        
        scrollView.addSubview(v1)
        scrollView.addSubview(vc2.view);
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension SingleProductVC: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageWidth = scrollView.frame.size.width;
        let page = scrollView.contentOffset.x / pageWidth;
        segmentedControl.setSelectedSegmentIndex(UInt(page), animated: true)
    }
}

