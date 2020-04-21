//
//  XJH_coinDataDeal.swift
//  ChangeCoin
//
//  Created by xujiahui on 2019/11/5.
//  Copyright © 2019 www.xujiahuiCoin.com. All rights reserved.
//

//---------------数据处理---------------------

import UIKit
enum dataCalculationType: String {
    ///加
    case type_Add = "+"
    ///减
    case type_subtraction = "-"
    ///乘
    case type_multiplication = "*"
    ///除
    case type_division = "/"
}

import CommonCrypto

///数据计算
func dataCalculationAndAfter(beforeStr:String = "0", beforeDouble:Double = 0,theWay:dataCalculationType,afterStr:String = "0", afterDouble:Double = 0) ->String {
    
    let before:Double = beforeDouble > 0 ? beforeDouble : (Double(beforeStr) ?? 0.0)
    let after:Double  = afterDouble > 0  ? afterDouble  : (Double(afterStr) ??  0.0)
    
    var resout = 0.0
    if theWay == .type_Add {
       resout = before + after
    }else if theWay == .type_subtraction {
        resout = before - after
    }else if theWay == .type_multiplication {
        resout = before * after
    }else if theWay == .type_division {
        resout = before / after
    }
    
    return xjh_AutoRoundToString(doubleDou: resout)
}

///Bytes转data解析数据
func bytesToData(byte:Any,count:Int) -> Data{
    return Data.init(bytes: byte as! UnsafeRawPointer, count: count)
}
///datajson 转 dict
func getDictionFromJsonData(data:Data)->[String : Any]?{
    
    if let dict = try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as? [String : Any] {
        return dict
    }
    
    return nil
}
/// JSONString转换为字典
func getDictionaryFromJSONString(_ jsonString: String) -> [String : Any]{
    
    var strVar = jsonString.replacingOccurrences(of: "\n", with: "")
    //去除掉首尾的空白字符和换行字符
    strVar = strVar.trimmingCharacters(in: CharacterSet.newlines)
    strVar = strVar.replacingOccurrences(of: " ", with: "")
    strVar = strVar.replacingOccurrences(of: "\\", with: "")
    strVar = strVar.replacingOccurrences(of: "\r", with: "")
    
    do{
        return try (JSONSerialization.jsonObject(with: strVar.data(using: .utf8)!, options: []) as? [String : Any])!
    
    } catch let error as NSError {
        
      print(error)
        
    }
 
    return [:]
    
    
}

///字典转data
func getDataFromDictionary(_ dict:[String : Any]) -> Data?{
    
    if (!JSONSerialization.isValidJSONObject(dict)) {
         print("无法解析出JSONString")
         return nil
     }
     let data : Data! = try? JSONSerialization.data(withJSONObject: dict, options: [])
    return data
}

// MARK: 字典转字符串
func getJSONStringFromDictionary(_ dic:[String : Any]) -> String?{
    if (!JSONSerialization.isValidJSONObject(dic)) {
        print("无法解析出JSONString")
        return ""
    }
    let data : Data! = try? JSONSerialization.data(withJSONObject: dic, options: [])
    var addStr:String = String.init(data: data, encoding: .utf8) ?? ""
    
    return addStr
    
}
///json 转数组
func getArrayFromJSONString(jsonString:String) ->NSArray{
    
    let jsonData:Data = jsonString.data(using: .utf8)!
    
    let array = try? JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers)
    if array != nil {
        return array as! NSArray
    }
    return array as! NSArray
    
}
///数组转json
func getJSONStringFromArray(array:NSArray) -> String {
    
    if (!JSONSerialization.isValidJSONObject(array)) {
        print("无法解析出JSONString")
        return ""
    }
    
    let data : NSData! = try? JSONSerialization.data(withJSONObject: array, options: []) as NSData?
    let JSONString = NSString(data:data as Data,encoding: String.Encoding.utf8.rawValue)
    return JSONString! as String
    
}
///MD5 加密
func md5Detail(mdString:String) -> String {
    let str = mdString.cString(using: String.Encoding.utf8)
    let strLen = CUnsignedInt(mdString.lengthOfBytes(using: String.Encoding.utf8))
    let digestLen = Int(CC_MD5_DIGEST_LENGTH)
    let result = UnsafeMutablePointer<UInt8>.allocate(capacity: 16)
    CC_MD5(str!, strLen, result)
    let hash = NSMutableString()
    for i in 0 ..< digestLen {
        hash.appendFormat("%02x", result[i])
    }
    free(result)
    return String(format: hash as String)
}

