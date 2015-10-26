//
//  User.swift
//  SinaWeibo
//
//  Created by jiang on 15/10/8.
//  Copyright © 2015年 jiang. All rights reserved.
//

import UIKit

class User: NSObject {
    
    var id: Int = 0
    ///友好显示名称
    var name: String?
    
    //用户头像地址（中图），50×50像素
    var profile_image_url: String?{
        didSet{
            iconURL = NSURL(string: profile_image_url!)
        }
    }
    
    var iconURL: NSURL?
    
    /// 是否是微博认证用户，即加V用户，true：是，false：否
    var verified: Bool = false
    
    ///  认证类型 -1：没有认证，0，认证用户，2,3,5: 企业认证，220: 草根明星
    var verified_type = -1
    
    
    
    ///会员类型,如果当前这个值大于第于2的话,就代表是会员
    var mbtype:Int = 0
    
    ///会员等级: 如果会员类型大于等于2的话,才有用
    var mbrank:Int = 0
    
    /// 是否是会员
    var VIP:Bool = false
    
    
    private static let properties = ["id","name","profile_image_url","verified","verified_type","mbtype","mbrank"]
    
    // 加载首页微博数据
    init(dict: [String : AnyObject]){
        //初始化
        super.init()
        //字典转模型
        for key in User.properties{
            if dict[key] != nil{
                setValue(dict[key], forKeyPath: key)
            }
        }
    }


}
