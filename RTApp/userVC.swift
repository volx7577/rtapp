//
//  userVC.swift
//  RTApp
//
//  Created by Ben Barclay on 2/27/15.
//  Copyright (c) 2015 Ben Barclay. All rights reserved.
//

import UIKit

var userName = ""
var phone = ""
var status = ""

class userVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var resultsTable: UITableView!

    var resultsUsernameArray = [String]()
    var resultsProfileNameArray = [String]()
    var resultsImageFiles = [PFFile]()
    var resultsBioArrays = [String]()
    var resultsPhoneArray = [String]()
    var resultsStatusArray = [String]()

    var deptWasSelected = ""

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
            resultsPhoneArray.removeAll(keepCapacity: false)
            resultsStatusArray.removeAll(keepCapacity: false)
            self.resultsTable.reloadData()
        }

        var predicate = NSPredicate(format: "username != '"+userName+"'")
        if (deptWasSelected != ""){
            predicate = NSPredicate(format: "username != %@ AND dept = %@", userName, deptWasSelected)
        }

        var query = PFQuery(className: "_User", predicate: predicate)
        var objects = query.findObjects()

        for object in objects{
            self.resultsUsernameArray.append(object.username)
            self.resultsProfileNameArray.append(object.email)
            self.resultsImageFiles.append(object["photo"] as PFFile)
            self.resultsBioArrays.append(object["bio"] as String)
            self.resultsPhoneArray.append(object["phone"] as String)
            if object["status"] == nil {
                self.resultsStatusArray.append("" as String)
            } else{
                self.resultsStatusArray.append(object["status"] as String)
            }

            self.resultsTable.reloadData()
        }
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var cell = tableView.cellForRowAtIndexPath(indexPath) as resultsCell

        otherName = cell.usernameLabel.text!
        otherProfileName = cell.profileNameLabel.text!
        bio = cell.bio
        profileImagew = cell.profileImage.image
        phone = cell.phone
        status = cell.status

        self.performSegueWithIdentifier("goToUserDetailVC", sender: self)
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if(segue.identifier == "goToUserDetailVC") {

            var datas = segue.destinationViewController as userDetailVC
            datas.dataPassedName = otherName
            datas.dataPassedBio = bio
            datas.dataPassedPhone = phone
            datas.dataPassedStatus = status
        }
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
        cell.phone = self.resultsPhoneArray[indexPath.row]
        cell.status = self.resultsStatusArray[indexPath.row]

        resultsImageFiles[indexPath.row].getDataInBackgroundWithBlock({
            (imageData: NSData!, error:NSError!) -> Void in

            if error == nil{
                let image = UIImage(data: imageData)
                cell.profileImage.image = image
            }
        })

        return cell
    }
    
    
}
