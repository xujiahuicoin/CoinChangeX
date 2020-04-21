//
//  XJH_AdminVC.swift
//  ChangeCoin
//
//  Created by mac on 2019/12/5.
//  Copyright © 2019 www.xujiahuiCoin.com. All rights reserved.
//

import UIKit
var okex_isoTime2 : String = ""
class XJH_AdminVC: XJHBaseViewController {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    @objc func XJH_GetSupervisionUserInfoMode(){
        XJH_UserDataTool.XJH_GetSupervisionUserInfoMode()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        self.view.backgroundColor = XJHBackgroundColor_dark
        
        getOkexSeverTimes()
    }
    
    ///转化工具
    @IBAction func changeToolAction(_ sender: Any) {
        self.navigationController?.pushViewController(XJHDataAESViewController())
    }
    
    ///合约监控
    @IBAction func monitorAction(_ sender: Any) {
        
        self.navigationController?.pushViewController(XJHMonitorVC())
    }
    
    
    ///云端控制
    @IBAction func adminControllerAction(_ sender: Any) {
        
        self.navigationController?.pushViewController(XJHDocumentPathVC())
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    
   @objc func getOkexSeverTimes(){
        
        XJH_OkExTool().okex_getGeneralTime(blockSuccess: { (str) in
            
            print("----=-----------------------长循环-获取服务器时间--本页数据")
            okex_isoTime2 = str
            self.perform(#selector(self.getOkexSeverTimes), with: nil, afterDelay: getLongTime)
            
        }) { (err) in
            self.perform(#selector(self.getOkexSeverTimes), with: nil, afterDelay: 0.2)
        }
        
    }

    
}
