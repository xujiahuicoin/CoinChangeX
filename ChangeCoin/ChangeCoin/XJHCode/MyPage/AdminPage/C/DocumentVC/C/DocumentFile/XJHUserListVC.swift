//
//  XJHUserListVC.swift
//  ChangeCoin
//
//  Created by mac on 2019/12/30.
//  Copyright © 2019 www.xujiahuiCoin.com. All rights reserved.
//

/*
 -(instancetype)initWithTag:(NSString *)tag rowType:(NSString *)rowType title:(NSString *)title;
 {
 
 #define isStringEmpty(string) (string == nil || string == NULL || (![string isKindOfClass:[NSString class]]) || ([string isEqual:@""]) || [string isEqualToString:@""] || [string isEqualToString:@" "] || ([string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length == 0)||[string isEqualToString:@"<null>"]||[string isEqualToString:@"(null)"])
 
 if (isStringEmpty(tag)) {
 _tag = [NSString stringWithFormat:@"%f",[[NSDate date]timeIntervalSince1970]];
 
 }else{
 _tag = tag;
 }
 
 
 */



import UIKit

import XLForm
class XJHUserListVC: XLFormViewController {
    

    
    var userArray : [[String]]?
    var fileDict : Dictionary<String,Any>!
    var currentMod : XJh_GithubProjectContentsModel!
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
    }
    
    func initializeForm() {
        
        let form : XLFormDescriptor
        var section : XLFormSectionDescriptor
        var row : XLFormRowDescriptor
        
        form = XLFormDescriptor(title: "用户管理列表")
        
        section = XLFormSectionDescriptor.formSection(withTitle: "用户名字要与创建用户名字一致，API-Key建议使用只读key值",sectionOptions:XLFormSectionOptions.canInsert.union(.canDelete), sectionInsertMode:.button)
        form.addFormSection(section)
        
        let tagstr = Date().timeStringStamp
        row = XLFormRowDescriptor(tag: tagstr, rowType:XLFormRowDescriptorTypeTextView)
        row.height = 160
        section.multivaluedRowTemplate = row
        
        //for tianjia
        if userArray!.count < 1{
            return
        }
        
        for arr in userArray ?? [[]] {
            
            row = XLFormRowDescriptor(tag:arr[0], rowType:XLFormRowDescriptorTypeTextView)
            row.value = arr[0] + "," + arr[1]
            row.height = 160
            row.isRequired = true
            row.disabled = true
            section.addFormRow(row)
        }
        
        
        self.form = form
        
        tableView.setEditing(false, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let item1 = UIBarButtonItem(title:"添加", style: .plain, target: self, action:#selector(XJHUserListVC.toggleEditing(_:)))
        
        let item2 = UIBarButtonItem(title:"保存", style: .plain, target: self, action:#selector(XJHUserListVC.savePressed))
        
        navigationItem.rightBarButtonItems = [item1,item2]
        
        xjh_getAdminData()
        
    }
    @objc func toggleEditing(_ sender : UIBarButtonItem) {
        tableView.setEditing(!tableView.isEditing, animated: true)
        sender.title = tableView.isEditing ? "完成":"添加"
    }
    
    func xjh_getAdminData(){
        
        let url = XJH_GitSupervisionInfoGet()
        
        XJH_GitHub.GitHubProjectPathFiledict(pathUrl:url, blockSuccess: { (modic) in
            
            if let dict = modic.contentToDict() as? Dictionary<String,Any> {
                self.currentMod = modic
                self.fileDict = dict
                
                let mod : XJH_AdminModel = XJH_AdminModel.deserialize(from: dict)!
                //解析 user 中的key
                if mod.user.count > 0{
                    
                    self.userArray = mod.user
                    
                    self.initializeForm()
                    
                    return
                }
            }
            
            XJHProgressHUD.showError(message: "解析数据失败", view: self.view)
            
        }) { (err) in
            
        }
    }
    
    @objc func savePressed(_ sender: UIBarButtonItem) {
        
        
        self.view.endEditing(true)
        
        //保存
        let value = self.formValidationErrors()
        
        if value!.count > 0 {
            XJHProgressHUD.showError(message: "检查一下表格", view: self.view)
        }else{
            
            let result:Dictionary<String,String> = self.formValues() as! Dictionary<String, String>
            var userArray:Array<Any> = []
            
            for var str in result.values{
               str = str.replacingOccurrences(of: "，", with: ",")
                let arrStr = str.components(separatedBy: ",")

                if arrStr.count < 1{
                    BaseAlertController.showAlertOneAction(message: "数据格式不正确，用户名与key值用 , 隔开", vc: self) {
                        
                    }
                    return
                }
                
                userArray.append(arrStr)
            }
            
            self.fileDict.append(userArray, forKey: "user")
            
            XJHProgressHUD.show(view: self.view)
            //            字典转json 保存
            XJH_GitHub.Github_UpdateAdminFileWith(.update, sha: currentMod.sha, content: self.fileDict, path: currentMod.path, blockSuccess: {
                XJHProgressHUD.hide()
                XJHProgressHUD.showSuccess(message: "修改成功")
                
                self.navigationController?.popViewController(animated: true)
            }) { (err) in
                XJHProgressHUD.hide()
                XJHProgressHUD.showError(message: "修改失败")
                
            }
            
        }
        
        
    }
}
