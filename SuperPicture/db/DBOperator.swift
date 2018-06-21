//
//  DBOperater.swift
//  Sinovel
//
//  Created by Yuan Liu on 6/3/16.
//  Copyright © 2016 Yuan Liu. All rights reserved.
//

import UIKit
import FMDB

//enum DBPosition {
//    case local,
//    decoument //收藏的
//}
let cacheableName = "cache"
class DBOperator {
    var queue: FMDatabaseQueue!
//    let fileUrl: String? = {
//        return Bundle.main.path(forResource: "sticker.db", ofType: nil)
//    }()
    
    
    
    static var sharedInstance = DBOperator()
    
    var local: DBOperator {
        queue = FMDatabaseQueue(path: Bundle.main.path(forResource: "sticker.db", ofType: nil))
        return self
    }
    
    var document: DBOperator {
        let documents = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        let p = documents.appendingPathComponent("cache.db")
        queue = FMDatabaseQueue(path: p.path)
        return self
    }
    
    private init(){
        
    }
    
//    lazy var format: NSDateFormatter = {
//        let formatter = NSDateFormatter()
//        formatter.timeZone = NSTimeZone.systemTimeZone()
//        formatter.dateFormat = "YYYY-MM"
//        return formatter
//    }()
    
    //检查表是否存在
    func checkTable(tableName: String) -> Bool {
        var result = false
        let sql = "select count(*) as 'count' from sqlite_master where type ='table' and name = ? "
        query(sql: sql, values: [tableName as AnyObject]) { (rs) in
            while rs.next() {
                let count = rs.int(forColumn: "count")
                if count > 0 {
                    result = true
                }
            }
        }
        return result
    }
    
    //删表操作
//    func deleteTable(tableName: String) {
//        let sql = "drop table \(tableName) "
//        execute(sql: sql)
//    }

    //查询当前图片是否被缓存
    func checkCachePic(imgUrl: String)-> Bool {
        var result = false
        let sql = "select count(1) as 'count' from \(cacheableName) where PICURL = ?"
        document.query(sql: sql, values: [imgUrl as AnyObject]) { (rs) in
            while rs.next() {
                let count = rs.int(forColumn: "count")
                if count > 0 {
                    result = true
                }
            }
        }
        return result
    }
    
    func checkCachePackage(packageName: String)-> Bool {
        var result = false
        let sql = "select count(1) as 'count' from \(cacheableName) where PACKAGENAME = ?"
        document.query(sql: sql, values: [packageName as AnyObject]) { (rs) in
            while rs.next() {
                let count = rs.int(forColumn: "count")
                if count > 0 {
                    result = true
                }
            }
        }
        return result
    }

    
    func removeCachePic(imgUrl: String) {
        let sql = "delete from \(cacheableName) where PICURL = ? "
        document.execute(sql: sql, values: [imgUrl as AnyObject])
    }
    
    func removeCachePackage(packageName: String) {
        let sql = "delete from \(cacheableName) where PACKAGENAME = ? "
        document.execute(sql: sql, values: [packageName as AnyObject])
    }

    
    func insertCachePic(imgUrl: String) -> Bool {
        let sql = "insert into \(cacheableName) (PICURL) VALUES (?)"
        return document.execute(sql: sql,values: [imgUrl as AnyObject])
    }
    
    func insertCachePackage(packageName: String, pics: String) -> Bool {
        let sql = "insert into \(cacheableName) (PACKAGENAME, PICLIST) VALUES (?, ?)"
        return document.execute(sql: sql,values: [packageName as AnyObject, pics as AnyObject])
    }

    
//    func checkCachePackage(packageName: String)-> Bool {
//        var result = false
//        let sql = "select count(1) as 'count' from \(cacheableName) where PACKAGENAME = ?"
//        document.query(sql: sql, values: nil) { (rs) in
//            while rs.next() {
//                let count = rs.int(forColumn: "count")
//                if count > 0 {
//                    result = true
//                }
//            }
//        }
//        return result
//    }

    
    //查询
    func query(sql sql: String, values: [AnyObject]?, condation: (_ rs: FMResultSet)-> ()) {
            self.queue.inDatabase({ (database) in
                do {
                    let rs = try database.executeQuery(sql, values: values)
                    condation(rs)
                } catch let error as NSError {
                    print("failed: \(error.localizedDescription)")
                }
            })
    }
    
    func checkCacheTable() -> Bool {
        return checkTable(tableName: cacheableName)
    }
    
    func querySingle() -> [SinglePicModel] {
        var result = [SinglePicModel]()
        query(sql: "select * from RandomList", values: nil) { (rs) in
            while rs.next() {
                let picModel = SinglePicModel()
                picModel.id = rs.string(forColumn: "ID")
                picModel.name = rs.string(forColumn: "Package")
                picModel.picUrl = rs.string(forColumn: "Name")
                result.append(picModel)
            }
        }
        return result
    }
    
    func queryCacheSingle() -> [SinglePicModel] {
        var result = [SinglePicModel]()
        query(sql: "select * from \(cacheableName) ", values: nil) { (rs) in
            while rs.next() {
                let picUrl = rs.string(forColumn: "PICURL")
                if let picUrl = picUrl {
                    print(picUrl)
                    let picModel = SinglePicModel()
                    picModel.picUrl = picUrl
                    result.append(picModel)
                }
            }
        }
        return result
    }

    
    func queryPackage() -> [PackageModel] {
        var result = [PackageModel]()
        query(sql: "select * from PackageList", values: nil) { (rs) in
            while rs.next() {
                let packageModel = PackageModel()
                packageModel.id = rs.string(forColumn: "ID")
                packageModel.name = rs.string(forColumn: "Name")
                let picsString = rs.string(forColumn: "Singles")
                packageModel.picList = picsString?.split(separator: ",").map({ (str) -> String in
                    return String(str)
                })
                result.append(packageModel)
            }
        }
        return result
    }
    
    
    func queryCachePackage() -> [PackageModel] {
        var result = [PackageModel]()
        query(sql: "select * from \(cacheableName) ", values: nil) { (rs) in
            while rs.next() {
                let picUrl = rs.string(forColumn: "PACKAGENAME")
                if let picUrl = picUrl {
                    let picModel = PackageModel()
                    picModel.name = picUrl
                    let picsString = rs.string(forColumn: "PICLIST")
                    picModel.picList = picsString?.split(separator: ",").map({ (str) -> String in
                        return String(str)
                        
                    })
                    result.append(picModel)
                }
            }
        }
        return result
    }


//    //增删改都可?
    func execute(sql sql: String, values: [AnyObject]? = nil)-> Bool {
            var result = true
            self.queue.inTransaction({ (database, rollback) in
                do {
//                    database.setDateFormat(self.format)
                    try database.executeUpdate(sql, values: values)

                } catch let error as NSError {
                    print("failed: \(error.localizedDescription)")
//                    rollback.memory = true
                    rollback.pointee = true
                    result = false
                }
            })
            return result
    }
//    //供外调用的“相对原生”接口，直接操作database
    func nativeExecute(closure: (_ dbQueue: FMDatabaseQueue)-> ()) {
        closure(self.queue)
    }

}
