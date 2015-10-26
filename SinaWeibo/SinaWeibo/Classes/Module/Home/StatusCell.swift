//
//  StatusCell.swift
//  SinaWeibo
//
//  Created by jiang on 15/10/8.
//  Copyright © 2015年 jiang. All rights reserved.
//

import UIKit
import SDWebImage
//import SDPhotoBrowser


class StatusCell: UITableViewCell {
    /// 名称
    @IBOutlet weak var name: UILabel!
    /// 头像
    @IBOutlet weak var iconView: UIImageView!
    /// 时间
    @IBOutlet weak var time: UILabel!
    
    
    /// 来源
    @IBOutlet weak var source: UILabel!
    
    ///微博正文
    @IBOutlet weak var contentLabe: UILabel!
    
    @IBOutlet weak var layout: UICollectionViewFlowLayout!
    
    /// 大图片宽
    @IBOutlet weak var pictureViewWidth: NSLayoutConstraint!
    /// 大图高
    @IBOutlet weak var pictureViewHeight: NSLayoutConstraint!
    
    /// 大图
    @IBOutlet weak var pictureView: UICollectionView!
    
    
    /// 工具条
    @IBOutlet weak var toolView: UIView!
    
    
    /// 转发微博正文
    
    @IBOutlet weak var forwordLabe: UILabel!
    
    
    /// vip
    @IBOutlet weak var vipImage: UIImageView!
    
    
    @IBOutlet weak var Vimage: UIImageView!
    
    @IBOutlet weak var forwordViewHeight: NSLayoutConstraint!
    var status:Status?{
        didSet{
            
            name.text = status?.user?.name  //昵称
            
            if status?.user?.mbtype > 2{
                
                vipImage.hidden = false
                
                vipImage.image = UIImage(named:"common_icon_membership_level\((status?.user?.mbrank)!)")
                
                name.textColor = UIColor.orangeColor()
            }else{
                 vipImage.hidden = true
                 name.textColor = UIColor.blackColor()
            }
            
//            print(status?.user?.verified_type)
            if status?.user?.verified_type > -1 {
                
                Vimage.hidden = false
                
                if status?.user?.verified_type == 200{
                    Vimage.image = UIImage(named: "avatar_enterprise_vip")
                }else{
                    Vimage.image = UIImage(named: "avatar_vip")
                }
                
            }else{
                Vimage.hidden = true
            }
            
//            print("common_icon_membership_level\(status?.user?.mbrank)")

            //来源
            source.text = status?.source?.jh_cutStringWitStarStringAndEndString("\">", endString: "</")
             

            //时间差
//            var date = ""
//            date = date.distanceTimeWithBeforeTime((status?.created_at)!)
            
            time.text = status?.created_at!.distanceTimeWithBeforeTime()
            
            
     
            //设置头像
            iconView.sd_setImageWithURL(status?.user?.iconURL)
            
            //设置内容
            contentLabe.text = status?.text
            
            let pSize = calcPictureViewSize(status!)
            pictureViewWidth.constant = pSize.viewSize.width
            pictureViewHeight.constant = pSize.viewSize.height
            
           
            
            
            // 设置 layout 的大小
            layout.itemSize = pSize.itemSize
            
            forwordLabe?.text = (status?.retweeted_status?.user?.name ?? "") + ":" + (status?.retweeted_status?.text ?? "")
            
            //设置tool
            seupTool(status!)
        

            // 让 collectionView 刷新数据
            pictureView.reloadData()

            
        }
    }
    
    //根据数据源计算行高
    func rowHeight(stauts:Status) ->CGFloat{
        //设置数据源
        self.status = stauts;
        
        //强制更新视图
        layoutIfNeeded()
        
         return CGRectGetMaxY(toolView.frame)
        
    }
    
