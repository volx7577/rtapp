//
//  profileVC.swift
//  RTApp
//
//  Created by Ben Barclay on 3/2/15.
//  Copyright (c) 2015 Ben Barclay. All rights reserved.
//

import UIKit

class profileVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var changeProfileImageButton: UIButton!
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var bioField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        let width = view.frame.size.width
        let height = view.frame.size.height

        profileImage.center = CGPointMake(width/2, 160)
        changeProfileImageButton.center = CGPointMake(width-60, 160)
        usernameField.frame = CGRectMake(16, 260, width-32, 30)
        passwordField.frame = CGRectMake(16, 340, width-32, 30)
        bioField.frame = CGRectMake(16, 380, width-32, 30)
        submitButton.center = CGPointMake(width/2, height-30)

        var user = PFUser.currentUser()
        usernameField.text = user.username
        bioField.text = user["bio"] as String

        user["photo"].getDataInBackgroundWithBlock({
            (imageData: NSData!, error:NSError!) -> Void in

            if error == nil{
                let image = UIImage(data: imageData)
                self.profileImage.image = image
            }
        })


    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func imagePickerController(picker: UIImagePickerController!, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        profileImage.image = image
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func changeImageButton_click(sender: AnyObject) {
        var image = UIImagePickerController()
        image.delegate = self
        image.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        image.allowsEditing = true
        self.presentViewController(image, animated: true, completion: nil)

    }

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        usernameField.resignFirstResponder()
        passwordField.resignFirstResponder()
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
            if(textField == self.bioField || textField == self.passwordField){
                UIView.animateWithDuration(0.3, delay: 0, options: .CurveLinear, animations: {
                    self.view.center = CGPointMake(width/2, (height/2)-130)
                    }, completion: {
                        (finished:Bool) in
                        //
                })
            }
        }
    }

    //TODO: change profile Image
    @IBAction func saveButton_click(sender: AnyObject) {
        var user = PFUser.currentUser()
        if (usernameField.text != "") {
            user.username = usernameField.text
        }
        if (passwordField.text != "") {
            user.password = passwordField.text
        }
        if (bioField.text != "") {
            user["bio"] = bioField.text
        }
        let imageData = UIImagePNGRepresentation(self.profileImage.image)
        let imageFile = PFFile(name: "profilePhoto.png", data: imageData)
        user["photo"] = imageFile


        user.saveInBackgroundWithBlock{
            (success: Bool!, error: NSError!) -> Void in
            if error == nil{
                println("saved current installation")
            }else{
                println("idk dawg, some shit went down.")
            }
        }

    }

    func textFieldDidEndEditing(textField: UITextField) {
        let width = view.frame.size.width
        let height = view.frame.size.height

        if (UIScreen.mainScreen().bounds.height == 568){//iphone 5 or 5s
            if(textField == self.bioField || textField == self.passwordField){
                UIView.animateWithDuration(0.3, delay: 0, options: .CurveLinear, animations: {
                    self.view.center = CGPointMake(width/2, (height/2))
                    }, completion: {
                        (finished:Bool) in
                        //
                })
            }
        }
    }
}
