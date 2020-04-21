//
//  ViewDataObject.swift
//  Project
//
//  Created by mac on 2019/6/12.
//  Copyright © 2019 hhl. All rights reserved.
//

import UIKit

class ViewDataObject: XJHViewObject {

    var datas : Any?

    class func viewData(_ data : Any) -> ViewDataObject {
        
        let viewData = ViewDataObject.init()
        viewData.datas = data
        return viewData
    }
}
