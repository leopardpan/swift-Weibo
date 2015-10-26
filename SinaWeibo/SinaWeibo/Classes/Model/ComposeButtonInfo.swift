//
//  ComposeButtonInfo.swift
//  SinaWeibo
//
//  Created by jiang on 15/10/13.
//  Copyright © 2015年 jiang. All rights reserved.
//

import UIKit

class ComposeButtonInfo: NSObject {
    
    //图片
    var icon:String?
    
    //文字
    var title:String?
    
    
    init(dict:[String: AnyObject]){
        super.init()
        
        setValuesForKeysWithDictionary(dict)
        
    }
    
    //过滤掉没有用到的字段
    override func setValue(value: AnyObject?, forUndefinedKey key: String) { }
    
    //重写 description   需要生写
    override var description: String {
        //打印对象格式: 类名:地址
        //字典 数组 打印都有各式
        //kvc将对象转换为字典
        let keys = ["icon","title"]
        return "\(dictionaryWithValuesForKeys(keys))"
    }

    

}
