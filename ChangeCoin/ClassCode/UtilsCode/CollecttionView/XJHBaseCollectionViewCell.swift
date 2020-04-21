//
//  BaseCollectionViewCell.swift
//  Project
//
//  Created by mac on 2019/6/13.
//  Copyright © 2019 hhl. All rights reserved.
//

import UIKit

class XJHBaseCollectionViewCell: UICollectionViewCell {
    
    weak var delegate : XJHViewEventsDelegate? {
        
        didSet{
            
            self.initBuilds()
        }
    }

    override init(frame: CGRect) {
        
        super.init(frame: frame)
        self.xjh_initCreatView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /**
     赋值代理（当父View的代理被赋值后，会调用initConfig方法。）
     */
    func initBuilds() {}

    func xjh_initCreatView() {
        
    }
    
//    发送代理方法
    func sendViewDelegateEvent(eventObject : ViewEventObject) {
        
        if self.delegate != nil {
            self.delegate!.xjh_UIViewCollectEvent?(eventObject: eventObject)
        }
    }

//    更新cell
    func xjh_updateCollectionDataToCell(datas : ViewDataObject) {}

}
