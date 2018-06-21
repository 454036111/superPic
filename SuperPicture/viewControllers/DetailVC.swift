//
//  DetailVC.swift
//  SuperPicture
//
//  Created by lcy on 2017/11/17.
//  Copyright © 2017年 lcy. All rights reserved.
//

import UIKit

class DetailVC: UIViewController {
    var titleCollectionView: UICollectionView!
    var largeImg: FLAnimatedImageView!
    var dataSource: [SinglePicModel]!
    var selectedPicModel: SinglePicModel!
    var selectedIndex: IndexPath!
    var shareBtnsView: ShareBtnsView!
    
    //四个按钮
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        buildTitleCollectionView()
        buildLargeImg()
        self.automaticallyAdjustsScrollViewInsets = false
        buildshare()
        navigationItem.title = "超级表情"
        let back = UIBarButtonItem(title: "返回", style: .done, target: self, action: nil)
        self.navigationItem.backBarButtonItem = back

        if #available(iOS 11.0, *) {
//            navigationController?.navigationBar.prefersLargeTitles = false
        } else {
            // Fallback on earlier versions
        }
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        titleCollectionView.layoutIfNeeded()
        titleCollectionView.scrollToItem(at: selectedIndex, at: .centeredHorizontally, animated: false)
    }
    