    class func cellIdtifier(status: Status) -> String{
        if status.retweeted_status != nil {
            return "RetweetedCell"
        } else {
            return "HomeCell"
        }
    }
    
    
    /**
    计算图像大小
    
    - parameter status: 数据源
    
    - returns: 单个图片大小,整个view大小
    */
    private func calcPictureViewSize(status:Status) -> (viewSize:CGSize ,itemSize:CGSize){
        
        //图片的间距
        let Margin : CGFloat = 10
        
//        let ScreenW = UIScreen.mainScreen().bounds.size.width
        //单张图片默认大小
//        let w =  (ScreenW - 4 * Margin) / 3
        let w : CGFloat = 90
        let itemSize  = CGSizeMake(w, w)
        
        //图片数量
        let imageCount = status.pictureURLs?.count ?? 0
        
        //1,没有图像
        if imageCount == 0 {
            
            return(CGSizeZero,itemSize)
        }
        
        //2.一张图片,显示原图大小
        
        if imageCount == 1 {
            
            //从缓存里取数据
            let key = status.pictureURLs!.first?.absoluteString
            
            let image = SDWebImageManager.sharedManager().imageCache.imageFromDiskCacheForKey(key)
            
            return(image.size,itemSize)
            
        }
        
        //3, 4张图片
        
        if imageCount == 4{
            
            return (CGSizeMake(w * 2 + Margin, w * 2 + Margin),itemSize)
        }
        
        //4, 多张图片
        
//        print("多张图片 \(imageCount)")
        
        //计算行
        let row = CGFloat((imageCount - 1) / 3 + 1)
        
        return(CGSizeMake(w * 3 + 2 * Margin, row * w + (row - 1) * Margin),itemSize)
        
    }
    
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.selectionStyle = UITableViewCellSelectionStyle.None
        
        contentLabe.preferredMaxLayoutWidth = UIScreen.mainScreen().bounds.width - 20
        forwordLabe?.preferredMaxLayoutWidth = UIScreen.mainScreen().bounds.width - 20
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //MARK: - TOOl 工具栏
    @IBOutlet weak var retweetBtn: UIButton!
    
    @IBOutlet weak var comment: UIButton!
    
    @IBOutlet weak var unlike: UIButton!
    
    
    func seupTool(status:Status){
        
        setToolButtonTitlt(retweetBtn, count: status.reposts_count)
        setToolButtonTitlt(comment, count: status.comments_count)
        setToolButtonTitlt(unlike, count: status.attitudes_count)
    
    }

    func setToolButtonTitlt(button: UIButton, count:Int){
    
        if count > 0{
            
            if count < 10000{
                
                button.setTitle("\(count)", forState: UIControlState.Normal)
                
            }else{
                
                let result = Double(count) / 10000.0
                
              var titleStr = "\(result/10.0) + .1万"
                
                if titleStr.hasSuffix(".0万"){
                    
                    titleStr = titleStr.stringByReplacingOccurrencesOfString(".0", withString: " ")
                }
                
                button.setTitle(titleStr, forState: UIControlState.Normal)
           
            }
 
        }

    }
}


extension StatusCell: UICollectionViewDataSource,UICollectionViewDelegate {
    
    // 数据行数，配图数量
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return status?.pictureURLs?.count ?? 0
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("PictureCell", forIndexPath: indexPath) as! PictureCell
        
        // 设置 cell
        cell.url = status!.pictureURLs![indexPath.item]
        return cell
    }
    
    //代理方法
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        
        let browser = SDPhotoBrowser()
        browser.sourceImagesContainerView = collectionView       // 原图的父控件
        browser.imageCount = status?.pictureURLs?.count ?? 0 // 图片总数
//        browser.currentImageIndex = indexPath.item
//        browser.delegate = collectionView
        browser.show()
        
        let imageView = SDBrowserImageView()
        
        let urlArray = status!.pictureURLs
        
        var arry : [NSURL] = []
        
        for url in urlArray! {
            
           var urlstr = url.absoluteString
           urlstr = urlstr.stringByReplacingOccurrencesOfString("thumbnail", withString: "bmiddle")
            
            let url1 = NSURL(string: urlstr)
            
            arry.append(url1!)
  
        }

        browser.setupImageOfImageViewForIndex(indexPath.item, imageView: imageView, andUrl: arry)
        
    }
    
    
}




class PictureCell :UICollectionViewCell {
   //照片
    @IBOutlet weak var photoView: UIImageView!
    
    var url: NSURL?{
        didSet{
            photoView.sd_setImageWithURL(url)
        }
    }
    
}
