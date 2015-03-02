//
//  userDetailVC.swift
//  RTApp
//
//  Created by Ben Barclay on 3/2/15.
//  Copyright (c) 2015 Ben Barclay. All rights reserved.
//

import UIKit

var bio:String = "empty"
var profileImagew:UIImage!

class userDetailVC: UIViewController {

    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var messageButton: UIButton!
    @IBOutlet weak var bioLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!

    var dataPassedName:String!
    var dataPassedBio:String!

    override func viewDidLoad() {
        super.viewDidLoad()

        var width = view.frame.size.width
        var height = view.frame.size.height

        usernameLabel.center = CGPointMake(width/2, 90)
        messageButton.frame = CGRectMake(64, height-60, width-128, 30)
        bioLabel.frame = CGRectMake(16, 180, width-32, 200)
        bioLabel.lineBreakMode = NSLineBreakMode.ByWordWrapping
        bioLabel.textAlignment = NSTextAlignment.Left
        bioLabel.numberOfLines = 0
        profileImage.center = CGPointMake(60, 100)
        profileImage.layer.cornerRadius = profileImage.frame.size.width/2
        profileImage.clipsToBounds = true

        usernameLabel.text = dataPassedName
        bioLabel.text = dataPassedBio
        profileImage.image = profileImagew
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func MessageButton_click(sender: AnyObject) {
        self.performSegueWithIdentifier("goToConversationVC", sender: self)
    }

}
