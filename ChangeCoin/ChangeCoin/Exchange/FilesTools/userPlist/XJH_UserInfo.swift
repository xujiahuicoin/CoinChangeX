//
//  XJH_UserInfo.swift
//  ChangeCoin
//
//  Created by mac on 2019/12/18.
//  Copyright © 2019 www.xujiahuiCoin.com. All rights reserved.
//

import UIKit
let serverNameKey = "serverName"
class XJH_UserInfo: NSObject {
    
    ///内容读取
    class func XJH_ReadUserInfoPlist(key:String)-> String {
        
        let fileName = "userSet"
        
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true) as NSArray
        
        let documentsDirectory = paths[0] as! NSString
        let path = documentsDirectory.appendingPathComponent(fileName)
        let fileManager = FileManager.default
        
        if(!fileManager.fileExists(atPath: path)) {
            if let bundlePath = Bundle.main.path(forResource: fileName, ofType: nil) {
                try! fileManager.copyItem(atPath: bundlePath, toPath: path)
            } else {
                print(fileName + " not found. Please, make sure it is part of the bundle.")
            }
        } else {
            print(fileName + " already exits at path.")
        }
        let myDict = NSDictionary(contentsOfFile: path)
        if let dict:NSDictionary = myDict {
            return dict[key] as? String  ?? ""
        } else {
            print("WARNING: Couldn't create dictionary from " + fileName + "! Default values will be used!")
            return ""
        }
    }
    
    ///内容写入
    class func XJH_WriteUserInfoPlist(key:String, value:String){
        
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true) as NSArray
        
        let documentsDirectory = paths.object(at: 0) as! NSString
        let path = documentsDirectory.appendingPathComponent("userSet")
        let dict: NSMutableDictionary = NSMutableDictionary()
        dict.setValue(value, forKey: key)
        dict.write(toFile: path, atomically: false)
        
    }
    
    ///获取服务器name
    class func XJH_getServerNameInInfo() -> String{
        
        let servername = XJH_ReadUserInfoPlist(key: serverNameKey)
        return servername
    }
    
}

