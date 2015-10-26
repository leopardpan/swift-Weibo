//
//  NewfeatureController.swift
//  SinaWeibo
//
//  Created by jiang on 15/10/8.
//  Copyright © 2015年 jiang. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class NewfeatureController: UICollectionViewController {

    @IBOutlet weak var layout: UICollectionViewFlowLayout!
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewDidAppear(animated: Bool) {
        
        layout.itemSize = UIScreen.mainScreen().bounds.size
       
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
       
        return 1
    }

    let imgageCount = 4
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return imgageCount
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! NewFeatureCell
    
        cell.imageIndex = indexPath.item
    
        return cell
    }
    
    //获取当前cell
    override func collectionView(collectionView: UICollectionView, didEndDisplayingCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        
        let path = collectionView.indexPathsForVisibleItems().last
        
        let newCell = collectionView.cellForItemAtIndexPath(path!) as! NewFeatureCell
        
        if path?.item == imgageCount - 1{
            
            newCell.showStartButton()
            
        }
        
    }
    
 
    

}

class NewFeatureCell: UICollectionViewCell {
    
    @IBOutlet weak var bgImage: UIImageView!
    
    @IBOutlet weak var startButton: UIButton!
    
    var imageIndex = 0 {
        didSet{
            bgImage.image = UIImage(named: "new_feature_\(imageIndex + 1)")
            
            startButton.hidden = true
            
        }
    }
    
    //弹出开始按钮
    func showStartButton(){
        
        startButton.hidden = false
    
        UIView.animateWithDuration(0.8, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.1, options: [], animations: { () -> Void in
            
            self.startButton.transform = CGAffineTransformMakeScale(1, 1)
            
            }) { (_) -> Void in
                print("完成")
        }
        
    }
    
    @IBAction func startBtnClick() {
        
        //转跳到主控制器
        NSNotificationCenter.defaultCenter().postNotificationName(WBSwitchToRootVC, object: "Main")
        
    }
    
    
    
    
}
