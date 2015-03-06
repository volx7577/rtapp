//
//  photoDetailVC.swift
//  RTApp
//
//  Created by Ben Barclay on 3/6/15.
//  Copyright (c) 2015 Ben Barclay. All rights reserved.
//

import UIKit

class photoDetailVC: UIViewController {

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

       // commentLabel.frame = CGRectMake(16, 240, width-32, 200)

        let predicate = NSPredicate(format: "name = %@", dataPassedURL)

        var query = PFQuery(className: "Photo", predicate: predicate)
        var objects = query.findObjects()

        photoObject = objects[0] as PFObject
        var image = photoObject["photo"] as PFFile
        image.getDataInBackgroundWithBlock {
            (imageData : NSData!, error : NSError!) -> Void in

            if error == nil{
                let image = UIImage(data: imageData)
                self.imageView.image = image
            }
        }

        var commentsArray = photoObject["comments"] as NSArray as [String]

        var s = ""
        for comment in commentsArray {
            s += (comment + "\n" )
        }

        println(s)
        commentLabel.text = s
        commentLabel.lineBreakMode = NSLineBreakMode.ByWordWrapping
        commentLabel.textAlignment = NSTextAlignment.Left


    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func addCommentButton_click(sender: AnyObject) {
        var commentText = addCommentField.text
        if commentText != "" {
            var commentArray: [String] = photoObject["comments"] as [String]
            commentArray.append(commentText)

            photoObject["comments"] = commentArray
            photoObject.saveInBackgroundWithBlock{
                (success: Bool!, error: NSError!) -> Void in
                if error == nil{
                    println("saved comment")
                }else{
                    println("idk dawg, some other shit went down.")
                }
            }
        }
    }

}
