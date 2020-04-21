//
//  XJH_Okex_LeveragePickerVC.swift
//  ChangeCoin
//
//  Created by mac on 2019/11/11.
//  Copyright © 2019 www.xujiahuiCoin.com. All rights reserved.
//

import UIKit

class XJH_Okex_LeveragePickerVC: XJHBaseViewController {
    
    ///当前的倍数
    var currentLeverage : String!
    ///当前的合约信息
    var underlying : String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "设置杠杆倍数"
        
        XJH_Pri_creatUI()
        
    }
    
    func XJH_Pri_creatUI(){
        
        self.view.addSubview(XJH_lblTop)
        self.view.addSubview(XJH_Left_Lab)
        self.view.addSubview(XJH_Right_lab)
        self.view.addSubview(picker)
        self.view.addSubview(XJH_BtnCommit)
        
        XJH_Right_lab.text = "\(XJH_UserModel.sharedInstance.leverageMax)"
        XJH_Left_Lab.text = "\(XJH_UserModel.sharedInstance.leverageMin)"
        
        XJH_BtnCommit.setTitle("当前 \(Int(currentLeverage)) 倍", for: .normal)
        
        XJH_lblTop.snp.makeConstraints { (ma) in
            ma.top.equalToSuperview().offset(navHeight)
            ma.width.equalTo(270)
            ma.centerX.equalToSuperview()
        }
        
        XJH_Left_Lab.snp.makeConstraints { (ma) in
            ma.left.equalTo(40)
            ma.top.equalTo(XJH_lblTop.snp.bottom).offset(60)
        }
        
        XJH_Right_lab.snp.makeConstraints { (ma) in
            ma.right.equalTo(-40)
            ma.top.equalTo(XJH_Left_Lab)
        }
        
        
        picker.snp.makeConstraints { (ma) in
            ma.top.equalTo(XJH_Right_lab.snp.bottom).offset(20)
            ma.left.equalTo(XJH_Left_Lab)
            ma.right.equalTo(XJH_Right_lab)
            ma.height.equalTo(30)
        }
        
        XJH_BtnCommit.snp.makeConstraints { (ma) in
            ma.top.equalTo(picker.snp.bottom).offset(60)
            ma.width.equalTo(SCREEN_WIDTH-60)
            ma.height.equalTo(50)
            ma.centerX.equalToSuperview()
        }
        
        
        //如果 舍得的大于管理要求的执行
        if Int(currentLeverage)! > Int(XJH_UserModel.sharedInstance.leverageMax){
            
            valueChanged()
        }
    }
    
    
    @objc func valueChanged() {

        let str = "\(Int(picker.value))"
        XJH_BtnCommit.setTitle("设置 \(str) 倍", for: .normal)
        currentLeverage = str
    }
    
    //提交acton
    @objc func XJH_Pri_BtnCommitAction(){
        
        xjh_OkexApiFutures.okex_FuturesGetOrSetFuturesLeverage(underlying: underlying, getYes: false, leverage: currentLeverage, blockSuccess: { (mod) in
            
           
                DispatchQueue.main.async(execute: {
                     if mod.result == true {
                    self.xjh_showSuccess_Text(text: "设定杠杆倍数成功", view: self.view)
                   //通知 杠杆改变了
                        NotificationCenter.default.post(name: NSNotification.Name(Okex_NotificationAction.noti_ChangeFuturesLeverage.rawValue), object: nil)
                        //返回上一页
                        self.perform(#selector(self.goLeftVC), with: self, afterDelay: hudShowTime)
                         
                     }else{
                        
                    }
                })
        
            
        }) { (err) in
            
            DispatchQueue.main.async(execute: {
                self.xjh_showError_Text(text: err.message, view: self.view)
            })
            
        }
        
    }
    
    //---------------UI---------------------
    
    ///提交按钮
    lazy var XJH_BtnCommit: UIButton = {
        let btn = UIButton(Xframe: .zero, title: "设置", titleColor: .white, font: Font(font: XJHFontNum_Main()), backgroundColor: XJHButtonColor_Blue,cornerRadius: 4)
        btn.addTarget(self, action: #selector(XJH_Pri_BtnCommitAction), for: .touchUpInside)
        return btn
    }()
    
    
    lazy var XJH_lblTop: UILabel = {
        
        let lab = UILabel(Xframe: .zero, text: "滑动设置杠杆倍数,当前持有挂单，不可设置", font: FontBold(font: XJHFontNum_Max()), textColor: XJHMainTextColor_dark, backgroundColor: .clear,line:2)
        return lab
    }()
    
    lazy var XJH_Right_lab: UILabel = {
        let lab = UILabel(Xframe: .zero, text: "", font: FontBold(font: XJHFontNum_Max()), textColor: XJHMainTextColor_dark, backgroundColor: .clear)
        return lab
    }()
    
    lazy var XJH_Left_Lab : UILabel = {
        let lab = UILabel(Xframe: .zero, text: "", font: FontBold(font: XJHFontNum_Max()), textColor: XJHMainTextColor_dark, backgroundColor: .clear)
        return lab
    }()
    
    lazy var picker: BalloonPickerView = {
        
        let picker = BalloonPickerView(frame: .zero)
        let balloonView = BalloonView()
        balloonView.image = #imageLiteral(resourceName: "balloon")
        picker.baloonView = balloonView
        //当前倍数
        picker.value = (Double(currentLeverage)  ?? 0)
        //最大
        picker.maximumValue = XJH_UserModel.sharedInstance.leverageMax
        //最小
        picker.minimumValue = XJH_UserModel.sharedInstance.leverageMin
        
        picker.tintColor = XJHButtonColor_Blue
        picker.addTarget(self, action: #selector(valueChanged), for: .valueChanged)
        
        return picker
        
    }()
    
}
