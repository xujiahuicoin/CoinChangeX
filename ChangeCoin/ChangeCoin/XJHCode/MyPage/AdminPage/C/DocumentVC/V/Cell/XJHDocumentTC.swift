//
//  XJHDocumentTC.swift
//  ChangeCoin
//
//  Created by mac on 2019/12/18.
//  Copyright © 2019 www.xujiahuiCoin.com. All rights reserved.
//

import UIKit

class XJHDocumentTC: UITableViewCell {

    @IBOutlet weak var typeImageV: UIImageView!
    
    @IBOutlet weak var pathLabel: UILabel!
    
    
    func updateCellData(mod:XJh_GithubProjectContentsModel){
        if mod.type == "dir" {
            typeImageV.image = UIImage(named: "document_dir")
        }else{
            typeImageV.image = UIImage(named: "document_file")
        }
        pathLabel.text = "../\(mod.name)"
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.contentView.backgroundColor = XJHMainColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
