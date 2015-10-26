//
//  UnReaderStatus.swift
//  SinaWeibo
//
//  Created by jiang on 15/10/10.
//  Copyright © 2015年 jiang. All rights reserved.
//

import UIKit

class UnReaderStatus: NSObject {
    
    


    var photo: Int? = 0

    var mention_cmt: Int? = 0

    var badge: Int? = 0

    var mention_status: Int? = 0

    var dm: Int? = 0

    var group: Int? = 0

    var msgbox: Int? = 0

    var private_group: Int? = 0
    
    //未读微博条数
    var status: Int? = 0

    var cmt: Int? = 0
    
    
    //字典转模型
    init(dict:[String : AnyObject]){
        super.init()
        
        setValuesForKeysWithDictionary(dict)
        
    }
    //过滤掉没有用到的字段
    override func setValue(value: AnyObject?, forUndefinedKey key: String) { }
    
    //重写 description   需要生写
//    override var description: String {
//        //打印对象格式: 类名:地址
//        //字典 数组 打印都有各式
//        //kvc将对象转换为字典
//        let keys = ["status","photo","mention_cmt","badge","mention_status","dm","group","msgbox","private_group","cmt"]
//        return "\(dictionaryWithValuesForKeys(keys))"
//    }

    


}
