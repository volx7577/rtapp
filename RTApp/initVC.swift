//
//  initVC.swift
//  RTApp
//
//  Created by Ben Barclay on 3/9/15.
//  Copyright (c) 2015 Ben Barclay. All rights reserved.
//

import UIKit

class initVC: UIViewController {

    var dataPassedSegue:String!

    override func viewDidLoad() {
        super.viewDidLoad()

        if PFUser.currentUser() != nil {
            self.performSegueWithIdentifier("goToHomeVC", sender: self)
        } else {
            self.performSegueWithIdentifier("goToLoginVC", sender: self)
        }

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
