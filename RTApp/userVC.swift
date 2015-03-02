//
//  userVC.swift
//  RTApp
//
//  Created by Ben Barclay on 2/27/15.
//  Copyright (c) 2015 Ben Barclay. All rights reserved.
//

import UIKit

var userName = ""

class userVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var resultsTable: UITableView!

    var resultsUsernameArray = [String]()
    var resultsProfileNameArray = [String]()
    var resultsImageFiles = [PFFile]()
    var resultsBioArrays = [String]()


    override func viewDidLoad() {
        super.viewDidLoad()

        let width = view.frame.size.width
        let height = view.frame.size.height

        resultsTable.frame = CGRectMake(0, 0, width, height-64)

        userName = PFUser.currentUser().username

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewDidAppear(animated: Bool) {

        if (resultsUsernameArray.count != 0){
            resultsUsernameArray.removeAll(keepCapacity: false)
            resultsProfileNameArray.removeAll(keepCapacity: false)
            resultsImageFiles.removeAll(keepCapacity: false)
            resultsBioArrays.removeAll(keepCapacity: false)
            self.resultsTable.reloadData()
        }


        let predicate = NSPredicate(format: "username != '"+userName+"'")
        var query = PFQuery(className: "_User", predicate: predicate)
        var objects = query.findObjects()

        for object in objects{
            self.resultsUsernameArray.append(object.username)
            self.resultsProfileNameArray.append(object.email)
            self.resultsImageFiles.append(object["photo"] as PFFile)
            self.resultsBioArrays.append(object["bio"] as String)

            self.resultsTable.reloadData()
        }
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var cell = tableView.cellForRowAtIndexPath(indexPath) as resultsCell

        otherName = cell.usernameLabel.text!
        otherProfileName = cell.profileNameLabel.text!
        bio = cell.bio
        profileImagew = cell.profileImage.image

        self.performSegueWithIdentifier("goToUserDetailVC", sender: self)
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if(segue.identifier == "goToUserDetailVC") {

            var datas = segue.destinationViewController as userDetailVC
            datas.dataPassedName = otherName
            datas.dataPassedBio = bio

        }
    }

    override func viewWillAppear(animated: Bool) {
        self.navigationItem.hidesBackButton = true
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return resultsUsernameArray.count
    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 120
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        var cell:resultsCell = tableView.dequeueReusableCellWithIdentifier("Cell") as resultsCell

        cell.usernameLabel.text = self.resultsUsernameArray[indexPath.row]
        cell.profileNameLabel.text = self.resultsProfileNameArray[indexPath.row]
        cell.bio = self.resultsBioArrays[indexPath.row]

        resultsImageFiles[indexPath.row].getDataInBackgroundWithBlock({
            (imageData: NSData!, error:NSError!) -> Void in

            if error == nil{
                let image = UIImage(data: imageData)
                cell.profileImage.image = image
            }
        })

        return cell
    }
    
    @IBAction func logoutButton_click(sender: AnyObject) {
        PFUser.logOut()
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
}
