//
//  CommonCollectionView.swift
//  SuperPicture
//
//  Created by lcy on 2017/11/16.
//  Copyright © 2017年 lcy. All rights reserved.
//

import UIKit

class CommonCollectionView: UICollectionView {
    var dataSource1: [SinglePicModel]! {
        didSet {
            hasNoDataLabel.removeFromSuperview()
            if dataSource1.count == 0 {
                self.addSubview(hasNoDataLabel)
                hasNoDataLabel.snp.makeConstraints({ (make) in
                    make.center.equalTo(self.snp.center)
                })
            }
        }
    }
    var hasNoDataLabel: UILabel = UILabel()
    init() {
        super.init(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())
        hasNoDataLabel.text = "暂无收藏"
        hasNoDataLabel.textColor = UIColor.lightGray
        let layout = self.collectionViewLayout as! UICollectionViewFlowLayout
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 9
        let itemLegth = ((UIApplication.shared.keyWindow?.frame.width)! - 20 - 20) / 3
        layout.itemSize = CGSize(width: itemLegth , height: itemLegth)
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 0, right: 10)

        self.delegate = self
        self.dataSource = self
        self.backgroundColor = UIColor.white
        self.register(UINib(nibName: "CollectionPicCell", bundle: nil), forCellWithReuseIdentifier: "picCell")
//        dataSource1 = DBOperator.sharedInstance.local.querySingle()


    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension CommonCollectionView: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource1.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "picCell", for: indexPath) as! CollectionPicCell
        let picUrlStr = "http://ww4.sinaimg.cn/thumb300/\(dataSource1[indexPath.item].picUrl!)"
        cell.pic.sd_setImage(with: URL(string: picUrlStr), placeholderImage: nil, options: .refreshCached, completed: nil)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc1 = DetailVC()
        vc1.dataSource = dataSource1
        vc1.selectedPicModel = dataSource1[indexPath.item]
        vc1.hidesBottomBarWhenPushed = true
        currentNav().pushViewController(vc1, animated: true)
//        let nav = UIApplication.shared.keyWindow?.rootViewController
//        (nav?.childViewControllers.first as! UINavigationController).pushViewController(vc1, animated: true)
    }
}
