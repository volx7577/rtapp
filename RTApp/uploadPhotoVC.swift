//
//  uploadPhotoVC.swift
//  RTApp
//
//  Created by Ben Barclay on 3/6/15.
//  Copyright (c) 2015 Ben Barclay. All rights reserved.
//

import UIKit

class uploadPhotoVC: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    @IBOutlet weak var uploadImage: UIImageView!
    @IBOutlet weak var uploadButton: UIButton!
    @IBOutlet weak var findButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func uploadButton_click(sender: AnyObject) {

        if let imageData = UIImagePNGRepresentation(self.uploadImage.image){
            let imageFile = PFFile(name: "uploadedPhoto.png", data: imageData)

            var newImage = PFObject(className: "Photo")
            newImage["photo"] = imageFile

            newImage.saveInBackgroundWithBlock{
                (success: Bool, error: NSError!) -> Void in
                if (success) {
                    newImage["name"] = newImage["photo"].url
                    newImage.saveInBackgroundWithBlock{
                        (success: Bool, error: NSError!) -> Void in
                        if (success) {
                            newImage["name"] = newImage["photo"].url
                            
                            self.dismissViewControllerAnimated(true, completion: {})
                        } else {
                            println("failed to upload image name as url")
                        }
                    }
                } else {
                    println("failed to upload image")
                }
            }
        }
    }

    @IBAction func findButton_click(sender: AnyObject) {
        var image = UIImagePickerController()
        image.delegate = self
        image.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        image.allowsEditing = true
        self.presentViewController(image, animated: true, completion: nil)
    }

    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        uploadImage.image = image
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func cancelButton_click(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

}