///---------------- HMac 256 加密。base64 编码
enum HMACAlgorithm {
    case MD5, SHA1, SHA224, SHA256, SHA384, SHA512
    
    func toCCHmacAlgorithm() -> CCHmacAlgorithm {
        var result: Int = 0
        switch self {
        case .MD5:
            result = kCCHmacAlgMD5
        case .SHA1:
            result = kCCHmacAlgSHA1
        case .SHA224:
            result = kCCHmacAlgSHA224
        case .SHA256:
            result = kCCHmacAlgSHA256
        case .SHA384:
            result = kCCHmacAlgSHA384
        case .SHA512:
            result = kCCHmacAlgSHA512
        }
        return CCHmacAlgorithm(result)
    }
    
    func digestLength() -> Int {
        var result: CInt = 0
        switch self {
        case .MD5:
            result = CC_MD5_DIGEST_LENGTH
        case .SHA1:
            result = CC_SHA1_DIGEST_LENGTH
        case .SHA224:
            result = CC_SHA224_DIGEST_LENGTH
        case .SHA256:
            result = CC_SHA256_DIGEST_LENGTH
        case .SHA384:
            result = CC_SHA384_DIGEST_LENGTH
        case .SHA512:
            result = CC_SHA512_DIGEST_LENGTH
        }
        return Int(result)
    }
}

/// HMac 256 加密
func HMAC_Sign(algorithm:HMACAlgorithm,keyString: String, dataString: String) -> String {
    
    let keyData = keyString.data(using: .utf8)! as NSData
    let strData = dataString.data(using: .utf8)! as NSData
    
    let len = algorithm.digestLength()
    
    var cHMAC = [UInt8](repeating: 0, count: Int(len))
    
    CCHmac(CCHmacAlgorithm(algorithm.toCCHmacAlgorithm()), keyData.bytes, keyData.count, strData.bytes, strData.count, &cHMAC)
    
    let data = Data(bytes: &cHMAC, count: Int(len))
    let base64String = data.base64EncodedString()
    return base64String
}


///ISO时间格式 转换
func XJH_IOSDateToString(ISOStr : String, timeType : TimeTypes) -> String {
    
    let dfmatter = DateFormatter()
    dfmatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
    let date:Date = dfmatter.date(from: ISOStr)!
    
    dfmatter.dateFormat = timeType.rawValue
    return dfmatter.string(from: date)
    
}

class JsonFormatUtil {
    
    static func stringToJSON(strJson: String) -> String {
        // 计数tab的个数
        var tabNum: Int = 0
        var jsonFormat: String = ""
        
        var last = "";
        for i in strJson.indices {
            let c = strJson[i]
            if (c == "{") {
                tabNum += 1
                jsonFormat.append("\(c) \n")
                jsonFormat.append(getSpaceOrTab(tabNum: tabNum))
            }
            else if (c == "}") {
                tabNum -= 1
                jsonFormat.append("\n")
                jsonFormat.append(getSpaceOrTab(tabNum: tabNum))
                jsonFormat.append(c)
            }
            else if (c == ",") {
                jsonFormat.append("\n")
                jsonFormat.append(getSpaceOrTab(tabNum: tabNum))
            }
            else if (c == ":") {
                jsonFormat.append("\(c) ")
            }
            else if (c == "[") {
                tabNum += 1
                let next = strJson[strJson.index(i, offsetBy: 1)]
                if (next == "]") {
                    jsonFormat.append("\(c)")
                } else {
                    jsonFormat.append("\(c) \n")
                    jsonFormat.append(getSpaceOrTab(tabNum: tabNum))
                }
            }
            else if (c == "]") {
                tabNum -= 1
                if (last == "[") {
                    jsonFormat.append("\(c)")
                } else {
                    jsonFormat.append("\(getSpaceOrTab(tabNum: tabNum))\n \(c)")
                }
            }
            else {
                jsonFormat.append("\(c)")
            }
            last = "\(c)"
        }
        return jsonFormat;
    }
    
    
    static func getSpaceOrTab(tabNum: Int) -> String {
        var sbTab = ""
        for _ in 0..<tabNum {
            sbTab.append("\t")
        }
        return sbTab
    }
}

