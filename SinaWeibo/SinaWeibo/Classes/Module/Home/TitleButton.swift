//
//  TitleButton.swift
//  SinaWeibo
//
//  Created by jiang on 15/10/8.
//  Copyright © 2015年 jiang. All rights reserved.
//

import UIKit

class TitleButton: UIButton {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if self.titleLabel?.text == "首页" {
            return
        }
        
        titleLabel?.frame = CGRectOffset(titleLabel!.frame, -imageView!.frame.width, 0)
        imageView?.frame = CGRectOffset(imageView!.frame, titleLabel!.frame.width, 0)
        
    }



}
