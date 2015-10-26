//
//  VisitorLoginView.swift
//  SinaWeibo
//
//  Created by jiang on 15/10/6.
//  Copyright © 2015年 jiang. All rights reserved.
//

import UIKit

//代理
protocol VisitorLoginViewDelegate: NSObjectProtocol{
    
    //注册
    func visitorWillRegister()
    //登录
    func visitorWillLogin()
    
}


class VisitorLoginView: UIView {
    
    //代理协议
    weak var vistorViewDelegate: VisitorLoginViewDelegate?
    
    
    @IBOutlet weak var iconImage: UIImageView!
    
    @IBOutlet weak var descLabel: UILabel!
    
    @IBOutlet weak var smallIconImage: UIImageView!
    
    func setUIInfo(imageName name:String, descText : String, isHome:Bool = false){
        
        iconImage.image = UIImage(named: name)
        
        descLabel.text = descText
        
        smallIconImage.hidden = !isHome
        
        if isHome{
            startAnimation()
        }
        
    }
    
    // MARK: 转动动画
    private func startAnimation(){
        
        let anim = CABasicAnimation(keyPath: "transform.rotation")
        
        anim.repeatCount = MAXFLOAT
        anim.duration = 15
        anim.toValue = 2 * M_PI
        //当动画页面处于非活跃状态下默认会移除图层
        anim.removedOnCompletion = false
        smallIconImage.layer.addAnimation(anim, forKey: nil)
  
    }
    
    
    //登录
    @IBAction func loginButton(sender: AnyObject) {
        
        vistorViewDelegate?.visitorWillLogin()
    }
    
    //注册
    @IBAction func registerButton(sender: AnyObject) {
        
        vistorViewDelegate?.visitorWillRegister()
    
    }
    
    



}
