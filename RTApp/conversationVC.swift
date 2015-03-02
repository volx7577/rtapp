//
//  conversationVC.swift
//  RTApp
//
//  Created by Ben Barclay on 2/27/15.
//  Copyright (c) 2015 Ben Barclay. All rights reserved.
//

import UIKit

var otherName = ""
var otherProfileName = ""

class conversationVC: UIViewController, UIScrollViewDelegate, UITextViewDelegate {

    @IBOutlet weak var resultsScrollView: UIScrollView!
    @IBOutlet weak var frameMessageView: UIView!
    @IBOutlet weak var messageTextView: UITextView!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var lineLabel: UILabel!

    var scrollViewOriginalY:CGFloat = 0
    var frameMessageOriginalY:CGFloat = 0

    let mLabel = UILabel(frame:CGRectMake(5, 8, 200, 20))

    var messageX:CGFloat = 37.0
    var messageY:CGFloat = 26.0
    var frameX:CGFloat = 32.0
    var frameY:CGFloat = 21.0
    var imgX:CGFloat = 3
    var imgY:CGFloat = 3

    var messageArray = [String]()
    var senderArray = [String]()

    var myImg:UIImage? = UIImage()
    var otherImg:UIImage? = UIImage()

    var resultsImageFiles = [PFFile]()
    var resultsImageFiles2 = [PFFile]()

    override func viewDidLoad() {
        super.viewDidLoad()

        let width = view.frame.size.width
        let height = view.frame.size.height

        resultsScrollView.frame = CGRectMake(0, 64, width, height-114)
        resultsScrollView.layer.zPosition = 20
        frameMessageView.frame = CGRectMake(0, resultsScrollView.frame.maxY, width, 50)
        lineLabel.frame = CGRectMake(0, 1, width, 1)
        messageTextView.frame = CGRectMake(2, 1, self.frameMessageView.frame.size.width-52, 48)
        sendButton.center = CGPointMake(frameMessageView.frame.size.width-30, 24)

        scrollViewOriginalY = self.resultsScrollView.frame.origin.y
        frameMessageOriginalY = self.frameMessageView.frame.origin.y

        self.title = otherProfileName

        mLabel.text = "Type here..."
        mLabel.backgroundColor = UIColor.clearColor()
        mLabel.textColor = UIColor.lightGrayColor()
        messageTextView.addSubview(mLabel)


        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWasShown:", name: UIKeyboardDidShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)

        let tapScrollViewGesture = UITapGestureRecognizer(target: self, action: "didTapScrollView")
        tapScrollViewGesture.numberOfTapsRequired = 1
        resultsScrollView.addGestureRecognizer(tapScrollViewGesture)

        NSNotificationCenter.defaultCenter().addObserver(self, selector: "getMessageFunc", name: "getMessage", object: nil)

    }

    func getMessageFunc(){
        refreshResults()
    }

    func didTapScrollView(){
        self.view.endEditing(true)
    }

    func textViewDidChange(textView: UITextView) {
        if !messageTextView.hasText(){
            self.mLabel.hidden = false
        }else{
            self.mLabel.hidden = true
        }
    }

    func textViewDidEndEditing(textView: UITextView) {
        if !messageTextView.hasText() {
            self.mLabel.hidden = false
        }
    }

    func keyboardWasShown(notification: NSNotification){

        let dict:NSDictionary = notification.userInfo!
        let s:NSValue = dict.valueForKey(UIKeyboardFrameEndUserInfoKey) as NSValue
        let rect:CGRect = s.CGRectValue()

        UIView.animateWithDuration(0.3, delay: 0, options: .CurveLinear, animations: {
            self.resultsScrollView.frame.origin.y = self.scrollViewOriginalY - rect.height
            self.frameMessageView.frame.origin.y = self.frameMessageOriginalY - rect.height

            var bottomOffset:CGPoint = CGPointMake(0, self.resultsScrollView.contentSize.height - self.resultsScrollView.bounds.size.height)
            self.resultsScrollView.setContentOffset(bottomOffset, animated: false)

            }, completion: {
                (finished:Bool) in
        })
    }

