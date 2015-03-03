//
//  kegeratorVC.swift
//  RTApp
//
//  Created by Ben Barclay on 3/2/15.
//  Copyright (c) 2015 Ben Barclay. All rights reserved.
//

import UIKit

class kegeratorVC: UIViewController {

    @IBOutlet weak var voteordieLabel: UILabel!
    @IBOutlet weak var beerOneButton: UIButton!
    @IBOutlet weak var beerThreeButton: UIButton!
    @IBOutlet weak var beerTwoButton: UIButton!
    @IBOutlet weak var beerOneDesc: UILabel!
    @IBOutlet weak var beerTwoDesc: UILabel!
    @IBOutlet weak var beerThreeDesc: UILabel!
    @IBOutlet weak var beerOneVotes: UILabel!
    @IBOutlet weak var beerTwoVotes: UILabel!
    @IBOutlet weak var beerThreeVotes: UILabel!

    var beerNameArray = [String]()
    var beerDescArray = [String]()
    var beerVotesArray = [Int]()

    override func viewDidLoad() {
        super.viewDidLoad()

        var width = view.frame.size.width

        voteordieLabel.center = CGPointMake(width/2,90)
        beerOneButton.center = CGPointMake(width/3-60, 180)
        beerOneDesc.center = CGPointMake(width/3+80, 180)
        beerTwoButton.center = CGPointMake(width/3-60,240)
        beerTwoDesc.center = CGPointMake(width/3+80,240)
        beerThreeButton.center = CGPointMake(width/3-60, 300)
        beerThreeDesc.center = CGPointMake(width/3+80, 300)

        beerOneDesc.lineBreakMode = NSLineBreakMode.ByWordWrapping
        beerOneDesc.textAlignment = NSTextAlignment.Left
        beerOneDesc.numberOfLines = 0
        beerTwoDesc.lineBreakMode = NSLineBreakMode.ByWordWrapping
        beerTwoDesc.textAlignment = NSTextAlignment.Left
        beerTwoDesc.numberOfLines = 0
        beerThreeDesc.lineBreakMode = NSLineBreakMode.ByWordWrapping
        beerThreeDesc.textAlignment = NSTextAlignment.Left
        beerThreeDesc.numberOfLines = 0

    }

    override func viewDidAppear(animated: Bool) {

        var query = PFQuery(className: "Beer")
        var objects = query.findObjects()

        for object in objects{
            self.beerNameArray.append(object["Name"] as String)
            self.beerDescArray.append(object["Description"] as String)
            self.beerVotesArray.append(object["Votes"] as Int)
        }

        beerOneButton.setTitle(beerNameArray[0], forState: UIControlState.Normal)
        beerTwoButton.setTitle(beerNameArray[1], forState: UIControlState.Normal)
        beerThreeButton.setTitle(beerNameArray[2], forState: UIControlState.Normal)

        beerOneDesc.text = beerDescArray[0]
        beerTwoDesc.text = beerDescArray[1]
        beerThreeDesc.text = beerDescArray[2]

        beerOneVotes.text = String(beerVotesArray[0])
        beerTwoVotes.text = String(beerVotesArray[1])
        beerThreeVotes.text = String(beerVotesArray[2])

    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func beerOneButton_click(sender: AnyObject) {
        var thisBeer = self.beerOneButton.titleLabel!.text
        let bPredicate = NSPredicate(format: "Name = '"+thisBeer!+"'")

        var bQuery = PFQuery(className: "Beer", predicate: bPredicate)
        bQuery.findObjectsInBackgroundWithBlock{
            (objects:[AnyObject]!, error:NSError!) -> Void in

            if error == nil {
                for object in objects {
                    object.incrementKey("Votes")
                    object.saveInBackgroundWithBlock{
                        (success:Bool!,error:NSError!) -> Void in

                        if success == true{

                          println("voted")
                        }
                    }
                }
            }
        }
    }

    @IBAction func beerTwoButton_click(sender: AnyObject) {
        var thisBeer = self.beerTwoButton.titleLabel!.text
        let bPredicate = NSPredicate(format: "Name = '"+thisBeer!+"'")

        var bQuery = PFQuery(className: "Beer", predicate: bPredicate)
        bQuery.findObjectsInBackgroundWithBlock{
            (objects:[AnyObject]!, error:NSError!) -> Void in

            if error == nil {
                for object in objects {
                    object.incrementKey("Votes")
                    object.saveInBackgroundWithBlock{
                        (success:Bool!,error:NSError!) -> Void in

                        if success == true{

                            println("voted")
                        }
                    }
                }
            }
        }
    }

    @IBAction func beerThreeButton_click(sender: AnyObject) {
        var thisBeer = self.beerThreeButton.titleLabel!.text
        let bPredicate = NSPredicate(format: "Name = '"+thisBeer!+"'")

        var bQuery = PFQuery(className: "Beer", predicate: bPredicate)
        bQuery.findObjectsInBackgroundWithBlock{
            (objects:[AnyObject]!, error:NSError!) -> Void in

            if error == nil {
                for object in objects {
                    object.incrementKey("Votes")
                    object.saveInBackgroundWithBlock{
                        (success:Bool!,error:NSError!) -> Void in

                        if success == true{

                            println("voted")
                        }
                    }
                }
            }
        }
    }
}
