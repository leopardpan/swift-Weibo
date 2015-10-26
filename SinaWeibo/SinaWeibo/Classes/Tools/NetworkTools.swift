//
//  NetworkTools.swift
//  SinaWeibo
//
//  Created by jiang on 15/10/7.
//  Copyright © 2015年 jiang. All rights reserved.
//

import UIKit
import AFNetworking

//网络请求方式
enum HTTPMethod: String{
    
    case GET = "GET"
    case POST = "POST"
}

//线上接口
private let APP_ROOT_URL = "https://api.weibo.com/"

//测试接口
//private let APP_ROOT_URL = "https://192.168.25.10:8080"




class NetworkTools: AFHTTPSessionManager {
    
    ///应用信息
    //应用ID
    let WB_Client_Id = "2663281959"
    //回调页
    let WB_Redirect_Uri = "http://jh235.cn/"
    //标示码
    let WB_Client_Secret = "0605c4e0e1bad1ef82c3b151b3238f37"

    
    
    ///网络单例
    static let sharedTools:NetworkTools = {
        let url = NSURL(string: APP_ROOT_URL)
        let tool = NetworkTools(baseURL: url)
        
         //AFN反序列化 默认支持 @"application/json", @"text/json", @"text/javascript"
        tool.responseSerializer.acceptableContentTypes?.insert("text/plain")
        
        return tool;
        
    }()
    
    /**
    oAuth请求地址
    */
    func oAuthURL() -> NSURL {
        let pageURL = "https://api.weibo.com/oauth2/authorize"
        let urlString = pageURL + "?" + "client_id=" + WB_Client_Id + "&redirect_uri=" + WB_Redirect_Uri
        return NSURL(string: urlString)!
    }
    
    // MARK: - 请求用户AccessToken
    func loadAccessToken(code: String,completion:(dict:[String : AnyObject]?,error: NSError?) -> ()){
        let urlStr = "oauth2/access_token"
        
       let pramas = ["client_id":WB_Client_Id,"client_secret":WB_Client_Secret,"grant_type":"authorization_code","code":code,"redirect_uri":WB_Redirect_Uri]
        
        requestJSON(.POST, urlString: urlStr, parmas: pramas, completion: completion)
    }
    
    // MARK: - 获取用户信息
    func loadUserInfo(accessToken: String, uid: String,completion:(dict:[String : AnyObject]?,error: NSError?) -> ()){
        
        let urlString = "2/users/show.json"
        let params = ["access_token":accessToken,"uid":uid]
        
        requestJSON(.GET, urlString: urlString, parmas: params, completion: completion)
    }
    
    //获取首页数据
    func loadHomeData(since_id:Int, max_id: Int, accessToken:String, comoletion:(dict:[String : AnyObject]?,error:NSError?) -> ()){
        
        let urlString = "2/statuses/friends_timeline.json"
//         let pramas = ["access_token":accessToken]
        let pramas = ["access_token":accessToken,"since_id" :since_id ,"max_id" :max_id]
        print("---->",pramas as! [String : AnyObject])
        
        requestJSON(.GET, urlString: urlString, parmas: pramas as? [String : AnyObject] , completion: comoletion)
        
    }
    
    //获取未读微博条数
    
    func loadUnReaderStatusCount(uid uid: String, accessToken:String,completion:(dict:[String : AnyObject]?,error:NSError?) -> ()){
        
        let urlString = "2/remind/unread_count.json"
//        let urlString = "2/users/show.json"
        let params = ["access_token":accessToken,"uid":uid]
        
        requestJSON(.GET, urlString: urlString, parmas: params, completion: completion)
    
    
    }
    
    
    
    //MARK: - 封装AFN
    /**
    AFN封装
    
    - parameter method:     请求方式
    - parameter urlString:  请求地址
    - parameter parmas:     参数字典
    - parameter completion: 回调
    */
    func requestJSON(method:HTTPMethod, urlString:String, parmas: [String : AnyObject]? = nil,completion:(dict:[String : AnyObject]?,error: NSError?) -> ()){
        
        //成功的闭包
        let successCallBack = {(tast:NSURLSessionDataTask, result:AnyObject) ->() in
          
            //要对网络非法数据进行判断
            if let info = result as? [String : AnyObject]{
                
                completion(dict: info, error: nil)
                
        } else {
                
            completion(dict: nil, error: NSError(domain: "com.baidu.dataerror", code: -10001, userInfo: ["error":"数据不合法"]))
            print("数据不合法")
        }
            
        }
        //失败的闭包
        let failureCallBack = {(tast:NSURLSessionDataTask, error:NSError) ->() in
            
            completion(dict: nil, error: error)
            print(error)
        }
        
        if method == HTTPMethod.GET {
            
            GET(urlString, parameters: parmas, success: successCallBack, failure: failureCallBack)
            
        }else{
            
            POST(urlString, parameters: parmas, success: successCallBack, failure: failureCallBack)
        }

    }

}
