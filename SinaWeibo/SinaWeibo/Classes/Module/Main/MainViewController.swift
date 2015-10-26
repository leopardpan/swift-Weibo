//
//  MainViewController.swift
//  SinaWeibo
//
//  Created by jiang on 15/9/29.
//  Copyright © 2015年 jiang. All rights reserved.
//

import UIKit

class MainViewController: UITabBarController {
    
    @IBOutlet weak var mainTabBar: MainTabBar!
    
       override func viewDidLoad() {
        super.viewDidLoad()
        
        mainTabBar.composeButton.addTarget(self, action: "composeButtonClick", forControlEvents: UIControlEvents.TouchUpInside)
        
        //添加子控制器
        addChildViewControllers()
  
        
    }
    //添加所有控制器
    func addChildViewControllers() {
        self.tabBar.tintColor = UIColor.orangeColor()
        addChildViewController("Home", title: "首页", imageName: "tabbar_home")
        addChildViewController("Message", title: "消息", imageName: "tabbar_message_center")
        addChildViewController("Discover", title: "发现", imageName: "tabbar_discover")
        addChildViewController("Profile", title: "我", imageName: "tabbar_profile")
        
        
        
    }
    
    func addChildViewController(sbName:String ,title :String, imageName:String) {
        //获取storyboard
        let sb = UIStoryboard(name: sbName, bundle: nil)
        
        let nav = sb.instantiateInitialViewController() as! UINavigationController
        
        //设置title
        nav.topViewController?.title = title
        
        //设置image
//        nav.tabBarItem.image = UIImage(named: imageName)?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        
        nav.tabBarItem.image = UIImage(named: imageName)
        
        //添加
        addChildViewController(nav)
        
    }
    
    func composeButtonClick(){
        
        print("composeButton点击了")
        
        let sb = UIStoryboard(name: "Compose", bundle: nil)
        
        self.presentViewController(sb.instantiateInitialViewController()!, animated: true, completion: nil)
//        UIApplication.sharedApplication().keyWindow?.rootViewController = sb.instantiateInitialViewController() as! ComposeController
        
        
//        let vc = sb.instantiateInitialViewController() as! ComposeController
        
//        vc.starAnmi()
  
    }
    
   


}
