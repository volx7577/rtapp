//
//  ViewController.swift
//  RTApp
//
//  Created by Ben Barclay on 2/27/15.
//  Copyright (c) 2015 Ben Barclay. All rights reserved.
//
import AddressBook
import UIKit

class signupVC: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate  {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var changeProfButton: UIButton!
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var bioField: UITextField!
    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var deptField: UITextField!
    @IBOutlet weak var phoneNumberField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        let width = view.frame.size.width
        let height = view.frame.size.height

        profileImage.center = CGPointMake(width/2, 160)
        profileImage.layer.cornerRadius = profileImage.frame.size.width/2
        profileImage.clipsToBounds = true
        changeProfButton.center = CGPointMake(width-60, 160)
        usernameField.frame = CGRectMake(16, 260, width-32, 30)
        emailField.frame = CGRectMake(16, 300, width-32, 30)
        passwordField.frame = CGRectMake(16, 340, width-32, 30)
        bioField.frame = CGRectMake(16, 380, width-32, 30)
        deptField.frame = CGRectMake(16, 420, width-32, 30)
        signupButton.center = CGPointMake(width/2, height-30)
        phoneNumberField.frame = CGRectMake(16, 460, width-32, 30)

        //TODO: find out how to extract your own number from here.
        getContactNames()
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
        deptField.resignFirstResponder()
        phoneNumberField.resignFirstResponder()
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
            println(textField.text)
            if(textField == self.bioField || textField == self.passwordField || textField == self.emailField || textField == self.deptField || textField == self.phoneNumberField){
                UIView.animateWithDuration(0.3, delay: 0, options: .CurveLinear, animations: {
                    self.view.center = CGPointMake(width/2, (height/2)-190)
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
            if(textField == self.bioField || textField == self.passwordField || textField == self.emailField || textField == self.deptField || textField == self.phoneNumberField){
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
        user["dept"] = deptField.text
        user["phone"] = phoneNumberField.text
        user["status"] = ""

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
                    } else{
                        println("idk dawg, some shit went down.")
                    }
                }
                self.performSegueWithIdentifier("goToHomeVC2", sender: self)
                println("signup")
            } else{
                println("can't signup")
            }
        }
    }


////////ADDRESS BOOK STUFFFFFFF

    var addressBook: ABAddressBookRef?

    func extractABAddressBookRef(abRef: Unmanaged<ABAddressBookRef>!) -> ABAddressBookRef? {
        if let ab = abRef {
            return Unmanaged<NSObject>.fromOpaque(ab.toOpaque()).takeUnretainedValue()
        }
        return nil
    }

    func test() {

        if (ABAddressBookGetAuthorizationStatus() == ABAuthorizationStatus.NotDetermined) {
            println("requesting access...")
            var errorRef: Unmanaged<CFError>? = nil
            addressBook = extractABAddressBookRef(ABAddressBookCreateWithOptions(nil, &errorRef))
            ABAddressBookRequestAccessWithCompletion(addressBook, { success, error in
                if success {
                    self.getContactNames()
                } else {
                    println("error")
                }
            })
        }
        else if (ABAddressBookGetAuthorizationStatus() == ABAuthorizationStatus.Denied || ABAddressBookGetAuthorizationStatus() == ABAuthorizationStatus.Restricted) {
            println("access denied")
        }
        else if (ABAddressBookGetAuthorizationStatus() == ABAuthorizationStatus.Authorized) {
            println("access granted")
            self.getContactNames()
        }
    }

    func getContactNames() {

        var errorRef: Unmanaged<CFError>?
        addressBook = extractABAddressBookRef(ABAddressBookCreateWithOptions(nil, &errorRef))
        var contactList: NSArray = ABAddressBookCopyArrayOfAllPeople(addressBook).takeRetainedValue()
        println("records in the array \(contactList.count)")

        for record:ABRecordRef in contactList {
            var contactPerson: ABRecordRef = record
            var contactName: String = ABRecordCopyCompositeName(contactPerson).takeRetainedValue() as NSString
            println ("contactName \(contactName)")
        }
    }

}
