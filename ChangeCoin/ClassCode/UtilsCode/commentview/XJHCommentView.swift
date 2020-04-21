//
//  XJHCommentView.swift
//  xujiahuiCoin
//
//  Created by mac on 2019/10/18.
//  Copyright © 2019 www.xujiahuiCoin.cn. All rights reserved.
//

import UIKit

protocol XJHCommentViewDelegate {
    func XJHCommentViewAction(type:Int, comment:String)
}

///评论view 返回评论String
class XJHCommentView: XJHBaseView,UITextViewDelegate {

    var textview : UITextView!
    var commit_AnNiuButton : UIButton!
    let textview_text = "在此输入评论"
    var commentDelegate : XJHCommentViewDelegate!
    override func initXJHView() {
        
        commit_AnNiuButton = UIButton(frame: .zero)
        commit_AnNiuButton.setTitleColor(.white)
        commit_AnNiuButton.setTitle("评论", for: .normal)
        commit_AnNiuButton.setTitle("取消", for: .selected)
        AddRadius(commit_AnNiuButton, rabF: 4)
        commit_AnNiuButton.titleLabel?.font = FontBold(font: XJHFontNum_Second())
        commit_AnNiuButton.setBackgroundImage(UIImage(color: XJHMainColor), for: .normal)
        commit_AnNiuButton.addTarget(self, action: #selector(committeAction), for: .touchUpInside)
        self.addSubview(commit_AnNiuButton)
        
        textview = UITextView(frame: .zero)
        textview.text = textview_text
        textview.font = Font(font: XJHFontNum_Second())
        textview.textColor = XJHSecondTextColor
        textview.delegate = self
        textview.returnKeyType = .send
        AddRadius(textview, rabF: 4)
        AddBorder(bordV: textview, bordColor: XJHLineColor, bordWidth: 1)
        self.addSubview(textview)
        
        commit_AnNiuButton.snp.makeConstraints { (ma) in
            ma.centerY.equalToSuperview()
            ma.width.equalTo(50)
            ma.height.equalTo(30)
            ma.right.equalTo(-15)
        }
        
        textview.snp.makeConstraints { (ma) in
            ma.centerY.equalToSuperview()
            ma.left.equalTo(10)
            ma.top.equalTo(5)
            ma.bottom.equalTo(-5)
            ma.right.equalTo(commit_AnNiuButton.snp.left).offset(-10)
        }
        
        
    }
    
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        //k
        
        
        if !xjh_isLoginIs() {
//
            self.commentDelegate.XJHCommentViewAction(type: 0, comment: "")
            textview.resignFirstResponder()
            
        }else{
            changeCommiteAction(type: 1)
            
            commit_AnNiuButton.isSelected = true
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            
            //进入提交 返回字符串，收起键盘
            self.commentDelegate.XJHCommentViewAction(type:1, comment: textview.text)
            self.textview.endEditing(true)
            commit_AnNiuButton.isSelected = false
            changeCommiteAction(type: 0)
            return false
        }
        
        return true
    }
    
  
    
  
    
    //开始评论的改变
    func changeCommiteAction(type : Int){
        
        if type == 1{
            //边写评论
            textview.text = ""
            textview.textColor = XJHMainColor
 
        }else{
            
            textview.text = textview_text
            textview.textColor = XJHSecondTextColor

            
        }
        
    }
   
    //评论按钮
   @objc  func committeAction(){
    
    
    if !xjh_isLoginIs() {
        self.commentDelegate.XJHCommentViewAction(type: 0, comment: "")
        return
    }
    
    if commit_AnNiuButton.isSelected {
        
        changeCommiteAction(type: 0)
        textview.endEditing(true)
        commit_AnNiuButton.isSelected = false
    }else{
        
        textview.becomeFirstResponder()
        commit_AnNiuButton.isSelected = true
    }
    
    
    }
    

}
