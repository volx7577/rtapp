//
//  kegeratorVC.swift
//  RTApp
//
//  Created by Ben Barclay on 3/2/15.
//  Copyright (c) 2015 Ben Barclay. All rights reserved.
//

import UIKit

class kegeratorVC: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var beerTable: UITableView!
    @IBOutlet weak var voteordieLabel: UILabel!

    var beerNameArray = [String]()
    var beerDescArray = [String]()
    var beerVotesArray = [Int]()

    override func viewDidLoad() {
        super.viewDidLoad()

        var width = view.frame.size.width
        var height = view.frame.size.height

        beerTable.frame = CGRectMake(0, 320, width, height - 320)
        voteordieLabel.center = CGPointMake(width/2, 90)
    }

    override func viewDidAppear(animated: Bool) {

        var query = PFQuery(className: "Beer")
        var objects = query.findObjects()

        for object in objects{
            self.beerNameArray.append(object["Name"] as String)
            self.beerDescArray.append(object["Description"] as String)
            self.beerVotesArray.append(object["Votes"] as Int)
        }

        self.beerTable.reloadData()
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return beerNameArray.count
    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell:beerCell = tableView.dequeueReusableCellWithIdentifier("Cell") as beerCell

        cell.votesLabel.text = String(self.beerVotesArray[indexPath.row])
        cell.votesButton.setTitle(self.beerNameArray[indexPath.row], forState: UIControlState.Normal)

        return cell
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var cell = tableView.cellForRowAtIndexPath(indexPath) as beerCell
        var thisBeer = cell.votesButton.titleForState(.Normal)
        let bPredicate = NSPredicate(format: "Name = '"+thisBeer!+"'")

        println(thisBeer)
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
                self.refeshResults()
            }

        }
    }

    func refeshResults(){
        beerVotesArray.removeAll(keepCapacity: false)

        var query = PFQuery(className: "Beer")
        var objects = query.findObjects()

        for object in objects{
            self.beerVotesArray.append(object["Votes"] as Int)
        }

        self.beerTable.reloadData()

    }

    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {


    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
}
