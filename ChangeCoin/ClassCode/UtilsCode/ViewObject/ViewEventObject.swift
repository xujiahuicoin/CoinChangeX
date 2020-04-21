//
//  xjh_viewEventObject.swift
//  Project
//
//  Created by mac on 2019/6/12.
//  Copyright © 2019 hhl. All rights reserved.
//

import UIKit

class ViewEventObject: XJHViewObject {

    var event_CodeType : String = ""
    var params : Any?
    var uiView : UIView?
    
    class func xjh_viewEventObject(eventType : String) -> ViewEventObject {
        
        let eventObject = ViewEventObject.init()
        eventObject.event_CodeType = eventType
        return eventObject
    }
    
    class func xjh_viewEventObject(eventType : String, params : Any) -> ViewEventObject {
        
        let eventObject = ViewEventObject.init()
        eventObject.event_CodeType = eventType
        eventObject.params = params
        return eventObject
    }

    class func xjh_viewEventObject(eventType : String, params : Any?, uiView : UIView) -> ViewEventObject {

        let eventObject = ViewEventObject.init()
        eventObject.event_CodeType = eventType
        eventObject.params = params
        eventObject.uiView = uiView
        return eventObject
    }

}
