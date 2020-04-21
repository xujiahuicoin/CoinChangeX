////
////  XJHJsomModel.swift
////  ChangeCoin
////
////  Created by mac on 2020/1/6.
////  Copyright © 2020 www.xujiahuiCoin.com. All rights reserved.
////
//
//
//
//import UIKit
//
//enum LsqError: Error {
//    case message(String)
//}
//struct LsqDecoder {
//    //TODO:转换模型
//    static func decode<T>(_ type: T.Type, param: [String:Any]) throws -> T where T: Decodable{
//        guard let jsonData = self.getJsonData(with: param) else {
//            throw LsqError.message("转换data失败")
//        }
//        guard let model = try? JSONDecoder().decode(type, from: jsonData) else {
//            throw LsqError.message("转换模型失败")
//        }
//        return model
//    }
//
//    static func getJsonData(with param: Any)->Data?{
//        if !JSONSerialization.isValidJSONObject(param) {
//            return nil
//        }
//
//        guard let data = try? JSONSerialization.data(withJSONObject: param, options: []) else {
//            return nil
//        }
//
//        return data
//    }
//}
//
//
////模型转字典，或转json字符串
//struct LsqEncoder {
//
//    public static func encoder(toString model:T) ->String? where T:Encodable{
//
//        let encoder = JSONEncoder()
//
//        encoder.outputFormatting = .prettyPrinted
//
//        guard let data = try? encoder.encode(model)else{
//
//            return nil
//
//        }
//
//        guard let jsonStr = String(data: data, encoding: .utf8)else{
//
//            return nil
//
//        }
//
//        return jsonStr
//
//    }
//
//    public static func encoder(toDictionary model:T) ->[String:Any]? where T:Encodable{
//
//    let encoder = JSONEncoder()
//
//    encoder.outputFormatting = .prettyPrinted
//
//    guard let data = try? encoder.encode(model)else{
//
//    return nil
//
//    }
//
//    guard let dict = try?JSONSerialization.jsonObject(with: data, options: .mutableLeaves)as? [String:Any]else{
//
//    return nil
//
//    }
//
//
//
//    return dict
//
//    }
//
//}
