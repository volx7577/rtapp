//
//  resultsCell.swift
//  RTApp
//
//  Created by Ben Barclay on 2/27/15.
//  Copyright (c) 2015 Ben Barclay. All rights reserved.
//

import UIKit

class resultsCell: UITableViewCell {

    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var profileNameLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!

    var bio:String = ""
    var phone:String = ""
    var status:String = ""

    var originalCenter = CGPoint()
    var orderOnDragRelease = false
    var coffeeLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()

        let width = UIScreen.mainScreen().bounds.width
        contentView.frame = CGRectMake(0, 0, width, 120)

        profileImage.center = CGPointMake(60, 60)
        profileImage.layer.cornerRadius = profileImage.frame.size.width/2
        profileImage.clipsToBounds = true
        profileNameLabel.center =  CGPointMake(230, 55)

        var recognizer = UIPanGestureRecognizer(target: self, action: "handlePan:")
        recognizer.delegate = self
        addGestureRecognizer(recognizer)

        coffeeLabel = createCueLabel()
        coffeeLabel.text = "Invite for Coffee"
        coffeeLabel.textAlignment = .Left

        coffeeLabel.frame = CGRect(x: bounds.size.width + 30, y: 30, width: 140, height: bounds.size.height)
         addSubview(coffeeLabel)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

    func createCueLabel() -> UILabel {
        let label = UILabel(frame: CGRect.nullRect)
        label.textColor = UIColor.whiteColor()
        label.font = UIFont.boldSystemFontOfSize(16.0)
        return label
    }

    func handlePan(recognizer: UIPanGestureRecognizer) {
            if recognizer.state == .Began {
            originalCenter = center
        }
        if recognizer.state == .Changed {
            let translation = recognizer.translationInView(self)
            center = CGPointMake(originalCenter.x + translation.x, originalCenter.y)
            orderOnDragRelease = frame.origin.x < -frame.size.width / 2.0
            let cueAlpha = fabs(frame.origin.x) / (frame.size.width / 2.0)
            coffeeLabel.alpha = cueAlpha
            coffeeLabel.textColor = orderOnDragRelease ? UIColor.greenColor() : UIColor.whiteColor()
        }
        if recognizer.state == .Ended {
            let originalFrame = CGRect(x: 0, y: frame.origin.y,
                width: bounds.size.width, height: bounds.size.height)
            if !orderOnDragRelease {
                UIView.animateWithDuration(0.2, animations: {self.frame = originalFrame})
            } else {
                UIView.animateWithDuration(0.2, animations: {self.frame = originalFrame})
                notifyUserOfCoffeeOrder()
            }
        }
    }

    func notifyUserOfCoffeeOrder(){
        var uQuery:PFQuery = PFUser.query()
        uQuery.whereKey("username", equalTo: usernameLabel.text)

        var pushQuery:PFQuery = PFInstallation.query()
        pushQuery.whereKey("user", matchesQuery: uQuery)

        var push:PFPush = PFPush()
        push.setQuery(pushQuery)
        let data = ["type" : "coffee",
                    "alert" : "You've Been Invited To A Coffee Order"]
        push.setData(data)
        push.sendPush(nil)
        println("push sent")

    }

    override func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
        if let panGestureRecognizer = gestureRecognizer as? UIPanGestureRecognizer {
            let translation = panGestureRecognizer.translationInView(superview!)
            if fabs(translation.x) > fabs(translation.y) {
                return true
            }
            return false
        }
        return false
    }

}
