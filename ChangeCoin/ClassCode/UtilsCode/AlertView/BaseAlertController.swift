

import UIKit

class BaseAlertController: UIAlertController {

    ///显示在Root视图上
    static func getRootVC() -> UIViewController {
        
        let root = UIApplication.shared.delegate as! AppDelegate
        
//        root.window?.rootViewController = XJHBaseViewController()
        
        return root.window!.rootViewController!
    }
    
    ///alert:一个按钮-VC 默认：提示 、确定
    static func showAlertOneAction(message : String, title : String = "提示", actionText : String = "确定", vc : UIViewController, FFAction : @escaping() ->()) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title:actionText, style: .default, handler: { (action) in
            
            FFAction()
            
        }))
        
        vc.present(alert,animated: true)
        
    }
    
    ///alert:两个按钮-VC 默认：提示 、取消、确定
    static func showAlertTwoAction(message : String, title : String = "提示", actionTextOne : String = "取消",actionTextTwo : String = "确定", vc : UIViewController, FFActionOne : @escaping() ->(),FFActionTwo : @escaping() ->()) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title:actionTextOne, style: .cancel, handler: { (action) in
            
            FFActionOne()
            
        }))
        
        alert.addAction(UIAlertAction(title:actionTextTwo, style: .default, handler: { (action) in
            
            FFActionTwo()
            
        }))
        
        
        vc.present(alert,animated: true)
        
    }
    
    
    ///alert: Sheet列表
    static func showAlertSheet(title : String = "",message : String = "", actions : Array<String>, vc : UIViewController, redtypeShow : Int, alertAction : @escaping(_ title : String,_ index: Int) ->() ) {
        
        let alert = UIAlertController(title: title.count > 0 ? title : nil, message: message.count > 0 ? message : nil, preferredStyle: .actionSheet)
    
        for index in 0...actions.count-1 {
            
            let str = actions[index]
            
            alert.addAction(UIAlertAction(title: str, style: (index == actions.count-1) ? .cancel : .default, handler: { (action) in
                
                //找出index  排除最后一个
                for index in 0...actions.count-2 {
                    
                    if action.title == actions[index] {
                        alertAction(action.title!,index)
                    }
                    
                }
               
            }))
            
        }
        
        
         vc.present(alert,animated: true)
        
    }
    
    ///alert：输入框
    static func showAlertTextField(title : String = "",message : String = "", actionTextOne : String = "取消",actionTextTwo : String = "确定",placeholder:String = "", vc : UIViewController, FFActionOne : @escaping() ->(),FFActionTwo : @escaping(_ textOne:String) ->()) {
           
             let alert = UIAlertController(title: title.count > 0 ? title : nil, message: message.count > 0 ? message : nil, preferredStyle: .alert)
        
        alert.addTextField { (textField) in
//            textField.backgroundColor = XJHBackgroundColor_dark
            textField.placeholder = placeholder
            textField.layer.cornerRadius = 5
            textField.textColor = XJHMainTextColor_dark
            textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 20))
            
        }
        
        
        alert.addAction(UIAlertAction(title:actionTextOne, style: .cancel, handler: { (action) in
                   
                   FFActionOne()
                   
               }))
               
        alert.addAction(UIAlertAction(title:actionTextTwo, style: .default, handler: { (action) in
                   
            let textfield = alert.textFields?.first
            
            FFActionTwo(textfield?.text ?? "")
                   
               }))
        
           
            vc.present(alert,animated: true)
           
       }
  
}
