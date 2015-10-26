//
//  MainTabBar.swift
//  SinaWeibo
//
//  Created by jiang on 15/9/29.
//  Copyright © 2015年 jiang. All rights reserved.
//

import UIKit

class MainTabBar: UITabBar {

    override func layoutSubviews() {
        super.layoutSubviews()
        
        var index: CGFloat = 0;
        
        let w = UIScreen.mainScreen().bounds.width / 5;
        
        let h = self.bounds.height
        
        let frame = CGRectMake(0, 0, w, h)
        
        for view in self.subviews{
            
            if view is UIControl && !(view is UIButton){
                
          
                view.frame = CGRectOffset(frame, index * w, 0)
                
                if index == 1 {
                   index++
                }
                index++
         
            }
   
        }
        //设置撰写按钮的位置
        composeButton.frame = CGRectOffset(frame, 2 * w, 0)
    }
    
    lazy var composeButton:UIButton = {
        let button = UIButton(type: UIButtonType.Custom)
        
        button.setImage(UIImage(named: "tabbar_compose_icon_add"), forState: UIControlState.Normal)
        button.setImage(UIImage(named: "tabbar_compose_icon_add_highlighted"), forState: UIControlState.Highlighted)
        
        button.setBackgroundImage(UIImage(named: "tabbar_compose_button"), forState: UIControlState.Normal)
        button.setBackgroundImage(UIImage(named: "tabbar_compose_button_highlighted"), forState: UIControlState.Highlighted)
        
       self.addSubview(button)
        
        return button
        
    }()

}
