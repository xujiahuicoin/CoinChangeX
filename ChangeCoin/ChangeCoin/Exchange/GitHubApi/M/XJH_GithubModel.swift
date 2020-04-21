//
//  XJH_GithubModel.swift
//  ChangeCoin
//
//  Created by mac on 2019/12/17.
//  Copyright © 2019 www.xujiahuiCoin.com. All rights reserved.
//

import UIKit

///Github 获取文件内容
///  目录列表
class XJh_GithubProjectContentsModel : XJHBaseModel{
    ///请求信息  git、html、 self
    var _links : Dictionary<String,Any> = [:]
    ///
    var download_url : String = ""
    var git_url : String = ""
    var html_url : String = ""
    ///文件名字
    var name  : String = ""
    ///仓库下的路径
    var path : String = ""
    ///sha
    var sha : String = ""
    ///大小
    var size : String = ""
    ///类型 dir 文件  file 文本
    var type : String = ""
    ///获取路径
    var url : String = ""
    //-------------文本-----------------------
    ///文本内容
    var content : String = ""
    ///内容处理方式 base64
    var encoding : String = ""
    
    
    ///base64解码
    func Base64ToString()->String{
        
        //判断加密类型
        if self.encoding == "base64" {
            
            let str = self.content.replacingOccurrences(of: "\n", with: "")
            
            return str.base64Decoded ?? ""
        }
        
        return ""
    }
    ///base64 编码
    func StringToBase64(content:String)-> String{
        return content.base64Encoded!
    }
    
    ///指定文件的内容转 字典
    func contentToDict() ->Dictionary<String,Any>{
        let contentJson = self.Base64ToString()
        let dict = getDictionaryFromJSONString(contentJson)
        
        return dict 
    }
}



///Github 返回错误信息
class XJH_GithubErrorModel : XJHBaseModel {
    ///错误返回信息
    var message : String = ""
    ///事例URL
    var documentation_url : String = ""
}
