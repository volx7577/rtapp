//
//  photoDetailVC.swift
//  RTApp
//
//  Created by Ben Barclay on 3/6/15.
//  Copyright (c) 2015 Ben Barclay. All rights reserved.
//

import UIKit

class photoDetailVC: UIViewController, UITextFieldDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var addCommentField: UITextField!
    @IBOutlet weak var addCommentButton: UIButton!
    @IBOutlet weak var commentsScroll: UIScrollView!

    var dataPassedURL:String!
    var photoObject:PFObject!

    override func viewDidLoad() {
        super.viewDidLoad()

        let width = view.frame.size.width
        let height = view.frame.size.height

        commentLabel.frame = CGRectMake(16, 0, width-32, 400)
        commentsScroll.scrollEnabled = true
        commentsScroll.contentSize = CGSizeMake(width-32, 300)

        let predicate = NSPredicate(format: "name = %@", dataPassedURL)
        var query = PFQuery(className: "Photo", predicate: predicate)
        var objects = query.findObjects()

        photoObject = objects[0] as! PFObject
        var image = photoObject["photo"] as! PFFile
        image.getDataInBackgroundWithBlock {
            (imageData : NSData!, error : NSError!) -> Void in

            if error == nil{
                let image = UIImage(data: imageData)
                self.imageView.image = image
            }
        }

        if photoObject["comments"] != nil {
            var commentsArray = photoObject["comments"] as! NSArray as! [String]
            var s = ""
            for comment in commentsArray {
                s += ("- " + comment + "\n" )
            }

            commentLabel.text = s
            commentLabel.lineBreakMode = NSLineBreakMode.ByWordWrapping
            commentLabel.textAlignment = NSTextAlignment.Left
            commentLabel.numberOfLines = 0
            commentLabel.font = UIFont(name: commentLabel.font.fontName, size: 12)
            commentLabel.sizeToFit()
        }
    }

    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        self.view.endEditing(true)
    }

    func textFieldDidBeginEditing(textField: UITextField) {
        let width = view.frame.size.width
        let height = view.frame.size.height

        if (UIScreen.mainScreen().bounds.height == 568){//iphone 5 or 5s
                if(textField == self.addCommentField){
                UIView.animateWithDuration(0.3, delay: 0, options: .CurveLinear, animations: {
                    self.view.center = CGPointMake(width/2, (height/2)-160)
                    }, completion: {
                        (finished:Bool) in
                        //
                    })
                }
        }
    }

    func textFieldDidEndEditing(textField: UITextField) {
        let width = view.frame.size.width
        let height = view.frame.size.height

        if (UIScreen.mainScreen().bounds.height == 568){//iphone 5 or 5s
            if(textField == self.addCommentField){
                UIView.animateWithDuration(0.3, delay: 0, options: .CurveLinear, animations: {
                    self.view.center = CGPointMake(width/2, (height/2))
                    }, completion: {
                        (finished:Bool) in
                        //
                })
            }
        }
    }

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        addCommentField.resignFirstResponder()
        return true
    }

    func refreshResults(){
        let width = view.frame.size.width
        commentLabel.frame = CGRectMake(16, 0, width-32, 400)
        commentsScroll.scrollEnabled = true
        commentsScroll.contentSize = CGSizeMake(width-32, 300)

        if photoObject["comments"] != nil {
            var commentsArray = photoObject["comments"] as! NSArray as! [String]
            var s = ""
            for comment in commentsArray {
                s += ("- " + comment + "\n" )
            }

            commentLabel.text = s
            commentLabel.lineBreakMode = NSLineBreakMode.ByWordWrapping
            commentLabel.textAlignment = NSTextAlignment.Left
            commentLabel.numberOfLines = 0
            commentLabel.sizeToFit()
        }
        addCommentField.text = ""
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func addCommentButton_click(sender: AnyObject) {
        var commentText = addCommentField.text
        var commentArray: [String] = []
        if commentText != "" {

            if photoObject["comments"] != nil {
                commentArray = photoObject["comments"] as! [String]
            }
            commentArray.append(commentText)
            println(commentArray)
            photoObject["comments"] = commentArray
            photoObject.saveInBackgroundWithBlock{
                (success: Bool, error: NSError!) -> Void in
                if error == nil{
                    println("saved comment")
                    self.refreshResults()
                } else{
                    println("idk dawg, some other shit went down.")
                }
            }
        }
    }

}
