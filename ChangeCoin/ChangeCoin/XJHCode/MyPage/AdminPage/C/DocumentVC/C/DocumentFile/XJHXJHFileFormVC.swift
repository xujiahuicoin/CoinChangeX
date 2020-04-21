//
//  XJHXJHFileFormVC.swift
//  ChangeCoin
//
//  Created by mac on 2019/12/27.
//  Copyright © 2019 www.xujiahuiCoin.com. All rights reserved.
//https://github.com/xmartlabs/XLForm

import UIKit

import XLForm
class XJHXJHFileFormVC: XLFormViewController {
    
    
    var creatform : Bool = false
    var titleStr : String = "创建用户"
    var currentMod : XJH_UserInfoModel?
    var fileModel : XJh_GithubProjectContentsModel?
    
    
    fileprivate struct Tags {
        
        static let userName = "userName"
        static let passWord = "passWord"
        ///管理权限
        static let adminBool = "adminBool"
        ///冻结账户
        static let freeze = "freeze"
        static let leverageMax = "leverageMax"
        static let leverageMin = "leverageMin"
        
        ///币币交易对
        static let coinUSDT = "coinUSDT"
        static let coinETH = "coinETH"
        static let coinBTC = "coinBTC"
        
        ///合约
        static let futures = "futures"
        
        
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        //        initializeForm()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        //        initializeForm()
    }
    
    func initializeForm() {
        
        let form : XLFormDescriptor
        var section : XLFormSectionDescriptor
        var row : XLFormRowDescriptor
        
        form = XLFormDescriptor(title: titleStr)
        
        form.assignFirstResponderOnShow = false
        
        section = XLFormSectionDescriptor.formSection(withTitle: "关键信息，谨慎修改！")
        form.addFormSection(section)
        
        // Name
        row = XLFormRowDescriptor(tag: Tags.userName, rowType: XLFormRowDescriptorTypeText, title: "用户名")
        //必填项
        row.isRequired = true
        row.cellConfig["textField.placeholder"] = "字母或者数字"
        row.disabled = NSNumber(value: !creatform as Bool)
        row.value = creatform ? "" : currentMod?.userName
        section.addFormRow(row)
        
        // passWord
        row = XLFormRowDescriptor(tag: Tags.passWord, rowType: XLFormRowDescriptorTypePassword, title: "密码字段")
        // validate the passWord
        row.disabled = NSNumber(value: !creatform as Bool)
        row.value = creatform ? "" : currentMod?.passWord
        row.isRequired = true
        section.addFormRow(row)
        
        //
        section = XLFormSectionDescriptor.formSection(withTitle: "管理员权限：打开后此操作手将看到其他人操作信息，更改权限等")
        form.addFormSection(section)
        row = XLFormRowDescriptor(tag: Tags.adminBool, rowType: XLFormRowDescriptorTypeBooleanSwitch, title: "管理权限")
        row.value = creatform ? false : currentMod?.adminBool
        //不可设置
        //        row.disabled = true
        section.addFormRow(row)
        
        //新的一组开始
        section = XLFormSectionDescriptor.formSection(withTitle: "操作权限设置")
        form.addFormSection(section)
        //
        row = XLFormRowDescriptor(tag: Tags.freeze, rowType: XLFormRowDescriptorTypeBooleanSwitch, title: "冻结")
        row.value = creatform ? false : currentMod?.freeze
        section.addFormRow(row)
        
        //
        row = XLFormRowDescriptor(tag: Tags.leverageMin, rowType: XLFormRowDescriptorTypeStepCounter, title: "杠杆倍数--最小值")
        row.value = creatform ? 0 : currentMod?.leverageMin
        row.isRequired = true
        section.addFormRow(row)
        //
        row = XLFormRowDescriptor(tag: Tags.leverageMax, rowType: XLFormRowDescriptorTypeStepCounter, title: "杠杆倍数--最大值")
        row.value = creatform ? 1 : currentMod?.leverageMax
        row.isRequired = true
        section.addFormRow(row)
        
        ///一组开始
        section = XLFormSectionDescriptor.formSection(withTitle: "币币-交易对")
        form.addFormSection(section)
        
        row = XLFormRowDescriptor(tag: Tags.coinBTC, rowType: XLFormRowDescriptorTypeMultipleSelector, title: "BTC")
        //        row.isRequired = true
        row.selectorTitle = "BTC-交易对"
        row.selectorOptions = XJH_UserModel.sharedInstance.wholeChange?.coinBTC
        row.value = creatform ? [] : currentMod?.coinBTC
        section.addFormRow(row)
        //
        row = XLFormRowDescriptor(tag: Tags.coinETH, rowType: XLFormRowDescriptorTypeMultipleSelector, title: "ETH")
        //        row.isRequired = true
        row.selectorTitle = "ETH-交易对"
        row.selectorOptions = XJH_UserModel.sharedInstance.wholeChange?.coinETH
        row.value = creatform ? [] : currentMod?.coinETH
        section.addFormRow(row)
        //
        row = XLFormRowDescriptor(tag: Tags.coinUSDT, rowType: XLFormRowDescriptorTypeMultipleSelector, title: "USDT")
        //        row.isRequired = true
        row.selectorTitle = "USDT-交易对"
        row.selectorOptions = XJH_UserModel.sharedInstance.wholeChange?.coinUSDT
        row.value = creatform ? [] : currentMod?.coinUSDT
        section.addFormRow(row)
        
        ///一组开始
        section = XLFormSectionDescriptor.formSection(withTitle: "合约-交易对")
        form.addFormSection(section)
        
        //
        row = XLFormRowDescriptor(tag: Tags.futures, rowType: XLFormRowDescriptorTypeMultipleSelector, title: "选择合约")
        row.selectorOptions = XJH_UserModel.sharedInstance.wholeChange?.futures
        row.value = creatform ? [] : currentMod?.futures
        row.selectorTitle = "选择合约"
        //        row.isRequired = true
        section.addFormRow(row)
        
        self.form = form
        
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        if self.creatform {
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "创建", style: .plain, target: self, action: #selector(XJHXJHFileFormVC.savePressed(_:)))
            
            self.initializeForm()
        }else{
            
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "操作", style: .plain, target: self, action: #selector(XJHXJHFileFormVC.addDidTouch(_:)))
            
            xjh_PrigetFileData()
        }
        self.title = titleStr
        
    }
    
