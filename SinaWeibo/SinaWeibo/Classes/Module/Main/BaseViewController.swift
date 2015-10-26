//
//  BaseViewController.swift
//  SinaWeibo
//
//  Created by jiang on 15/10/6.
//  Copyright © 2015年 jiang. All rights reserved.
//

import UIKit

class BaseViewController: UITableViewController ,VisitorLoginViewDelegate{
    
    var visitorLoginView :VisitorLoginView?
    
    override func loadView() {
        
        if userLogin {//如果已经登录,直接返回
            
            super.loadView()
            return
            
        }
        
        //执行未登录页面
        
        visitorLoginView = NSBundle.mainBundle().loadNibNamed("VisitorLoginView", owner: nil, options: nil).last as? VisitorLoginView
        
        view = visitorLoginView
        visitorLoginView?.vistorViewDelegate = self;
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "注册", style: UIBarButtonItemStyle.Plain, target: self, action: "visitorWillRegister")
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "登录", style: UIBarButtonItemStyle.Plain, target: self, action: "visitorWillLogin")
        
//         UINavigationBar.appearance().tintColor = UIColor.orangeColor()
        
    }
    
    //3.实现协议方法
    func visitorWillLogin() {
        print(__FUNCTION__)
        
        //转跳到授权登录页面
        let sb = UIStoryboard(name: "OAuth", bundle: nil)
        
       let vc = sb.instantiateInitialViewController() as! UINavigationController
        
        presentViewController(vc, animated: true, completion: nil)
        
        
    }
    func visitorWillRegister() {
        print(__FUNCTION__)
    }

    

    override func viewDidLoad() {
        super.viewDidLoad()

       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
}
