//
//  OAuthController.swift
//  SinaWeibo
//
//  Created by jiang on 15/10/6.
//  Copyright © 2015年 jiang. All rights reserved.
//

import UIKit
import SVProgressHUD

class OAuthController: UIViewController ,UIWebViewDelegate{
    
    @IBOutlet weak var webView: UIWebView!
    //应用ID
    let WB_Client_Id = "2663281959"
    //回调页
    let WB_Redirect_Uri = "http://jh235.cn/"
    //标示码
    let WB_Client_Secret = "0605c4e0e1bad1ef82c3b151b3238f37"

    
//    var webView :UIWebView{
//        get{
//            
//            return view as! UIWebView
//            
//        }
//    }
    
    // MARk - 加载请求授权页
    private func loadOAuthPage() {
        
//        let urlString = "https://api.weibo.com/oauth2/authorize?client_id=" + WB_Client_Id + "&redirect_uri=" + WB_Redirect_Uri
//        
//        let url = NSURL(string: urlString)!
//        webView.loadRequest(NSURLRequest(URL: url))
        
        webView.loadRequest(NSURLRequest(URL: NetworkTools.sharedTools.oAuthURL()))
    }

    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadOAuthPage()
        
        webView.delegate = self

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - webView代理方法
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        
      let urlString = request.URL!.absoluteString
        
        
        if urlString.hasPrefix("https://api.weibo.com/") {
            
            return true
        }
        //过滤无效请求
        if !urlString.hasPrefix(NetworkTools.sharedTools.WB_Redirect_Uri) {
            
            return false
        }
        
        //程序走到这里  就一定包含了重定向的url
        print(urlString)
        //拿到请求授权的code码
        //request.URL?.query 拿到url请求的参数=值
        if let query = request.URL?.query {
            let codeStr = "code="
            //非可选类型的string 可以直接转换为NSString
            let code = (query as NSString).substringFromIndex(codeStr.characters.count)
         
            loadAccessToken(code)
        }
        
        
        return false

    }
    
    //请求token
    private func loadAccessToken(code : String){
        
        NetworkTools.sharedTools.loadAccessToken(code) { (dict, error) -> () in
            
            if error != nil{
                
//                print(error)
                SVProgressHUD.showInfoWithStatus("您的网络不给力")
                return
            }
            //请求成功
            let account = UserAccount(dict: dict!)
            
            print(account)
            
            //获取用户信息
            account.loadUserInfo({ (error) -> () in
                if error != nil{
                    SVProgressHUD.showInfoWithStatus("网络不给力")
                    return
                }
                
            //转跳到主控制器
            NSNotificationCenter.defaultCenter().postNotificationName(WBSwitchToRootVC, object: "Main")
                
                userLogin = true
                
                
                
                
//                self.close(AnyObject)
            })
            
        }
    }
    
    
    
    @IBAction func close(sender: AnyObject) {
        
        dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    
    @IBAction func defaultAccount(sender: AnyObject) {
        
        let strJS = "document.getElementById('userId').value = '1079108859@qq.com';document.getElementById('passwd').value = '19920501.' "
        
//        let strJS = "document.getElementById('userId').value = 'jh235@qq.com';document.getElementById('passwd').value = '19920501.' "
        
//        let strJS = "document.getElementById('userId').value = '15510905510';document.getElementById('passwd').value = 'guo791175282' "
        
        webView.stringByEvaluatingJavaScriptFromString(strJS)
        

    }
    
    override func viewDidDisappear(animated: Bool) {
        SVProgressHUD.dismiss()
        
    }

    
    //开始加载
    func webViewDidStartLoad(webView: UIWebView) {
        
        SVProgressHUD.show()
        
    }
    
    //完成加载
    func webViewDidFinishLoad(webView: UIWebView) {
        
        let strJs = "document.title"
        
       let webTitle = webView.stringByEvaluatingJavaScriptFromString(strJs)
        
        title = webTitle
        
        SVProgressHUD.dismiss()
    }
    
}
