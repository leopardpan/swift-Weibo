//
//  ComposeController.swift
//  SinaWeibo
//
//  Created by jiang on 15/10/13.
//  Copyright © 2015年 jiang. All rights reserved.
//

import UIKit
import pop

enum ComposeButtonType: Int{
    
    case UP = 1
    case Down = 2
}

var ComposeButtons:[ComposeButton] = []
class ComposeController: UIViewController {
    
    @IBOutlet weak var bgimageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        starAnmi()
        
        setupMenuButton()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        //设置磨砂背景图
        bgimageView.image = getCurrentScreenImage().applyExtraLightEffect()
    }
    
//    @IBAction func textButtonClick(sender: AnyObject) {
//        
//        for menuBtn in ComposeButtons{
//            
//            if menuBtn == sender as! NSObject{
//                
//                menuBtn.transform = CGAffineTransformMakeScale(2.0, 2.0)
//                menuBtn.alpha = 0.1
//            }else{
//                
//                menuBtn.transform = CGAffineTransformMakeScale(0.5, 0.5)
//                menuBtn.alpha = 0.1
//                
//            }
//            
//            
//        }
//
//    }
//    

    func setupMenuButton(){
        
        for button in ComposeButtons{
            
            button.addTarget(self, action: "enmuButtonClick:", forControlEvents: UIControlEvents.TouchUpInside)
            
            
        }
        
    }
    
    func enmuButtonClick(button:ComposeButton){
        
        
        UIView.animateWithDuration(0.25, animations: { () -> Void in
            
            for menuBtn in ComposeButtons{
                
                if menuBtn == button{
                    
                    menuBtn.transform = CGAffineTransformMakeScale(2.0, 2.0)
                    menuBtn.alpha = 0.1
                }else{
                    
                    menuBtn.transform = CGAffineTransformMakeScale(0.5, 0.5)
                    menuBtn.alpha = 0.1
                    
                }
            }
            
            }) { (_) -> Void in
                
                print("转跳到新的控制器")
                self.switchController(button)
        }
    }
    
    func switchController(button:ComposeButton){
        
        switch button.tag {
        case 0:
            print("文字")
            
            let sb = UIStoryboard(name: "ComposeStatus", bundle: nil)
            
            self.presentViewController(sb.instantiateInitialViewController()!, animated: true, completion: nil)
            
//            self.remove
            
            
        case 1:
            
            print("相册")
        case 2:
            
            print("拍摄")
        case 3:
            
            print("签到")
        case 4:
            
            print(4)
        case 5:
            
            print(5)
            
        default: break
            
        }

    }
    
    
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
       let temp = ComposeButtons.reverse()
        var i = 7
        for button in temp{
            i--
            button.composeButtonAnimation(ComposeButtonType.Down, beginTime: Double(i))
            
        }
        
        UIView.animateWithDuration(0.15, delay: 0.05, options: UIViewAnimationOptions.LayoutSubviews, animations: { () -> Void in
            
            self.bgimageView.alpha = 0.0
            }) { (_) -> Void in
                
               self.dismissViewControllerAnimated(true, completion: nil)
                
        }
        
       
//        delay(0.25) { () -> () in
//            
//            delay(0.25, task: { () -> () in
//                
//                self.view.alpha = 0.0
//                
//            })
//            
//        self.dismissViewControllerAnimated(true, completion: nil)
//            
//        }
    
    }
    
    func starAnmi(){
        
    
        for childView in self.view.subviews{
           
            if childView.isKindOfClass(ComposeButton){
                
                ComposeButtons.append(childView as! ComposeButton)
    
             (childView as! ComposeButton).composeButtonAnimation(ComposeButtonType.UP, beginTime: Double(childView.tag))
                
            }
        }
    }
    
    func addChildMenuButton(){
        
        let path = NSBundle.mainBundle().pathForResource("compose.plist", ofType: nil)
        let array = NSMutableArray(contentsOfFile: path!)
        
        var tmpArray:[ComposeButtonInfo] = []
        
        for dict in array!{
            
            tmpArray.append(ComposeButtonInfo(dict: dict as! [String : AnyObject]))
        }

    }
    
    
    
    //获取当前屏幕内容
    func getCurrentScreenImage() ->UIImage{
        
        //获取window
        let window = UIApplication.sharedApplication().keyWindow
        
        //开启图形上下文
        UIGraphicsBeginImageContext((window?.size)!)
        
        //获取上下文
        let ctx = UIGraphicsGetCurrentContext()
        
        //把window渲染到上下文
        window?.layer.renderInContext(ctx!)
        
        //获取图片
        let image = UIGraphicsGetImageFromCurrentImageContext()
        
        
        //关闭上下文
        UIGraphicsEndImageContext()
        
        return image
    }
    
    

}
