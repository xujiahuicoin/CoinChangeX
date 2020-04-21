//
//  NoDataView.swift
//  Pro
//
//  Created by LonelyTown on 2019/6/24.
//  Copyright © 2019 hhl. All rights reserved.
//

import UIKit

class XJHNoDataView: UIView {

    var nodataDesc : String = ""
    var nodataImageName : String = ""
    
    func configViews(){
        //nodataImage
        let imageView:UIImageView = UIImageView.init(image: UIImage.init(named: "nodate"))
        imageView.contentMode = .scaleAspectFill
        imageView.center = self.center
        self.addSubview(imageView)
        
        //nodataLabel
        let message:UILabel = UILabel.init(frame: .zero, text: nodataDesc, font: .systemFont(ofSize: 16.0), color: .darkGray, alignment: .center, lines: 1)
        
        self.addSubview(message)
        
        message.snp.makeConstraints { (make) in
            make.top.equalTo(imageView.snp_bottomMargin).offset(8)
            make.centerX.equalToSuperview()
        }
    }
    
}

extension XJHNoDataView {
    static func noDataViewWithParams(des:String,imageName:String) -> XJHNoDataView{
        let view = XJHNoDataView()
        
//        view.viewFrame = frame
        view.nodataDesc = des
        view.nodataImageName = imageName == "" ? "logo" : imageName
        view.configViews()
        return view
    }
}
