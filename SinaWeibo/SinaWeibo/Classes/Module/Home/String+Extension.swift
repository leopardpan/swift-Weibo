//
//  String+Extension.swift
//  SwiftExtension
//
//  Created by jiang on 15/10/8.
//  Copyright © 2015年 jiang. All rights reserved.
//

import Foundation
import UIKit

extension String{

    /** 获取字符串长度 */
    var length: Int {return self.characters.count}
    
    
    
    /** 截取字符串 */
    
    /** 从index开始 */
    func jh_SubstringFromIndex(index: Int) -> String?{

        if(index >= self.length) {return nil}
        
        let indexForStringDotIndex = self.startIndex.advancedBy(index)

        return self.substringFromIndex(indexForStringDotIndex)
    }

    /** 用一个range截取 */
    func jh_SubstringWithRange(range: Range<Int>) -> String?{
        
        if(range.endIndex >= self.length) {return nil}
        
        let zeroIndexForStringDotIndex = self.startIndex
        
        let start = zeroIndexForStringDotIndex.advancedBy(range.startIndex)
        let end = zeroIndexForStringDotIndex.advancedBy(range.endIndex)
        
        let rangeForStringDotIndex = Range(start: start, end: end)
        
        return self.substringWithRange(rangeForStringDotIndex)
    }
    

    /** 用一个一个开始字符串和结束字符截取 */
    
    func jh_cutStringWitStarStringAndEndString(startString:String,endString:String) ->String{
        
        let str = self as NSString
        
        let rang = str.rangeOfString(startString)
        
        if rang.location != NSNotFound{
            
            let loction = rang.location + rang.length
            
            let length = str.rangeOfString(endString).location - loction
            
            let result = str.substringWithRange(NSMakeRange(loction, length))
            return result
        }else{
            print("截取失败")
            return " "
        }

    }
//
  

    var isNotEmpty: Bool{return !self.isEmpty}

    /** 时间戳转格式化的时间字符串 */
    func timestamp(format format: String) -> String {
        
        let date = NSDate(timeIntervalSince1970: Double(Int(self)!))
        
        let formatter = NSDateFormatter()
        
        formatter.dateFormat = format
        
        return formatter.stringFromDate(date)
    }
    
    ///时间差计算
    func distanceTimeWithBeforeTime() ->String{
        
        let dateForm = NSDateFormatter()
        
        dateForm.dateFormat = "EEE MMM dd HH:mm:ss Z yyyy"
        dateForm.locale = NSLocale.init(localeIdentifier: "en_US")
        if let da = dateForm.dateFromString(self){
            
            let now = NSDate()
            //now即为现在的时间，由于后面的NSCalendar可以匹配系统日期所以不用设置local
            let das = NSCalendar.currentCalendar()
            
            let flags = NSCalendarUnit(rawValue: UInt.max)
            
            //创建当前和需要计算的components
            let nowCom = das.components(flags, fromDate: now)
            let timeCom = das.components(flags, fromDate: da)
            
            //components有之前设置的格式的各种参数
            if timeCom.year == nowCom.year{//今年
                
                if timeCom.month == nowCom.month{ //这个月
                    if timeCom.day == nowCom.day{ //今天
                        if timeCom.hour == nowCom.hour{  //一个小时内
                            if timeCom.minute == nowCom.minute{  //一分钟内
                                return "刚刚"
                            }else{
                                return "\(nowCom.minute - timeCom.minute)分钟前"
                            }
                        }else{
                            return "今天 \(timeCom.hour):\(timeCom.minute)"
                        }
                    }else{ //不是今天
                        if nowCom.day - timeCom.day == 1{  //昨天
                            return "昨天 \(timeCom.hour):\(timeCom.minute)"
                        }else{ //不是昨天
                            return "\(nowCom.day - timeCom.day)天前"
                        }
                    }
                    
                }else{ //几个月前
                    
                    return "\(nowCom.month - timeCom.month)月前"
                }
                
            }else{ //去年
                
                return "\(timeCom.year)\(timeCom.month)\(timeCom.day)"
            }
        }
        
        return "来自火星的消息 "
    }

}











