//
//  ComposeStatusController.swift
//  SinaWeibo
//
//  Created by jiang on 15/10/14.
//  Copyright © 2015年 jiang. All rights reserved.
//

import UIKit

class ComposeStatusController: UIViewController,UITextViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
//    var placeHolder: String?
    
    var toolButtons:[UIButton] = []
    
    @IBOutlet weak var toolBarButtom: NSLayoutConstraint!

    @IBOutlet weak var toolBar: UIView!
    

    @IBOutlet weak var textView: UITextView!
    
    @IBOutlet weak var placeHolderLabel: UILabel!
    @IBOutlet weak var sendStatusBtn: UIBarButtonItem!
    
    @IBOutlet weak var photoView: UIImageView!
    
    @IBOutlet weak var pictureView: UIView!
    
    //相册
    var photosArray:[UIImage] = []{
        didSet{
            print(111)
            
                for picture in pictureView.subviews{
                    
                    if picture.isKindOfClass(UIImageView){
                        
                        for i in 0 ..< photosArray.count {
                            
                            if picture.tag == i {
                                
                                (picture as! UIImageView).image = photosArray[i]
                               
                                
                            }
                            if closePhototButton.tag == picture.tag {
                            
                                 closePhototButton.hidden = false
                                
                            }
                            
                        
                    }
                    

                }
                
            }
         }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        placeHolderLabel.text = "分享一些新鲜事"
        
        self.setNav()
        
    
        
          NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardChangeFrame:", name: UIKeyboardWillChangeFrameNotification, object: nil)
        
    }
    
    func setNav(){
        
        let titleLabel = UILabel()
        titleLabel.numberOfLines = 2
        titleLabel.textAlignment = NSTextAlignment.Center
        
        let screenName = sharedAccount!.name!
        
        if (screenName.characters.count != 0 ){
            
            let title = ("发微博\n\(screenName)")
//            print(title)
            
            let range = (title as NSString).rangeOfString(screenName)
            
            let attstr = NSMutableAttributedString.init(string: title)
            
//            var attrs:
            
            attstr.addAttribute(NSFontAttributeName, value: [UIFont.systemFontOfSize(16)], range: NSMakeRange(0, 3))
            
             attstr.addAttribute(NSFontAttributeName, value: [UIFont.systemFontOfSize(14)], range:range)
            
            attstr.addAttribute(NSForegroundColorAttributeName, value: [UIColor.grayColor()], range: range)
            
            titleLabel.attributedText = attstr
            
//            titleLabel.sizeToFit()
            
//            self.navigationItem.titleView = titleLabel
            
        }else{
           
//            self.navigationItem.title = "发微博"
        }
        
         self.navigationItem.title = "发微博"
        
    }
    
    @IBOutlet weak var addPhotoButton: UIButton!
    
    @IBAction func addPhoto() {
        
        self.selectImageWithSourecType(UIImagePickerControllerSourceType.PhotoLibrary)
        
    }
    
    
    
    @IBOutlet weak var closePhototButton: UIButton!
    
 
    @IBAction func closePhoto(sender: AnyObject) {
        
        
    }

    @IBAction func camera() {
        
        let result = UIImagePickerController.isSourceTypeAvailable( UIImagePickerControllerSourceType.Camera)
        if result {
            
            self.selectImageWithSourecType(UIImagePickerControllerSourceType.Camera)
            
        }else{
            
            print("相机不可用")
        }
  
    }
    
    @IBAction func photos() {
        
        
        self.selectImageWithSourecType(UIImagePickerControllerSourceType.PhotoLibrary)
        
    }
    
    @IBOutlet weak var emotion: UIButton!
    
    @IBAction func emotionClick() {
        
        
    }
  
    private func selectImageWithSourecType(type:UIImagePickerControllerSourceType){
        let pickCtrl = UIImagePickerController()
        pickCtrl.sourceType = type
        pickCtrl.delegate = self
        
        self.presentViewController(pickCtrl, animated: YES, completion: nil)
        
    }

    //MARK: - imagePickerController代理方法
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        
//        self.photoView.image = image
        
        self.photosArray.append(image)
        
        self.dismissViewControllerAnimated(YES, completion: nil)
    }
    
    
     func keyboardChangeFrame(notification:NSNotification){
        
//        print(111)
        
//        print(notification)
        
       let rectValue = (notification.userInfo as! NSDictionary) [UIKeyboardFrameEndUserInfoKey]
        
        let rect = rectValue?.CGRectValue
        
        
        
        self.toolBarButtom.constant = (rect?.height)!
        
        UIView.animateWithDuration(0.25, animations: { () -> Void in
            
            self.view.layoutIfNeeded()
            
            
            }) { (finish) -> Void in
                
                
        }
 
    }

    
    @IBAction func closeButtonClick() {
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }

    @IBAction func sendStatusButtonClick() {
        
        
    }
    
    func textViewDidChange(textView: UITextView) {
        
       
    
            if textView.text.length != 0{
                placeHolderLabel.hidden = true
        }else{
            placeHolderLabel.hidden = false
        }
  
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
        scrollView.endEditing(YES)
        self.toolBarButtom.constant = 0
    }
    


}

