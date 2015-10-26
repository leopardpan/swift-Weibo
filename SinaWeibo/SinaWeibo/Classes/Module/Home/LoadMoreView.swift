//
//  LoadMoreView.swift
//  SinaWeibo
//
//  Created by jiang on 15/10/10.
//  Copyright © 2015年 jiang. All rights reserved.
//

import UIKit

class LoadMoreView: UIView {
    
    class func loadMoreView() ->LoadMoreView{
        
        return NSBundle.mainBundle().loadNibNamed("LoadMoreView", owner: nil, options: nil).first as! LoadMoreView
        
    }

}
