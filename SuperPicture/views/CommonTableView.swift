//
//  CommonTableView.swift
//  SuperPicture
//
//  Created by lcy on 2017/11/17.
//  Copyright © 2017年 lcy. All rights reserved.
//

import UIKit

class CommonTableView: UITableView {
    var picDataSource: [PackageModel]! {
        didSet {
            hasNoDataLabel.removeFromSuperview()
            if picDataSource.count == 0 {
                self.addSubview(hasNoDataLabel)
                hasNoDataLabel.snp.makeConstraints({ (make) in
                    make.center.equalTo(self.snp.center)
                })
            }
        }
    }
    var hasNoDataLabel: UILabel = UILabel()
    
    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        buildTableView()
        self.tableFooterView = UIView()
    }
    fileprivate func buildTableView() {
        self.delegate = self
        self.dataSource = self
        register(UINib(nibName: "PackageCell", bundle: nil), forCellReuseIdentifier: "PackageCell")
            hasNoDataLabel.text = "暂无收藏"
            hasNoDataLabel.textColor = UIColor.lightGray

    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        buildTableView()
        self.tableFooterView = UIView()
    }
    
}

extension CommonTableView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let picDataSource = picDataSource {
            
        } else {
            return 0
        }
        return picDataSource.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PackageCell") as! PackageCell
        let sUrlString = picDataSource[indexPath.item].picList?.first!
        let picUrlStr = "http://ww4.sinaimg.cn/thumb300/\(sUrlString!)"
        cell.img.sd_setImage(with: URL(string: picUrlStr), completed: nil)
        cell.packageName.text = picDataSource[indexPath.item].name!
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = PackageSelectedVC()
        vc.dataSource = picDataSource[indexPath.item].toSingles()
        vc.packageStr = picDataSource[indexPath.item].name
        vc.pics = picDataSource[indexPath.item].toPicListStr()
        vc.hidesBottomBarWhenPushed = true
        self.currentNav().pushViewController(vc, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}


extension UIView {
    func currentNav() -> UINavigationController {
        let vc = viewForNavController(view: self)
        return vc!
    }
    
    private func viewForNavController(view:UIView)->UINavigationController?{
        var next:UIView? = view
        repeat{
            if let nextResponder = next?.next, nextResponder is UIViewController {
                let vc = (nextResponder as! UIViewController)
                if let nav = vc.navigationController {
                    return nav
                }
            }
            next = next?.superview
        }while next != nil
        return nil
    }
}

