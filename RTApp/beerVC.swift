//
//  beerVC.swift
//  RTApp
//
//  Created by Ben Barclay on 3/3/15.
//  Copyright (c) 2015 Ben Barclay. All rights reserved.
//

import UIKit

class beerVC: UIViewController {

    @IBOutlet weak var beerImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var closeButton: UIButton!

    var beerNameArray = [String]()
    var beerDescArray = [String]()
    var resultsImageFiles = [PFFile]()

    var index = -1

    override func viewDidLoad() {
        super.viewDidLoad()

        let width = view.frame.size.width
        let height = view.frame.size.height

        beerImage.frame = CGRectMake(5, 30, width/2, 130)
        nameLabel.center = CGPointMake(width/2 + 60, 90)
        descriptionLabel.center = CGPointMake(width/2, 180)
        descriptionLabel.lineBreakMode = NSLineBreakMode.ByWordWrapping
        descriptionLabel.textAlignment = NSTextAlignment.Left
        descriptionLabel.numberOfLines = 0

        beerNameArray.removeAll(keepCapacity: false)
        beerDescArray.removeAll(keepCapacity: false)
        resultsImageFiles.removeAll(keepCapacity: false)

        var query = PFQuery(className: "Beer")
        var objects = query.findObjects()

        for object in objects{
            self.beerNameArray.append(object["Name"] as! String)
            self.beerDescArray.append(object["Description"] as! String)
            self.resultsImageFiles.append(object.objectForKey("Photo") as! PFFile)
        }

        nameLabel.text = beerNameArray[index]
        descriptionLabel.text = beerDescArray[index]
        resultsImageFiles[index].getDataInBackgroundWithBlock {
            (imageData : NSData!, error : NSError!) -> Void in

            if error == nil{
                let image = UIImage(data: imageData)
                self.beerImage.image = image
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func closeButton_click(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: {})
    }

}
