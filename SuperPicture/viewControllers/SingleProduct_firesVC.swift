//
//  SingleProduct_firesVC.swift
//  SuperPicture
//
//  Created by lcy on 2017/11/16.
//  Copyright © 2017年 lcy. All rights reserved.
//

import UIKit
import SnapKit

class SingleProduct_firesVC: UIViewController {
    var collectionView: CommonCollectionView!
    var dataSource: [SinglePicModel]!

    override func viewDidLoad() {
        super.viewDidLoad()
        let back = UIBarButtonItem(title: "返回", style: .done, target: self, action: nil)
        self.navigationItem.backBarButtonItem = back

        buildCollectionView()
//        sharedInstance.local.querySingle()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if #available(iOS 11, *) {
            //            navigationItem.largeTitleDisplayMode = .never
//            navigationController?.navigationBar.prefersLargeTitles = true
        } else {
            
        }

    }
    func buildCollectionView() {
        collectionView = CommonCollectionView()
        collectionView.dataSource1 = dataSource
        self.view.addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

