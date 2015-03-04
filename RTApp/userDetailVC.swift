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
    @IBOutlet weak var phoneNumberButton: UIButton!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var LbioLabel: UILabel!
    @IBOutlet weak var LstatusLabel: UILabel!

    var dataPassedName:String!
    var dataPassedBio:String!
    var dataPassedPhone:String!
    var dataPassedStatus:String!

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
        phoneNumberButton.frame = CGRectMake(64, height-100, width-128, 30)
        statusLabel.center = CGPointMake(width/2, height-130)
        LbioLabel.center = CGPointMake(16, 190)
        LstatusLabel.center = CGPointMake(26, height-140)

        usernameLabel.text = dataPassedName
        statusLabel.text = dataPassedStatus
        bioLabel.text = dataPassedBio
        profileImage.image = profileImagew
        phoneNumberButton.setTitle(dataPassedPhone, forState: UIControlState.Normal)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func MessageButton_click(sender: AnyObject) {
        self.performSegueWithIdentifier("goToConversationVC", sender: self)
    }

    
    @IBAction func phoneNumberButton_click(sender: AnyObject) {
        println("clicked")
        var optionalUrl = self.phoneNumberButton.titleLabel?.text
        var unwrappedUrl = optionalUrl!

        if let url = NSURL(string: "tel://\(unwrappedUrl)") {
            UIApplication.sharedApplication().openURL(url)
            println("called")
        }
        println("tel://\(unwrappedUrl)")
    }

}
