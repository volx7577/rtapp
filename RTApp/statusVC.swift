//
//  statusVC.swift
//  RTApp
//
//  Created by Ben Barclay on 3/4/15.
//  Copyright (c) 2015 Ben Barclay. All rights reserved.
//

import UIKit

class statusVC: UIViewController {

    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var statusField: UITextField!
    @IBOutlet weak var closeButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        let width = view.frame.size.width
        let height = view.frame.size.height

        var user = PFUser.currentUser()
        if user["status"] == nil {
            statusField.text = ""
        } else {
            statusField.text = user["status"] as String
        }

        //TODO:set elements positions

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func closeButton_click(sender: AnyObject) {

        if (statusField.text != "") {
            var user = PFUser.currentUser()
            user["status"] = statusField.text
            user.saveInBackgroundWithBlock{
                (success: Bool!, error: NSError!) -> Void in
                if error == nil{
                    println("saved current installation")
                }else{
                    println("idk dawg, some shit went down.")
                }
            }
        }

        self.dismissViewControllerAnimated(true, completion: {})
    }

}
