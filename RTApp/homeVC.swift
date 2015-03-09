//
//  homeVC.swift
//  RTApp
//
//  Created by Ben Barclay on 3/2/15.
//  Copyright (c) 2015 Ben Barclay. All rights reserved.
//

import UIKit

class homeVC: UIViewController {

    @IBOutlet weak var usersButton: UIButton!
    @IBOutlet weak var deptLabel: UILabel!
    @IBOutlet weak var testDeptButton: UIButton!
    @IBOutlet weak var devDeptButton: UIButton!
    @IBOutlet weak var otherDeptButton: UIButton!
    @IBOutlet weak var statusButton: UIButton!
    @IBOutlet weak var beerButton: UIButton!
    @IBOutlet weak var photoFeedButton: UIButton!

    var deptSelected = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let width = view.frame.size.width
        let height = view.frame.size.height

        usersButton.center = CGPointMake(width/2, 90)
        deptLabel.center = CGPointMake(width/2, 130)
        testDeptButton.center = CGPointMake(width/3-60, 150)
        devDeptButton.center = CGPointMake((2*width)/3-60,150)
        otherDeptButton.center = CGPointMake(width-60, 150)
        statusButton.center = CGPointMake(width/2, height-140)
        beerButton.center = CGPointMake(width/2-90, height-100)
        photoFeedButton.center = CGPointMake(width-90,height-100)
    }

    override func viewDidAppear(animated: Bool) {
        deptSelected = ""
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "goToUserVC") {
            var datas = segue.destinationViewController as userVC
            datas.deptWasSelected = deptSelected
        }
    }

    @IBAction func photoFeedButton_click(sender: AnyObject) {
        self.performSegueWithIdentifier("goToPhotoFeedVC", sender: self)
    }

    override func viewWillAppear(animated: Bool) {
        self.navigationItem.hidesBackButton = true
    }

    @IBAction func allUsersButton_click(sender: AnyObject) {
         self.performSegueWithIdentifier("goToUserVC", sender: self)
    }

    @IBAction func logoutButton_click(sender: AnyObject) {
        PFUser.logOut()
        self.navigationController?.popToRootViewControllerAnimated(true)
    }

    @IBAction func otherButton_click(sender: AnyObject) {
        deptSelected = "other"
        self.performSegueWithIdentifier("goToUserVC", sender: self)
    }

    @IBAction func devButton_click(sender: AnyObject) {
        deptSelected = "dev"
        self.performSegueWithIdentifier("goToUserVC", sender: self)
    }

    @IBAction func testButton_click(sender: AnyObject) {
         deptSelected = "test"
        self.performSegueWithIdentifier("goToUserVC", sender: self)
    }

    @IBAction func statusButton_click(sender: AnyObject) {
        self.performSegueWithIdentifier("goToStatusVC", sender: self)
    }

    @IBAction func voteForBeerButton_click(sender: AnyObject) {
        self.performSegueWithIdentifier("goToKegeratorVC", sender: self)
    }

}
