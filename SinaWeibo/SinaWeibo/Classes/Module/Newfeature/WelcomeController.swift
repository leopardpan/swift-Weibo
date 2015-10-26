//
//  WelcomeController.swift
//  SinaWeibo
//
//  Created by jiang on 15/10/8.
//  Copyright © 2015年 jiang. All rights reserved.
//

import UIKit
import AFNetworking


class WelcomeController: UIViewController {

    @IBOutlet weak var iconImage: UIImageView!
    
    @IBOutlet weak var iconImageBottom: NSLayoutConstraint!
    
    @IBOutlet weak var welcomeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        if let imageUrlString = sharedAccount?.avatar_large {
            
            let url = NSURL(string: imageUrlString)
//            iconImage.sd_setImageWithURL(url)
            iconImage.setImageWithURL(url!)
        }

       
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        iconImageBottom.constant = view.frame.size.height - iconImageBottom.constant
        
        UIView.animateWithDuration(2, delay: 0, usingSpringWithDamping: 0.65, initialSpringVelocity: 2, options: [], animations: { () -> Void in
            
             self.welcomeLabel.alpha = 0
             self.view.layoutIfNeeded()
            
            }) { (_) -> Void in
                
                UIView.animateWithDuration(0.5, animations: { () -> Void in
                    
                     self.welcomeLabel.alpha = 1
                    
                    }, completion: { (_) -> Void in
                        
                    //转跳到主控制器
                    NSNotificationCenter.defaultCenter().postNotificationName(WBSwitchToRootVC, object: "Main")

                })
                
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
