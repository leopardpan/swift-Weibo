//
//  UserAccount.swift
//  SinaWeibo
//
//  Created by jiang on 15/10/7.
//  Copyright © 2015年 jiang. All rights reserved.
//

import UIKit

class UserAccount: NSObject ,NSCoding{
    
    ///用于调用access_token，接口获取授权后的access token。
    var access_token: String?
    
    ///access_token的生命周期，单位是秒数。
    var expires_date: NSDate?
    var expires_in:	NSTimeInterval = 0{
        didSet{
            
            //以当前是时间为基准
            expires_date = NSDate(timeIntervalSinceNow: expires_in)
        }
    }
    ///当前授权用户的UID。
    var uid: String?
    
    ///用户显示名称
    var name: String?
    ///用户头像地址（大图），180×180像素
    var avatar_large: String?
    
    //字典转模型
    init(dict:[String : AnyObject]){
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
        let keys = ["access_token","expires_in","uid","expires_date"]
        return "\(dictionaryWithValuesForKeys(keys))"
    }
    
    //归档的路径 保存到沙盒Document文件夹下
    static let accouthPath = (NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true).last! as NSString).stringByAppendingPathComponent("account.plist")
    
    //将账户信息保存到本地
    func saveAccount(){
    
        NSKeyedArchiver.archiveRootObject(self, toFile: UserAccount.accouthPath)
        
         print(UserAccount.accouthPath)

    }
    
    //对外提供一个调用UserAccount 的方法
    class func loadUserAccount() ->UserAccount?{
        
        if let account = NSKeyedUnarchiver.unarchiveObjectWithFile(UserAccount.accouthPath) as? UserAccount{
            
            //判断是否过期
            if (account.expires_date?.compare(NSDate()) == NSComparisonResult.OrderedDescending){
                
                return account
                
            }
            
        }
        return nil
    }
    
    //加载用户信息
    func loadUserInfo(completion:(error:NSError?)->()){
        
        NetworkTools.sharedTools.loadUserInfo(access_token!, uid: uid!) { (dict, error) -> () in
            
            if error != nil{
                //回调错误信息
                completion(error: error)
                return
            }
            
//            print(dict)
            
            //存储个人信息
            self.name = dict!["name"] as? String
            
            self.avatar_large = dict!["avatar_large"] as? String
            
            //存储自定义对象
            self.saveAccount()
            completion(error: nil)
            
        }
        
    }
    
    //MARK: - 归档解档代理方法
    func encodeWithCoder(aCoder: NSCoder) {
        
        aCoder.encodeObject(access_token, forKey: "access_token")
        aCoder.encodeObject(uid, forKey: "uid")
        aCoder.encodeDouble(expires_in, forKey: "expires_in")
        aCoder.encodeObject(expires_date, forKey: "expires_date")
        aCoder.encodeObject(name, forKey: "name")
        aCoder.encodeObject(avatar_large, forKey: "avatar_large")
    }
    
    required init?(coder aDecoder: NSCoder) {
        
       access_token = aDecoder.decodeObjectForKey("access_token") as? String
       uid = aDecoder.decodeObjectForKey("uid") as? String
       expires_in = aDecoder.decodeDoubleForKey("expires_in")
       expires_date = aDecoder.decodeObjectForKey("expires_date") as? NSDate
       name = aDecoder.decodeObjectForKey("name") as? String
       avatar_large = aDecoder.decodeObjectForKey("avatar_large") as? String
    }
    
    

}
