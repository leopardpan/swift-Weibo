//
//  HomeViewController.swift
//  SinaWeibo
//
//  Created by jiang on 15/9/29.
//  Copyright © 2015年 jiang. All rights reserved.
//

import UIKit

var loadFinish = false

class HomeViewController: BaseViewController{
    
    @IBOutlet weak var titleButton: TitleButton!
    
     var rowHeightCache = NSCache()
    
    //当给成员变量 赋值时  立即调用 reloadata
    var statuses: [Status]? {
        didSet{
            tableView.reloadData()
        }
    }
    
    var unReadercount:Int?{
        didSet{
            tableView.reloadData()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (sharedAccount != nil){
            
            tableView.tableFooterView = LoadMoreView.loadMoreView()
            
            tableView.tableFooterView?.hidden = true
        }
        
       
        
//        tableView.tableHeaderView = UIView()
//        tableView.tableFooterView = UIView()
        
        visitorLoginView?.setUIInfo(imageName: "visitordiscover_feed_image_house", descText: "关注一些人，回这里看看有什么惊喜",isHome:true)
        if sharedAccount != nil {
            titleButton.setTitle(sharedAccount!.name! + " ", forState: UIControlState.Normal)
        } else {
            titleButton.setImage(nil, forState: UIControlState.Normal)
        }
        
        if userLogin{
            
            loadData()
            self.getUnReaderStatus()
        }
        
        //定时器
       let timer = NSTimer.init(timeInterval: 5, target: self, selector: "getUnReaderStatus", userInfo: nil, repeats: true)
        //开始执行
        timer.fire()
        
        //加入主运行循环
        NSRunLoop.currentRunLoop().addTimer(timer, forMode: NSRunLoopCommonModes)

    }
    
    
    //MARK: - 刷新数据
    
    var loadMoreData = false
    @IBAction func loadData() {
        
        refreshControl?.beginRefreshing()
        
      
        
        var since_id = self.statuses?.first?.id ?? 0
        var max_id = 0
        
        if loadMoreData {
            max_id = self.statuses?.last?.id ?? 0
            since_id = 0
        }
        print("since_id:",(since_id),"max_id", (max_id))
        
        if since_id == self.statuses?.first?.id{
            
             self.refreshControl?.endRefreshing()
//             self.showNewStatusLabelWithCount(0)

        }
        
        if max_id == 0 && since_id > 0{
            
            self.showNewStatusLabelWithCount(0)
        }

        
        Status.loadHomeData(sina_id: since_id, max_id: max_id) { (statuses) -> () in
            
             loadFinish = true
           self.refreshControl?.endRefreshing()
           
//            print("1111",statuses?.count)
           
            
            if statuses == nil {
                return
            }
  
            //如果since_id > 0   追加数组 在前面 如果since_id == 0 赋值操作
            //如果 max_id > 0 追加数组 追加在后面
            if max_id > 0{
                self.loadMoreData = false
                self.statuses! += statuses!
                print("加载更多数据完成")
               
                return
            }
           
            if since_id == 0 {
                self.statuses = statuses
//                self.showNewStatusLabelWithCount(0)
            } else {
                
                self.showNewStatusLabelWithCount((statuses?.count)!)
                self.statuses = statuses! + self.statuses!
            }
 
        }
    }
   //MARK: - 上拉加载
    
    func showNewStatusLabelWithCount(count:Int){
        

        let labeltitle:String
        if count == 0 {
             labeltitle = "没有更多数据..."
        }else{
            labeltitle = "刷新出了 \(count) 条数据"
        }
        self.newStatusCountLabel.text = labeltitle
        
        //加入到navigationBar后面
        self.navigationController?.view.insertSubview(self.newStatusCountLabel, belowSubview: (self.navigationController?.navigationBar)!)
        
        //设置动画
        UIView.animateWithDuration(1.0, animations: { () -> Void in
            
            self.newStatusCountLabel.y = CGRectGetMaxY((self.navigationController?.navigationBar.frame)!)

            }) { (_) -> Void in
                
               UIView.animateKeyframesWithDuration(1.0, delay: 1, options: UIViewKeyframeAnimationOptions.LayoutSubviews, animations: { () -> Void in
                self.newStatusCountLabel.y = CGRectGetMaxY((self.navigationController?.navigationBar.frame)!) - self.newStatusCountLabel.height
                
                }, completion: { (_) -> Void in
                    
                    self.newStatusCountLabel.removeFromSuperview()

               })
        }
            
        
    }
    
    //MARK: - 获取未读数据
    func getUnReaderStatus(){
        
      Status.loadUnReaderStatusCount { (unReadercount) -> () in
        
        self.unReadercount = unReadercount
        
        print("coun",unReadercount)
        
//        unReadercount = 10
//         self.navigationController!.tabBarItem.badgeValue = "10"
     
        if unReadercount == 0 {
            
            self.navigationController!.tabBarItem.badgeValue = nil
            UIApplication.sharedApplication().applicationIconBadgeNumber = 0
        }else{
            
            self.navigationController!.tabBarItem.badgeValue = "\(unReadercount!)"
            
            UIApplication.sharedApplication().applicationIconBadgeNumber = unReadercount!
            
            
        }

        }

    }
    

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
   
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        return statuses?.count ?? 0
    }


    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let status = statuses![indexPath.row]
        
        let cell = tableView.dequeueReusableCellWithIdentifier(StatusCell.cellIdtifier(status)) as! StatusCell
        
        cell.status = status
        
        return cell
    }
    
    override func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 600
        
    }
    
    //MARK: - tableView代理方法
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        
        if sharedAccount == nil{
            
            return
        }
        
        if loadFinish == false{
            
            return
        }

        let result = scrollView.contentSize.height - scrollView.height + (self.tabBarController?.tabBar.height)! - (tableView.tableFooterView?.height)!
        
//        print(result)
//        
//        print("y = ",scrollView.contentOffset.y)
        
        if result < scrollView.contentOffset.y{
            
            loadMoreData = true
            loadData()
            tableView.tableFooterView?.hidden = false
            
        }
        
    }
    
    override func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        
        self.getUnReaderStatus()
    }
    

  
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        
        //NSCache 用法和字典完全一样,线程是安全的
        //当系统内存不足时会自动释放
        //如果缓存中无法取到需要数据就应该立马重新缓存
        
        
        //        println("准确高度\(indexPath.row)")
        let status = statuses![indexPath.row]
        
        if rowHeightCache.objectForKey(status.id) != nil {
            //            println("返回缓存行高")
            return rowHeightCache.objectForKey(status.id) as! CGFloat
        }
        //得到StatusCell的对象
        
        let cell = tableView.dequeueReusableCellWithIdentifier(StatusCell.cellIdtifier(status)) as! StatusCell
        let rowHeight = cell.rowHeight(status)
        rowHeightCache.setObject(rowHeight, forKey: status.id)
        //        println("返回计算行高")
        return rowHeight
        
        
    }
    

    lazy var newStatusCountLabel:UILabel = {
        
        let label = UILabel()
        label.size = CGSizeMake(self.view.width, 35)
        
        label.y = CGRectGetMaxY((self.navigationController?.navigationBar.frame)!) - label.height
        label.backgroundColor = UIColor.orangeColor()
        
        label.font = UIFont.systemFontOfSize(16)
        label.textAlignment = NSTextAlignment.Center
        label.textColor = UIColor.whiteColor()
        
        return label

    }()

}
