//
//  ViewController.swift
//  RTApp
//
//  Created by Ben Barclay on 2/27/15.
//  Copyright (c) 2015 Ben Barclay. All rights reserved.
//

import UIKit

class signupVC: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate  {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var changeProfButton: UIButton!
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var bioField: UITextField!
    @IBOutlet weak var signupButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        let width = view.frame.size.width
        let height = view.frame.size.height

        profileImage.center = CGPointMake(width/2, 160)
        changeProfButton.center = CGPointMake(width-60, 160)
        usernameField.frame = CGRectMake(16, 260, width-32, 30)
        emailField.frame = CGRectMake(16, 300, width-32, 30)
        passwordField.frame = CGRectMake(16, 340, width-32, 30)
        bioField.frame = CGRectMake(16, 380, width-32, 30)
        signupButton.center = CGPointMake(width/2, height-30)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func addImageButton_click(sender: AnyObject) {
        var image = UIImagePickerController()
        image.delegate = self
        image.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        image.allowsEditing = true
        self.presentViewController(image, animated: true, completion: nil)
    }

    func imagePickerController(picker: UIImagePickerController!, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        profileImage.image = image
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        usernameField.resignFirstResponder()
        passwordField.resignFirstResponder()
        emailField.resignFirstResponder()
        bioField.resignFirstResponder()
        return true
    }

    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        self.view.endEditing(true)
    }

    //TODO: edit this func so each field pushes the proper amount on each guy
    func textFieldDidBeginEditing(textField: UITextField) {
        let width = view.frame.size.width
        let height = view.frame.size.height

        if (UIScreen.mainScreen().bounds.height == 568){//iphone 5 or 5s
            if(textField == self.bioField || textField == self.passwordField || textField == self.emailField){
                UIView.animateWithDuration(0.3, delay: 0, options: .CurveLinear, animations: {
                    self.view.center = CGPointMake(width/2, (height/2)-130)
                    }, completion: {
                        (finished:Bool) in
                        //
                })
            }
        }
    }

    func textFieldDidEndEditing(textField: UITextField) {
        let width = view.frame.size.width
        let height = view.frame.size.height

        if (UIScreen.mainScreen().bounds.height == 568){//iphone 5 or 5s
            if(textField == self.bioField || textField == self.passwordField || textField == self.emailField){
                UIView.animateWithDuration(0.3, delay: 0, options: .CurveLinear, animations: {
                    self.view.center = CGPointMake(width/2, (height/2))
                    }, completion: {
                        (finished:Bool) in
                        //
                })
            }
        }
    }

    @IBAction func signupButton_click(sender: AnyObject) {
        var user = PFUser()
        user.username = usernameField.text
        user.password = passwordField.text
        user.email = emailField.text
        user["bio"] = bioField.text
        let imageData = UIImagePNGRepresentation(self.profileImage.image)
        let imageFile = PFFile(name: "profilePhoto.png", data: imageData)
        user["photo"] = imageFile

        user.signUpInBackgroundWithBlock(){
            (succeeded:Bool!, signUpError:NSError!) -> Void in

            if signUpError == nil{

                var installation:PFInstallation = PFInstallation.currentInstallation()
                installation["user"] = PFUser.currentUser()
                installation.saveInBackgroundWithBlock{
                    (success: Bool!, error: NSError!) -> Void in
                    if error == nil{
                        println("saved current installation")
                    }else{
                        println("idk dawg, some shit went down.")
                    }
                }

                self.performSegueWithIdentifier("goToUserVC2", sender: self)
                println("signup")
            }else{
                println("can't signup")
            }
        }
    }
    
}