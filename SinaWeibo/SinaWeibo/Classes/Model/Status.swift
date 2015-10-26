//
//  Status.swift
//  SinaWeibo
//
//  Created by jiang on 15/10/8.
//  Copyright © 2015年 jiang. All rights reserved.
/*
created_at	string	微博创建时间
id          int64	微博ID
mid         int64	微博MID
idstr       string	字符串型的微博ID
text        string	微博信息内容
source      string	微博来源

*/

import UIKit
import SDWebImage

class Status: NSObject {
    
    var created_at: String?         //微博创建时间
    var id: Int = 0                 //微博ID
    var text: String?               //微博信息内容
    var source: String?             //微博来源
    
    var imageURLs: [NSURL]?
    
    var bmiddle_pic:String?        //大图地址
    
    var user: User?                 //微博作者的用户信息字段
    
    var retweeted_status: Status?   //被转发的原微博信息字段
    
//    var unReaderCount : UnReaderStatus?     //未读信息
    
    var reposts_count:Int = 0        //转发数
    
    var comments_count:Int = 0       //评论数
    
    var attitudes_count:Int = 0      //点赞数
    
    
  
    //微博配图数组
    var pic_urls: [[String : String]]?{
        didSet{
            imageURLs = [NSURL]()
            for dict in pic_urls! {
                let url = NSURL(string:dict["thumbnail_pic"]!)
                imageURLs?.append(url!)
            }
        }
    }
    

    //转发微博只允许发文字  不允许发图片
    var pictureURLs:[NSURL]?{
        if retweeted_status != nil{
            return retweeted_status?.imageURLs
        } else {
            return imageURLs
        }
    }
    
    class func statuses(array: [[String : AnyObject]]) -> [Status]? {
        if array.count == 0 {
            return nil
        }
        
        var items = [Status]()
        for dict in array{
            items.append(Status(dict: dict))
        }
        return items
    }
    
    
     private static let properties = ["created_at","id","text","source","","pic_urls","attitudes_count","comments_count","reposts_count","bmiddle_pic"]
    
    //字典转模型
    init(dict: [String : AnyObject]) {
        super.init()
        
        for key in Status.properties{
            
            if dict[key] != nil{
                 setValue(dict[key], forKeyPath: key)
            }
            
            if dict["user"] != nil{
                
                user = User(dict: dict["user"] as! [String : AnyObject] )
            }
            
            
            //转发微博
            if dict["retweeted_status"] != nil{
                retweeted_status = Status(dict: dict["retweeted_status"] as! [String : AnyObject])
                
            }

        }
 
    }
   
    //获取未读微博条数
    class func loadUnReaderStatusCount(completion:(unReadercount:Int?)->()){
        
        let access_token = sharedAccount?.access_token
        
        if access_token == nil{
            
            return
        }
        
        let uid = sharedAccount?.uid
        
        NetworkTools.sharedTools.loadUnReaderStatusCount(uid: uid!, accessToken: access_token!) { (dict, error) -> () in
            
//            print(dict)
            
            if error == nil {
                
                let unReaderCount = (dict as! NSDictionary)["status"]!

                let count = Int(String(unReaderCount))

                
                completion(unReadercount:count)
                
            }
            
        }
 
    }
    
    //获取首页数据
    class func loadHomeData(sina_id since_id:Int, max_id: Int, completion:(statuses:[Status]?)->()){
        
        

        let access_token = sharedAccount?.access_token
        
        if access_token == nil {
            
            return
        }
        /*
        since_id:若指定此参数，则返回ID比since_id大的微博（即比since_id时间晚的微博），默认为0。
        max_id:若指定此参数，则返回ID小于或等于max_id的微博，默认为0。
        */
//        
        if since_id > 0{

            since_id == since_id
            
        }
        //提前在业务模型中过滤数据
        if max_id > 0{
            
            max_id == max_id - 1
        }
        
        NetworkTools.sharedTools.loadHomeData(since_id, max_id: max_id, accessToken: access_token!) { (dict, error) -> () in
            
//            print("result:",dict)
            
//            print("error",error)
            
            if error == nil{
                
                if let statuses = (dict as! NSDictionary)["statuses"] as? [[String : AnyObject]] {
                    
                    //1.获取图片数组  并缓存图片
//                    print(statuses)
                    let items = Status.statuses(statuses)
                
                    Status.cacheStatusImages(items, completion: completion)

                    
                }else{
                    
                    completion(statuses: nil)
                
                }
            }
        
        }
    }
    
    private class func cacheStatusImages(statuses: [Status]?,completion:(statuses: [Status]?) -> ()){
        
        if statuses == nil {
            return
        }
        //2.把所有的配图视图缓存到本地之后 再回调
        //得到一个群组,当一组异步任务完成后,可以得到统一的回调
        let group = dispatch_group_create()
        //1.遍历微博数据
        for s in statuses as [Status]! {
            // 没有图片继续循环
            if s.pictureURLs == nil {
                continue
            }
            for url in s.pictureURLs! {
                
                //自动下载图片  并且缓存到沙盒目录
                dispatch_group_enter(group)
                
                SDWebImageManager.sharedManager().downloadImageWithURL(url, options: SDWebImageOptions.RetryFailed , progress: nil, completed: { (_, _, _, _, _) -> Void in
                   dispatch_group_leave(group)
                })

            }
        }
        dispatch_group_notify(group, dispatch_get_main_queue()) { () -> Void in
            print("完成所有图片下载path\(NSHomeDirectory())")
            completion(statuses: statuses)
        }
    }
    
    

}
