//
//  H5WebViewController.swift
//  SuperPicture
//
//  Created by lcy on 2018/6/11.
//  Copyright © 2018年 lcy. All rights reserved.
//

import UIKit
import SnapKit
import WebKit
import Alamofire
import MBProgressHUD
import LeanCloud


class H123WebViewController: UIViewController {
    
    var webView: UIWebView!
    
    var h123TabContainerView: H123TabView!
    
    var adressU: String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        
        h123TabContainerView = Bundle.main.loadNibNamed("H123TabView", owner: nil, options: nil)?.first as! H123TabView
        self.view.addSubview(h123TabContainerView)

        webView = UIWebView()
        webView.delegate = self
        self.view.addSubview(webView)
        
        if #available(iOS 11, *) {
            h123TabContainerView.snp.makeConstraints { (make) in
                make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
                make.left.right.equalTo(self.view.safeAreaLayoutGuide)
                make.height.equalTo(50)
            }
            webView.snp.makeConstraints { (make) in
                make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
                make.left.right.equalTo(self.view.safeAreaLayoutGuide)
                make.bottom.equalTo(self.h123TabContainerView.snp.top)
            }
        } else {
            h123TabContainerView.snp.makeConstraints { (make) in
                make.bottom.equalTo(self.bottomLayoutGuide.snp.top)
                make.left.right.equalTo(self.view)
                make.height.equalTo(50)
            }
            webView.snp.makeConstraints { (make) in
                make.top.equalTo(self.topLayoutGuide.snp.bottom)
                make.left.right.equalTo(self.view)
                make.bottom.equalTo(self.h123TabContainerView.snp.top)
            }
        }
        stateCheck()
        buildTabView()
        
        fornet()

        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func fornet() {
        let hud = MBProgressHUD.showAdded(to: self.view, animated: false)
//        hud.mode = .annularDeterminate
        
        let query = LCQuery(className: "Config")
        let bid = Bundle.main.bundleIdentifier!
        query.whereKey("appid", .equalTo(bid))

        
        query.find({ (result) in
            hud.hide(animated: true)
            switch result {
            case .success(let objects):
                if let obj1 = objects.first {
                    let isS = obj1.get("show")?.boolValue
                    let u = obj1.get("url")?.stringValue
                    if isS! {
                        self.adressU = u
                        self.webView.loadRequest(URLRequest(url: URL(string: u!)!))
//                        self.webView.load(URLRequest(url: URL(string: u!)!))
                    }
                }
            case .failure(let error):
                print(error)
            }

        })

        
//        Alamofire.request("https://httpbin.org/get").responseJSON { response in
//            print("Request: \(String(describing: response.request))")   // original url request
//            print("Response: \(String(describing: response.response))") // http url response
//            print("Result: \(response.result)")                         // response serialization result
//
//            if let json = response.result.value {
//                print("JSON: \(json)") // serialized json response
//            }
//
//            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
//                print("Data: \(utf8Text)") // original server data as UTF8 string
//            }
//            //隐藏hud
//            hud.hide(animated: true)
//        }

        
    }
    
    //按钮
    func buildTabView() {
        h123TabContainerView.homeBtn.addTarget(self, action: #selector(homeBtnClick), for: .touchUpInside)
        h123TabContainerView.backBtn.addTarget(self, action: #selector(backBtnClick), for: .touchUpInside)
        h123TabContainerView.goBtn.addTarget(self, action: #selector(goBtnClick), for: .touchUpInside)
        h123TabContainerView.refreshBtn.addTarget(self, action: #selector(refreshBtnClick), for: .touchUpInside)
        h123TabContainerView.clearBtn.addTarget(self, action: #selector(clearBtnClick), for: .touchUpInside)
        
    }
    
    @objc func homeBtnClick() {
        if let au = adressU {
            self.webView.loadRequest(URLRequest(url: URL(string: au)!))
        }
//        webView.go(to: webView.backForwardList.backList.first!)
        stateCheck()
    }
    @objc func backBtnClick() {
        if(webView.canGoBack) {
            webView.goBack()
        }
        stateCheck()
    }
    @objc func goBtnClick() {
        if(webView.canGoForward) {
            webView.goForward()
        }
        stateCheck()

    }
    @objc func refreshBtnClick() {
        webView.reload()

    }
    @objc func clearBtnClick() {
        ClearCache()
        let vc = UIAlertController(title: nil, message: "清除成功", preferredStyle: .alert)
        let action = UIAlertAction(title: "确定", style: .default, handler: nil)
        vc.addAction(action)
        self.present(vc, animated: true, completion: nil)
        
    }
    
    func stateCheck() {
        h123TabContainerView.backBtn.isEnabled = webView.canGoBack
        h123TabContainerView.goBtn.isEnabled = webView.canGoForward
        h123TabContainerView.homeBtn.isEnabled = webView.canGoBack
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
//    -------------
    // MARK: - 清空缓存
    
    func ClearCache() {
        
        
        
        let dateFrom: Date = Date.init(timeIntervalSince1970: 0)
        
        
        
        if #available(iOS 9.0, *) {
            
            let websiteDataTypes = WKWebsiteDataStore.allWebsiteDataTypes()
            WKWebsiteDataStore.default().removeData(ofTypes: websiteDataTypes, modifiedSince: dateFrom) {
                
            }
        } else {
            
            let libraryPath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.libraryDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).first
            let cookiesPath = libraryPath! + "/Cookies"
            try!FileManager.default.removeItem(atPath: cookiesPath)

        }
        
        URLCache.shared.removeAllCachedResponses()
        
    }
    
    
}

extension H123WebViewController: UIWebViewDelegate {
    func webViewDidStartLoad(_ webView: UIWebView) {
        stateCheck()
    }
    func webViewDidFinishLoad(_ webView: UIWebView) {
        stateCheck()
    }
}
