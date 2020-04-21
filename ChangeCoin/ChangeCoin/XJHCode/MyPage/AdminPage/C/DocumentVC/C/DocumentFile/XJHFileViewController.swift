////
////  XJHFileViewController.swift
////  ChangeCoin
////
////  Created by mac on 2019/12/18.
////  Copyright © 2019 www.xujiahuiCoin.com. All rights reserved.
////
//
//import UIKit
//
//class XJHFileViewController: XJHBaseViewController {
//
//    var mod:XJh_GithubProjectContentsModel!
//    ///是否为根目录：有管理员文档-只能做修改操作
//    var fileRootPage : Bool!
//    ///是否创建用户 默认不是
//    var creatFile : Bool = false
//    var userNameStr : String = ""
//
//    @IBOutlet weak var fileTextView: UITextView!
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//
//        if !creatFile{
//            //
//            self.title = mod.name
//            xjh_getFileMod()
//            self.xjh_createRightButtonItem(title: "操作", target: self, action: #selector(operationDocument))
//        }else{
//            self.title = "创建用户"
//            self.xjh_createRightButtonItem(title: "创建", target: self, action: #selector(createDocument))
//
//            self.fileTextView.text = XJH_GitHub.Github_CreatUserInfo_JsonString()
//
//            ///先输入用户名
//            self.creatUserNameAlert()
//        }
//
//        self.view.backgroundColor = XJHBackgroundColor_dark
//        fileTextView.backgroundColor = XJHBackgroundColor_dark
//    }
//    ///单独获取file详细信息
//    func xjh_getFileMod()  {
//
//        xjh_HUDShow()
//
//        XJH_GitHub.GitHubProjectPathFiledict(pathUrl: GitHubBaseUrl + mod.path, blockSuccess: { (mod) in
//            self.xjh_hideHUD()
//            self.mod = mod
//
//            if mod.content.count < 1{
//                self.xjh_showProgress_Text(text: "改文本没有内容", view: self.view)
//            }
//
//            DispatchQueue.main.async(execute: {
//                let strtext = mod.Base64ToString()
//                self.fileTextView.text = strtext
//                print("---sringJson----" + strtext)
//            })
//
//        }) { (errs) in
//            self.xjh_hideHUD()
//            self.xjh_showProgress_Text(text: errs.message, view: self.view)
//
//        }
//    }
//
//
//    ///操作文件
//    @objc func operationDocument(){
//
//        BaseAlertController.showAlertSheet(title: "操作", actions:fileRootPage ? ["保存修改","取消"] : ["保存修改","冻结","删除","取消"], vc: self, redtypeShow: fileRootPage ? 1 : 3) { (str, index) in
//            if index == 0 {
//                BaseAlertController.showAlertTwoAction(message: "确定对原文件修改并保存", vc: self, FFActionOne: {
//
//                }) {
//                    //caocun
//                    self.xjh_updateSaveChangeFile()
//                }
//
//            }else if index == 1 {
//                //dongjie
//                BaseAlertController.showAlertTwoAction(message: "停止该用户所有操作，挂单持仓需手动取消", vc: self, FFActionOne: {
//                }) {
//                    //去冻结
//                    self.xjh_freezeDocumentFile()
//                }
//            }else if index == 2 {
//                //shanchu
//                BaseAlertController.showAlertTwoAction(message: "删除不可找回，确定要删除吗", vc: self, FFActionOne: {
//                }) {
//                    //去删除
//                    self.xjh_deleteDocumentFile()
//                }
//            }
//        }
//
//    }
//
//    ///创建用户名
//    func creatUserNameAlert(){
//
//        XjhAlertView().showEdit(placeholder: "用户名(字母)", message: "输入用户名", btnTitle: "确定") { (str) in
//
//            if str.count > 0 {
//                self.userNameStr = str
//                self.title = str
//            }else{
//                self.xjh_showProgress_Text(text: "用户名不能为空", view: self.view)
//                self.creatUserNameAlert()
//            }
//
//        }
//    }
//
//    ///创建用户
//    @objc func createDocument(){
//
//
//        //格式验证 是否j可以转成字典
//        let jsonString = self.fileTextView.text
//
//        if let dict = getDictionaryFromJSONString(jsonString!) as? Dictionary<String,Any> {
//
//            if dict.keys.count > 0 {
//                //字典转换成功
//                self.xjh_HUDShow()
//                XJH_GitHub.Github_UpdateFileWith(.create, sha: "", content: self.fileTextView.text, path: userNameStr, blockSuccess: { () in
//
//                    self.xjh_hideHUD()
//                    self.xjh_showSuccess_Text(text: "创建用户成功")
//                    self.goLeftVC()
//                }) { (err) in
//                    self.xjh_hideHUD()
//                    self.xjh_showProgress_Text(text: err.message, view: self.view)
//                }
//
//                return
//            }
//        }
//
//        self.xjh_showSuccess_Text(text: "文本格式有误")
//
//    }
//
//    ///冻结文件
//    func xjh_freezeDocumentFile(){
//
//        //格式验证 是否j可以转成字典
//        let jsonString = self.fileTextView.text
//
//        if var dict = getDictionaryFromJSONString(jsonString!) as? Dictionary<String,Any> {
//
//            if dict.keys.count > 0 {
//                //字典转换成功
//                //修改冻结属性
//                dict.append(true, forKey: "freeze")
//
//                //字典转jsonstring
//                let jsonStr:String = getJSONStringFromDictionary(dict) ?? ""
//
//                if jsonStr.count > 0{
//
//                    //进行网络
//                    self.xjh_HUDShow()
//                    XJH_GitHub.Github_UpdateFileWith(.update, sha: self.mod.sha, content: jsonStr, path: self.mod.path, blockSuccess: { () in
//
//                        self.xjh_hideHUD()
//                        self.xjh_showSuccess_Text(text: "冻结用户成功")
//                        self.goLeftVC()
//                    }) { (err) in
//                        self.xjh_hideHUD()
//                        self.xjh_showProgress_Text(text: err.message, view: self.view)
//                    }
//                }
//
//            }else{
//                //内容有误
//                self.xjh_showSuccess_Text(text: "内容有误，请重试")
//            }
//        }else{
//            //内容有误
//            self.xjh_showSuccess_Text(text: "内容有误，请重试")
//        }
//
//    }
//    ///删除文件--
//    func xjh_deleteDocumentFile(){
//        //将文件中的
//        self.xjh_HUDShow()
//        XJH_GitHub.Github_UpdateFileWith(.delete, sha: self.mod.sha, content: self.fileTextView.text, path: self.mod.path, blockSuccess: { () in
//
//            self.xjh_hideHUD()
//            self.xjh_showSuccess_Text(text: "删除成功")
//            self.goLeftVC()
//        }) { (err) in
//            self.xjh_hideHUD()
//            self.xjh_showProgress_Text(text: err.message, view: self.view)
//        }
//    }
//
//    ///保存文件
//    func xjh_updateSaveChangeFile(){
//
//        print("保存")
//        //格式验证 是否j可以转成字典
//        let jsonString = self.fileTextView.text
//
//        if let dict = getDictionaryFromJSONString(jsonString!) as? Dictionary<String,Any> {
//
//            if dict.keys.count > 0 {
//                //字典转换成功
//                //去提交
//                self.xjh_UpdateFileWith()
//                return
//            }
//        }
//
//        BaseAlertController.showAlertTwoAction(message: "文本格式修改有误，是否继续修改",actionTextOne: "复原重改", actionTextTwo: "继续修改", vc: self, FFActionOne: {
//
//            self.fileTextView.text = self.mod.Base64ToString()
//
//        }) {
//
//        }
//    }
//    
//    ///更新数据
//    func xjh_UpdateFileWith(){
//
//        self.xjh_HUDShow()
//        XJH_GitHub.Github_UpdateFileWith(.update, sha: self.mod.sha, content: self.fileTextView.text, path: self.mod.path, blockSuccess: { () in
//
//            self.xjh_hideHUD()
//            self.xjh_showSuccess_Text(text: "修改内容成功")
//            self.goLeftVC()
//        }) { (err) in
//            self.xjh_hideHUD()
//            self.xjh_showProgress_Text(text: err.message, view: self.view)
//        }
//    }
//}
//
//