    func keyboardWillHide(notification: NSNotification){
        let dict:NSDictionary = notification.userInfo!
        let s:NSValue = dict.valueForKey(UIKeyboardFrameEndUserInfoKey) as NSValue
        let rect:CGRect = s.CGRectValue()

        UIView.animateWithDuration(0.3, delay: 0, options: .CurveLinear, animations: {
            self.resultsScrollView.frame.origin.y = self.scrollViewOriginalY
            self.frameMessageView.frame.origin.y = self.frameMessageOriginalY

            var bottomOffset:CGPoint = CGPointMake(0, self.resultsScrollView.contentSize.height - self.resultsScrollView.bounds.size.height)
            self.resultsScrollView.setContentOffset(bottomOffset, animated: false)

            }, completion: {
                (finished:Bool) in
        })
    }

    override func viewDidAppear(animated: Bool) {
        var query = PFQuery(className: "_User")
        query.whereKey("username", equalTo: userName)
        var objects = query.findObjects()

        self.resultsImageFiles.removeAll(keepCapacity: false)

        for object in objects{
            self.resultsImageFiles.append(object["photo"] as PFFile)
            self.resultsImageFiles[0].getDataInBackgroundWithBlock{
                (imageData:NSData!, error:NSError!) -> Void in

                if error == nil{
                    self.myImg = UIImage(data: imageData)

                    var query2 = PFQuery(className: "_User")
                    query2.whereKey("username", equalTo: otherName)
                    var objects2 = query2.findObjects()

                    self.resultsImageFiles2.removeAll(keepCapacity: false)

                    for object in objects2{

                        self.resultsImageFiles2.append(object["photo"] as PFFile)

                        self.resultsImageFiles2[0].getDataInBackgroundWithBlock{
                            (imageData:NSData!, error:NSError!) -> Void in

                            if error == nil{
                                self.otherImg = UIImage(data: imageData)

                                self.refreshResults()
                            }
                        }
                    }

                }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func refreshResults(){

        let width = view.frame.size.width
        let height = view.frame.size.height

        messageX = 37.0
        messageY = 26.0
        frameX = 32.0
        frameY = 21.0
        imgX = 3
        imgY = 3

        messageArray.removeAll(keepCapacity: false)
        senderArray.removeAll(keepCapacity: false)

        let innerP1 = NSPredicate(format: "sender = %@ AND other = %@", userName, otherName)
        var innerQ1:PFQuery = PFQuery(className: "Messages", predicate: innerP1)

        let innerP2 = NSPredicate(format: "sender = %@ AND other = %@", otherName, userName)
        var innerQ2:PFQuery = PFQuery(className: "Messages", predicate: innerP2)

        var query = PFQuery.orQueryWithSubqueries([innerQ1,innerQ2])
        query.addAscendingOrder("createdAt")
        query.findObjectsInBackgroundWithBlock{
            (objects:[AnyObject]!, error:NSError!) -> Void in

            if error == nil{
                for object in objects{
                    self.senderArray.append(object.objectForKey("sender") as String)
                    self.messageArray.append(object.objectForKey("message") as String)
                }

                for subView in self.resultsScrollView.subviews{
                    subView.removeFromSuperview()
                }

                for var i = 0; i <= self.messageArray.count-1; i++ {

                    if self.senderArray[i] == userName {

                        var messageLabel:UILabel = UILabel()
                        messageLabel.frame = CGRectMake(0, 0, self.resultsScrollView.frame.size.width-94, CGFloat.max)
                        messageLabel.backgroundColor = UIColor.blueColor()
                        messageLabel.lineBreakMode = NSLineBreakMode.ByWordWrapping
                        messageLabel.textAlignment = NSTextAlignment.Left
                        messageLabel.numberOfLines = 0
                        messageLabel.font = UIFont(name: "Helvetica Neuse", size: 17)
                        messageLabel.textColor = UIColor.whiteColor()
                        messageLabel.text = self.messageArray[i]
                        messageLabel.sizeToFit()
                        messageLabel.layer.zPosition = 20
                        messageLabel.frame.origin.x = (self.resultsScrollView.frame.size.width - self.messageX) - messageLabel.frame.size.width
                        messageLabel.frame.origin.y = self.messageY
                        self.resultsScrollView.addSubview(messageLabel)
                        self.messageY += messageLabel.frame.size.height + 30

                        var frameLabel:UILabel = UILabel()
                        frameLabel.frame.size = CGSizeMake(messageLabel.frame.size.width+10, messageLabel.frame.size.height+10)
                        frameLabel.frame.origin.x = (self.resultsScrollView.frame.size.width - self.frameX) - frameLabel.frame.size.width
                        frameLabel.frame.origin.y = self.frameY
                        frameLabel.backgroundColor = UIColor.blueColor()
                        frameLabel.layer.masksToBounds = true
                        frameLabel.layer.cornerRadius = 10
                        self.resultsScrollView.addSubview(frameLabel)
                        self.frameY += frameLabel.frame.size.height + 20

                        var img:UIImageView = UIImageView()
                        img.image = self.myImg
                        img.frame.size = CGSizeMake(34, 34)
                        img.frame.origin.x = (self.resultsScrollView.frame.size.width - self.imgX) - img.frame.size.width
                        img.frame.origin.y = self.imgY
                        img.layer.zPosition = 30
                        img.layer.cornerRadius = img.frame.size.width/2
                        img.clipsToBounds = true
                        self.resultsScrollView.addSubview(img)
                        self.imgY += frameLabel.frame.size.height + 20

                        self.resultsScrollView.contentSize = CGSizeMake(width, self.messageY)

                    }else{
                        var messageLabel:UILabel = UILabel()
                        messageLabel.frame = CGRectMake(0, 0, self.resultsScrollView.frame.size.width-94, CGFloat.max)
                        messageLabel.backgroundColor = UIColor.groupTableViewBackgroundColor()
                        messageLabel.lineBreakMode = NSLineBreakMode.ByWordWrapping
                        messageLabel.textAlignment = NSTextAlignment.Left
                        messageLabel.numberOfLines = 0
                        messageLabel.font = UIFont(name: "Helvetica Neuse", size: 17)
                        messageLabel.textColor = UIColor.blackColor()
                        messageLabel.text = self.messageArray[i]
                        messageLabel.sizeToFit()
                        messageLabel.layer.zPosition = 20
                        messageLabel.frame.origin.x = self.messageX
                        messageLabel.frame.origin.y = self.messageY
                        self.resultsScrollView.addSubview(messageLabel)
                        self.messageY += messageLabel.frame.size.height + 30

                        var frameLabel:UILabel = UILabel()
                        frameLabel.frame = CGRectMake(self.frameX, self.frameY, messageLabel.frame.size.width+10, messageLabel.frame.size.height+10)
                        frameLabel.backgroundColor = UIColor.groupTableViewBackgroundColor()
                        frameLabel.layer.masksToBounds = true
                        frameLabel.layer.cornerRadius = 10
                        self.resultsScrollView.addSubview(frameLabel)
                        self.frameY += frameLabel.frame.size.height + 20

                        var img:UIImageView = UIImageView()
                        img.image = self.otherImg
                        img.frame = CGRectMake(self.imgX, self.imgY, 34, 34)
                        img.layer.zPosition = 30
                        img.layer.cornerRadius = img.frame.size.width/2
                        img.clipsToBounds = true
                        self.resultsScrollView.addSubview(img)
                        self.imgY += frameLabel.frame.size.height + 20


                        self.resultsScrollView.contentSize = CGSizeMake(width, self.messageY)
                    }

                    var bottomOffset:CGPoint = CGPointMake(0, self.resultsScrollView.contentSize.height - self.resultsScrollView.bounds.size.height)
                    self.resultsScrollView.setContentOffset(bottomOffset, animated: false)
                }
            }
        }
    }

    @IBAction func sendButton_click(sender: AnyObject) {

        if messageTextView.text == "" {
            println("no text")
        }else{
            var messageDBTable = PFObject(className: "Messages")
            messageDBTable["sender"] = userName
            messageDBTable["other"] = otherName
            messageDBTable["message"] = self.messageTextView.text
            messageDBTable.saveInBackgroundWithBlock{
                (success:Bool!,error:NSError!) -> Void in

                if success == true{

                    var uQuery:PFQuery = PFUser.query()
                    uQuery.whereKey("username", equalTo: otherName)

                    var pushQuery:PFQuery = PFInstallation.query()
                    pushQuery.whereKey("user", matchesQuery: uQuery)

                    var push:PFPush = PFPush()
                    push.setQuery(pushQuery)
                    push.setMessage("New Message")
                    push.sendPush(nil)
                    println("push sent")

                    println("message sent")
                    self.messageTextView.text = ""
                    self.mLabel.hidden = false
                    self.refreshResults()
                }

            }
        }

    }
}
