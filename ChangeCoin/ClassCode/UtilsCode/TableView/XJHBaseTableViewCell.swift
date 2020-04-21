//
//  BaseTableViewCell.swift
//  Project
//
//  Created by mac on 2019/6/12.
//  Copyright © 2019 hhl. All rights reserved.
//

import UIKit

class XJHBaseTableViewCell: UITableViewCell {

    weak var delegate : XJHViewEventsDelegate? {
        
        didSet{
            
            self.initConfig()
        }
    }
    
    required override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {

        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.xjh_initView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /**
     赋值代理（当父View的代理被赋值后，会调用initConfig方法。）
     */
    func initConfig() {}

    func xjh_initView() {
        
    }
    
//    发送代理方法
    func sendViewDelegateEvent(eventObject : ViewEventObject) {
        
        if self.delegate != nil {
            self.delegate!.xjh_UIViewCollectEvent?(eventObject: eventObject)
        }
    }

//    更新cell
    func xjh_updateTableViewCell(datas : ViewDataObject?) {}
}
