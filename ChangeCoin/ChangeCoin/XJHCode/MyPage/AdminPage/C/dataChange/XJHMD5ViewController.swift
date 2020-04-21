//
//  XJHMD5ViewController.swift
//  ChangeCoin
//
//  Created by mac on 2019/11/22.
//  Copyright © 2019 www.xujiahuiCoin.com. All rights reserved.
//

import UIKit

class XJHMD5ViewController: XJHBaseViewController,UITextViewDelegate {

    let str1 = "长按复制-加密字段"
    @IBOutlet weak var inPutTextF: UITextView!
    
    @IBOutlet weak var outPutTextF: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "字段MD5操作"
        inPutTextF.text = str1
        inPutTextF.delegate = self

        self.view.backgroundColor = XJHBackgroundColor_dark
        // Do any additional setup after loading the view.
    }
    @IBAction func copyAction(_ sender: Any) {
        
        if outPutTextF.text == "输出字段"{
            xjh_showError_Text(text: "还没有生成加密内容", view: self.view)
            return
        }
        
        let pastboard = UIPasteboard.general
        pastboard.string = outPutTextF.text
        xjh_showSuccess_Text(text: "内容已复制到剪切板", view: self.view)
        
    }
    @IBAction func dealDataAction(_ sender: Any) {
        
        if inPutTextF.text == str1{
            xjh_showError_Text(text: "还没有添加加密内容", view: self.view)
                return
            }
        
        outPutTextF.text = md5Detail(mdString: inPutTextF.text)
    }
    
    @IBAction func closeAction(_ sender: Any) {
        self.dismiss(animated: true) {
                   
               }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == str1 {
            textView.text = ""
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
