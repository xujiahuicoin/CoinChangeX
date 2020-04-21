//
//  GitHub_Api.swift
//  ChangeCoin
//
//  Created by mac on 2019/12/17.
//  Copyright © 2019 www.xujiahuiCoin.com. All rights reserved.
//

//https://api.github.com

///GitHUb
let GitHubBaseUrl = "https://api.github.com/repos/Github名字/项目名字/contents/" //需要修改

/////公私库的编辑查看OnYourMark-Sun
let GitHUb_less_Token = ""
///所有权限的Token
let GitHub_All_Token = ""//需要修改

///服务器目录
let xjh_GitServerList = GitHubBaseUrl

///当前获取服务器 根目录
func XJH_GitServerPathRoot()-> String {
   
    //服务器名称
    let serverName = XJH_UserInfo.XJH_getServerNameInInfo()

    return GitHubBaseUrl + serverName + "?ref=master"
    //https://api.github.com/repos/OnYourMark-Sun/XJH_ExchangeCoinInfo/contents/YingChengCoin?ref=master
}
///获取管理员信息
func XJH_GitSupervisionInfoGet()-> String {
    //服务器名称
    let serverName = XJH_UserInfo.XJH_getServerNameInInfo()
    return GitHubBaseUrl + serverName + "/adminInfo"
}

///登录请求 获取用户信息
func XJH_GitInfoGet(userName:String)-> String {
    //服务器名称
    let serverName = XJH_UserInfo.XJH_getServerNameInInfo()
    if serverName.count < 1 {
           return ""
       }
    return GitHubBaseUrl + serverName + "/userInfo/" + userName
}



//-------------APi-----------------------
func Github_APi_Authorization_Token() -> String {
    return GitHubBaseUrl + "?access_token=" + GitHub_All_Token
}