//    override func viewDidAppear(_ animated: Bool) {
//        titleCollectionView.scrollToItem(at: selectedIndex, at: .centeredHorizontally, animated: false)
//    }
    
    func buildTitleCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 70, height: 75)
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .horizontal
        titleCollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        titleCollectionView.backgroundColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1)
        titleCollectionView.delegate = self
        titleCollectionView.dataSource = self
        titleCollectionView.register(UINib(nibName: "CollectionDetailCell", bundle: nil), forCellWithReuseIdentifier: "CollectionDetailCell")
        let index = dataSource.index(of: selectedPicModel)
        selectedIndex = IndexPath(item: index!, section: 0)
        view.addSubview(titleCollectionView)
        if #available(iOS 11, *) {
            titleCollectionView.snp.makeConstraints({ (make) in
                make.top.equalTo(self.view.safeAreaLayoutGuide)
                make.left.right.equalTo(self.view)
                make.height.equalTo(75)
            })
        } else {
            titleCollectionView.snp.makeConstraints({ (make) in
                make.top.equalTo(self.topLayoutGuide.snp.bottom)
                make.left.right.equalTo(self.view)
                make.height.equalTo(75)
            })
        }
    }
    
    func buildLargeImg() {
        largeImg = FLAnimatedImageView()
        self.view.addSubview(largeImg)
        largeImg.snp.makeConstraints { (make) in
            make.top.equalTo(titleCollectionView.snp.bottom).offset(20)
            make.centerX.equalTo(self.view)
            make.width.height.equalTo(150)
        }
        largeImg.backgroundColor = UIColor.groupTableViewBackground
        let picUrlStr = "http://ww4.sinaimg.cn/large/\(selectedPicModel.picUrl!)"
        largeImg.sd_setImage(with: URL(string: picUrlStr), placeholderImage: nil, options: .refreshCached, completed: nil)
        let tabGesture = UITapGestureRecognizer(target: self, action: #selector(share(gesture:)))
        largeImg.addGestureRecognizer(tabGesture)
        largeImg.isUserInteractionEnabled = true
    }
    
    func buildshare() {
        //分割线
        let cutLine = UIImageView()
        view.addSubview(cutLine)
        cutLine.image = UIImage(named: "dotCenterEmptyline")
        cutLine.snp.makeConstraints { (make) in
            make.top.equalTo(largeImg.snp.bottom).offset(20)
            make.left.equalTo(self.view).offset(10)
            make.right.equalTo(self.view).offset(-10)
            make.height.equalTo(10)
        }
        let text = UITextView()
        text.text = "使用"
        text.textAlignment = .center
        view.addSubview(text)
        text.snp.makeConstraints { (make) in
            make.center.equalTo(cutLine.snp.center)
            make.width.equalTo(40)
            make.height.equalTo(30)
        }
        //四个按钮
        
        shareBtnsView = Bundle.main.loadNibNamed("ShareBtnsView", owner: self, options: nil)?.first as! ShareBtnsView
        view.addSubview(shareBtnsView)
        shareBtnsView.snp.makeConstraints { (make) in
            make.top.equalTo(text.snp.bottom).offset(10)
            make.left.equalTo(self.view).offset(20)
            make.right.equalTo(self.view).offset(-20)
            make.height.equalTo(60)
        }
        updateCollectBtnState()
        
        shareBtnsView.collectBtn.addOnClickListener(target: self, action: #selector(collect(gesture:)))
        shareBtnsView.wechartBtn.addOnClickListener(target: self, action: #selector(share(gesture:)))
        shareBtnsView.qqBtn.addOnClickListener(target: self, action: #selector(share(gesture:)))
        shareBtnsView.moreBtn.addOnClickListener(target: self, action: #selector(share(gesture:)))
        
    }
    
    @objc func share(gesture: UITapGestureRecognizer) {
        let tag = gesture.view?.tag
        var type: SSDKPlatformType = .typeQQ
        switch tag! {
        case 2:
            type = SSDKPlatformType.typeWechat
        case 3:
            type = SSDKPlatformType.typeQQ
        case 4:
            UIImageWriteToSavedPhotosAlbum(largeImg.image!, self, #selector(image(image:didFinishSavingWithError:contextInfo:)), nil)
            return
        default:
            break
        }
        
        // 1.创建分享参数
        let shareParames = NSMutableDictionary()
        shareParames.ssdkSetupShareParams(byText: "分享内容",
                                          images : largeImg.image,
                                          url : NSURL(string:"http://ww4.sinaimg.cn/large/\(selectedPicModel.picUrl!)") as URL!,
                                          title : "分享标题",
                                          type : SSDKContentType.image)
        
        //2.进行分享
        ShareSDK.share(type, parameters: shareParames) { (state : SSDKResponseState, nil, entity : SSDKContentEntity?, error :Error?) in
            
            switch state{
                
            case SSDKResponseState.success: print("分享成功")
            case SSDKResponseState.fail:    print("授权失败,错误描述:\(error)")
            case SSDKResponseState.cancel:  print("操作取消")
                
            default:
                break
            }
            
        }
    }
    
    @objc func image(image:UIImage,didFinishSavingWithError error:NSError?,contextInfo:AnyObject) {
        if error != nil
        {
            print("error!")
            return
        } else {
            let alert = UIAlertController(title: nil, message: "已保存至本地相册", preferredStyle: .alert)
            let action = UIAlertAction(title: "确定", style: .cancel, handler: nil)
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
        }
    }
    //收藏或取消收藏
    @objc func collect(gesture: UITapGestureRecognizer) {
        
        if(DBOperator.sharedInstance.document.checkCachePic(imgUrl: selectedPicModel.picUrl!)) {
            //
            DBOperator.sharedInstance.document.removeCachePic(imgUrl: selectedPicModel.picUrl!)
        } else {
            DBOperator.sharedInstance.document.insertCachePic(imgUrl: selectedPicModel.picUrl!)
        }
        updateCollectBtnState()
    }
    
    func updateCollectBtnState() {
        if(DBOperator.sharedInstance.document.checkCachePic(imgUrl: selectedPicModel.picUrl!)) {
            //
            shareBtnsView.collectBtn.image = #imageLiteral(resourceName: "uncollectionBt_h")
        } else {
            shareBtnsView.collectBtn.image = #imageLiteral(resourceName: "uncollectionBt")
        }
        shareBtnsView.layoutIfNeeded()

    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension DetailVC: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionDetailCell", for: indexPath) as! CollectionDetailCell
        //large
        let picUrlStr = "http://ww4.sinaimg.cn/thumb300/\(dataSource[indexPath.item].picUrl!)"
//        cell.img.sd_setAnimationImages(with: [URL(string: picUrlStr)!])
        cell.img.sd_setImage(with: URL(string: picUrlStr), placeholderImage: nil, options: .refreshCached, completed: nil)
        if(indexPath == selectedIndex) {
            cell.indicator.backgroundColor = UIColor(red: 1, green: 153/255, blue: 18/255, alpha: 1)
        } else {
            cell.indicator.backgroundColor = UIColor.clear
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        titleCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        if selectedIndex == indexPath {
            return
        }
        let beforeIndex = selectedIndex
        selectedIndex = indexPath
        collectionView.reloadItems(at: [indexPath, beforeIndex!])
        let picUrlStr = "http://ww4.sinaimg.cn/large/\(dataSource[selectedIndex.item].picUrl!)"
        let cell = collectionView.cellForItem(at: indexPath) as! CollectionDetailCell
        largeImg.sd_setImage(with: URL(string: picUrlStr), placeholderImage: cell.img.image, options: .refreshCached, completed: nil)
    }

}


extension UIView {
    func addOnClickListener(target: AnyObject, action: Selector) {
        let gr = UITapGestureRecognizer(target: target, action: action)
        gr.numberOfTapsRequired = 1
        isUserInteractionEnabled = true
        addGestureRecognizer(gr)
    }
    func addOnClickListener(target: AnyObject, action: Selector, tapNumber:Int)-> UITapGestureRecognizer {
        let gr = UITapGestureRecognizer(target: target, action: action)
        gr.numberOfTapsRequired = tapNumber
        isUserInteractionEnabled = true
        addGestureRecognizer(gr)
        return gr
    }
}
