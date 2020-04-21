//
//  XJHDataAESViewController.swift
//  ChangeCoin
//
//  Created by mac on 2019/11/21.
//  Copyright © 2019 www.xujiahuiCoin.com. All rights reserved.
//

import UIKit



class XJHDataAESViewController: XJHBaseViewController,UITextViewDelegate {

    
    let str1 = "加密字段"
    let str2 = "key字段"
    let str3 = "输出字段"
    
    
    @IBOutlet weak var inputTextV: UITextView!
    
    @IBOutlet weak var keyTextV: UITextView!
    
    @IBOutlet weak var outPutTextV: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        self.title = "ApiKey导出密钥"
        // Do any additional setup after loading the view.
        
        inputTextV.text = str1
        keyTextV.text = str2
        outPutTextV.text = str3
        
        inputTextV.delegate = self
        keyTextV.delegate = self
        outPutTextV.delegate = self
        
        self.view.backgroundColor = XJHBackgroundColor_dark
    }

    
    @IBAction func actionBtn(_ sender: Any) {
        
        outPutTextV.text = aesTools.stringToAES(with: inputTextV.text, keyString: keyTextV.text)
    }
    
    @IBAction func closeAction(_ sender: Any) {
        
        self.dismiss(animated: true) {
            
        }
        
    }
    
    @IBAction func copyActions(_ sender: Any) {
        
        if outPutTextV.text == "输出字段"{
            xjh_showError_Text(text: "还没有生成加密内容", view: self.view)
            return
        }
        
        let pastboard = UIPasteboard.general
        pastboard.string = outPutTextV.text
        
        xjh_showSuccess_Text(text: "内容已复制到剪切板", view: self.view)
    }
    
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == str1 || textView.text == str2 || textView.text == str3 {
            
            textView.text = ""
        }
    }
    

    @IBAction func passWorddealBtnAction(_ sender: Any) {
        self.present(XJHMD5ViewController(), animated: true, completion: nil)
        
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
