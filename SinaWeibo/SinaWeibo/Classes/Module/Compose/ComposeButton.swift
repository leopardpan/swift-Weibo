//
//  ComposeButton.swift
//  SinaWeibo
//
//  Created by jiang on 15/10/13.
//  Copyright © 2015年 jiang. All rights reserved.
//

import UIKit
import pop

class ComposeButton: UIButton {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        imageView?.x = 0
        imageView?.y = 0
        
        imageView?.width = self.width
        imageView?.height = self.width
        
        titleLabel?.x = 0
        titleLabel?.y = CGRectGetMaxY(self.imageView!.frame)
        
        titleLabel?.width = self.width
        titleLabel?.height = self.height - (imageView?.height)!
        
        titleLabel?.textAlignment = NSTextAlignment.Center
        
    }
    
    func composeButtonAnimation(AnimationType:ComposeButtonType, beginTime:Double){
        
       
            let anim = POPSpringAnimation.init(propertyNamed: kPOPViewCenter)
            
            var result: CGFloat = 350.0
            
            if AnimationType ==  ComposeButtonType.Down {
                
                
                result = -350.0
                
            }
            
            anim.toValue = NSValue.init(CGPoint: CGPointMake(self.centerX + 18, self.centerY - result))
            
            anim.springBounciness = 10
            
            anim.springSpeed = 12
            
            anim.beginTime = CACurrentMediaTime() +  beginTime * 0.025
            
//            self.pop_addAnimation(anim, forKey: nil)
        
        }
    
    
    


}
