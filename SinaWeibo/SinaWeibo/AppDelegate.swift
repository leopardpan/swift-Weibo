//
//  AppDelegate.swift
//  SinaWeibo
//
//  Created by jiang on 15/9/29.
//  Copyright © 2015年 jiang. All rights reserved.
//

import UIKit
import AFNetworking

var sharedAccount = UserAccount.loadUserAccount()

var WBSwitchToRootVC = "WBSwitchToRootVC"

//用户是否登录
var userLogin = false

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        window?.backgroundColor = UIColor.whiteColor()
        window?.makeKeyAndVisible()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "SwitchToRootVC:", name: WBSwitchToRootVC, object: nil)
        
        showMianInterFace()
        
        if UserAccount.loadUserAccount() != nil{
            userLogin = true
        }
       print(UserAccount.loadUserAccount())
        setThemeColor()
        
       print( NSHomeDirectory())
        
        
        //网络指示器
        AFNetworkActivityIndicatorManager.sharedManager().enabled = true;
        
        //申请用户通知权限
        let setting = UIUserNotificationSettings.init(forTypes: UIUserNotificationType.Badge, categories: nil)
        
        application.registerUserNotificationSettings(setting)

        
        return true
    }
    
    //设置主题颜色
    private func setThemeColor(){
        UINavigationBar.appearance().tintColor = UIColor.orangeColor()
        UITabBar.appearance().tintColor = UIColor.orangeColor()
    }
    
    func SwitchToRootVC(notify: NSNotification){
        let sbName = notify.object as! String
        showStroyBoard(sbName)
    }
    
    private func showMianInterFace() {
        var sbName = "Main"
        
        if sharedAccount == nil {
            sbName = "Newfeature"
            isNeedUpdate()
        }
        
        if sharedAccount != nil{
            sbName = isNeedUpdate() ? "Newfeature" : "Welcome"
        }
        showStroyBoard(sbName)
    }
    
    
    private func showStroyBoard(sbName: String){
        
        let sb = UIStoryboard(name: sbName, bundle: nil)
        window?.rootViewController = sb.instantiateInitialViewController()
        
    }
    
    private func isNeedUpdate() -> Bool{
        
        //1.获取当前应用版本
        let currenVersion = NSBundle.mainBundle().infoDictionary!["CFBundleShortVersionString"] as! String
        let versionNum = NSNumberFormatter().numberFromString(currenVersion)!.doubleValue
        
        print("versionNum" , versionNum)
        //2.获取上一次沙盒缓存版本
        let sandBoxKey = "update"
        let userDefaulets = NSUserDefaults.standardUserDefaults()
        let sanboxVersion = userDefaulets.doubleForKey(sandBoxKey)
        
        print("sanboxVersion:",sanboxVersion)
        
        //3.立马把当前版本缓存到本地
        userDefaulets.setDouble(versionNum, forKey: sandBoxKey)
        
        //比较
        return versionNum > sanboxVersion
    }
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

