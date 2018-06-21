//
//  PackageModel.swift
//  SuperPicture
//
//  Created by lcy on 2017/11/17.
//  Copyright © 2017年 lcy. All rights reserved.
//

import UIKit

class PackageModel: NSObject {
    var id: String?
    var name: String?
    var picList: [String]?
    
    func toSingles() -> [SinglePicModel] {
        var arr = [SinglePicModel]()
        for p in picList! {
            let single = SinglePicModel()
            single.picUrl = p
            arr.append(single)
        }
        return arr
    }
    
    func toPicListStr() -> String {
        let result = picList?.reduce("") { (str0, str1) -> String in
            return str0 + "," + str1
        }
        return result!
    }
    
}
