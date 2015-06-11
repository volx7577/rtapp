//
//  ViewController.swift
//  RTApp
//
//  Created by Ben Barclay on 2/27/15.
//  Copyright (c) 2015 Ben Barclay. All rights reserved.
//

import UIKit

class loginVC: UIViewController {

    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        let width = view.frame.size.width
        let height = view.frame.size.height

        welcomeLabel.center = CGPointMake(width/2, 130)
        subtitleLabel.center = CGPointMake(width/2, 160)
        usernameField.frame = CGRectMake(16, 220, width-32, 30)
        passwordField.frame = CGRectMake(16, 260, width-32, 30)
        loginButton.center = CGPointMake(width/2, 330)
        signupButton.center = CGPointMake(width/2, height-30)
    }

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        usernameField.resignFirstResponder()
        passwordField.resignFirstResponder()
        return true
    }

    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        self.view.endEditing(true)
    }


    func textFieldDidEndEditing(textField: UITextField) {

        let width = view.frame.size.width
        let height = view.frame.size.height

        if (UIScreen.mainScreen().bounds.height == 568){//iphone 5 or 5s
            if(textField == self.passwordField || textField == self.usernameField){
                UIView.animateWithDuration(0.3, delay: 0, options: .CurveLinear, animations: {
                    self.view.center = CGPointMake(width/2, (height/2))
                    }, completion: {
                        (finished:Bool) in
                        //
                })
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func loginButton_click(sender: AnyObject) {

        PFUser.logInWithUsernameInBackground(usernameField.text, password: passwordField.text) {
            (user:PFUser!, logInError:NSError!) -> Void in
            if logInError == nil{
                println("login")

                var installation:PFInstallation = PFInstallation.currentInstallation()
                installation["user"] = PFUser.currentUser()
                installation.saveInBackgroundWithBlock{
                    (success: Bool, error: NSError!) -> Void in
                    if error == nil{
                        println("saved current installation")
                    }else{
                        println("idk dawg, some shit went down.")
                    }
                }

                self.performSegueWithIdentifier("goToHomeVC", sender: self)
            }else{
                println("error login")
            }
        }
    }

    override func viewWillAppear(animated: Bool) {
        self.navigationItem.hidesBackButton = true
    }
    
}