    ///获取远程数据
    func xjh_PrigetFileData(){
        XJHProgressHUD.show()
        //获取文件 转mod
        XJH_GitHub.GitHubProjectPathFiledict(pathUrl: GitHubBaseUrl + fileModel!.path, blockSuccess: { (mod) in
            
            //转变model
            XJH_GitHub.GitHubProject_getFileContentMod(mod: mod, blockSuccess: { (mos) in
                
                XJHProgressHUD.hide()
                self.currentMod = mos
                
                self.initializeForm()
                
            }) { (err) in
                
                XJHProgressHUD.hide()
                
                XJHProgressHUD.showError(message: err.message, view: self.view)
            }
            
        }) { (errs) in
            XJHProgressHUD.hide()
            
            XJHProgressHUD.showError(message: errs.message, view: self.view)
            
        }
        
    }
    
    @objc func savePressed(_ sender: UIBarButtonItem) {
        self.saveOrDeletePressed(save: true)
    }
    
    @objc func addDidTouch(_ sender: UIBarButtonItem) {
        
        self.view.endEditing(true)
        
        BaseAlertController.showAlertSheet(actions: ["保存修改","删除用户","取消"], vc: self, redtypeShow: 2) { (str, tag) in
            
            if tag == 0{
                self.saveOrDeletePressed(save: true)
            }else if tag == 1 {
                
                AdminLogic.Xjh_AdminPassworldValidation(blockSuccess: {
                    
                    self.saveOrDeletePressed(save: false)
                })
                
            }
            
        }
    }
    
    func saveOrDeletePressed(save:Bool)
    {
        
        if !save {
            //删除
            XJHProgressHUD.show(view: self.view)
            
            XJH_GitHub.Github_UpdateFileWith(.delete, sha: self.fileModel!.sha, content: [:], path: self.fileModel!.path, blockSuccess: {
                XJHProgressHUD.hide()
                XJHProgressHUD.showSuccess(message: "删除成功")
                
                self.navigationController?.popViewController(animated: true)
            }) { (err) in
                XJHProgressHUD.hide()
                XJHProgressHUD.showError(message: "删除失败",view: self.view)
            }
            
            
            return
        }
        
        let validationErrors : Array<NSError> = self.formValidationErrors() as! Array<NSError>
        if (validationErrors.count > 0){
            
            XJHProgressHUD.showError(message: "数据不完整，请检查")
            
            return
        }
        
        
        //保存
        let value:Dictionary<String,Any> = self.formValues() as! Dictionary<String, Any>
        
        //执行方案2
        let program = XJH_UserModel.sharedInstance.AdminChangeUserFileProgram
        switch program {
        case 1:
            AdminLogic.Xjh_AdminChangeUserFileProgram_One(creatform: creatform, value: value, fileModel: fileModel, currentMod: currentMod, blockSuccess: {
                
                self.navigationController?.popViewController(animated: true)
                
            }) {
                
            }
        case 2:
            AdminLogic.Xjh_AdminChangeUserFileProgram_Two(creatform: creatform, value: value, fileModel: fileModel, currentMod: currentMod, blockSuccess: {
                
                self.navigationController?.popViewController(animated: true)
                
            }) {
                
            }
        case 3:
            AdminLogic.Xjh_AdminChangeUserFileProgram_Three(creatform: creatform, value: value, fileModel: fileModel, currentMod: currentMod, blockSuccess: {
                
                self.navigationController?.popViewController(animated: true)
                
            }) {
                
            }
        default:
            AdminLogic.Xjh_AdminChangeUserFileProgram_Two(creatform: creatform, value: value, fileModel: fileModel, currentMod: currentMod, blockSuccess: {
                
                self.navigationController?.popViewController(animated: true)
                
            }) {
                
            }
        }
        
        
        
    }
    
}
