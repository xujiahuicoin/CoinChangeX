//
//  Error.swift
//  Pro
//
//  Created by mac on 2019/6/21.
//  Copyright © 2019 hhl. All rights reserved.
//

import Foundation

struct XJHError : Error {
    
    let code : Int
    var message : String = "获取失败，请稍后重试"
    
}
