//
//  photoFeedVC.swift
//  RTApp
//
//  Created by Ben Barclay on 3/6/15.
//  Copyright (c) 2015 Ben Barclay. All rights reserved.
//

import UIKit

let reuseIdentifier = "photoCell"


class photoFeedVC: UICollectionViewController {

    var resultsArray = [PFFile]()
    var urlArray = [String]()
    var urlArrayIndex = -1

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        // self.collectionView!.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        // self.collectionView!.registerClass(photoCell.self, forCellWithReuseIdentifier: reuseIdentifier)


        self.resultsArray.removeAll(keepCapacity: false)

        var query = PFQuery(className: "Photo")
        var objects = query.findObjects()

        for object in objects{
            self.resultsArray.append(object["photo"] as PFFile)
            self.urlArray.append((object["photo"] as PFFile).url)
        }

    }

    override func viewWillAppear(animated: Bool) {
       
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        //#warning Incomplete method implementation -- Return the number of sections
        return 1
    }

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //#warning Incomplete method implementation -- Return the number of items in the section
        return resultsArray.count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as photoCell

        cell.backgroundColor = UIColor.redColor()

        resultsArray[indexPath.row].getDataInBackgroundWithBlock {
            (imageData : NSData!, error : NSError!) -> Void in

            if error == nil{
                let image = UIImage(data: imageData)
                cell.imageView.image = image
            }
        }

        return cell
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    override func collectionView(collectionView: UICollectionView,
        didSelectItemAtIndexPath indexPath: NSIndexPath){
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as photoCell
            urlArrayIndex = indexPath.row

            self.performSegueWithIdentifier("goToPhotoDetailVC", sender: self)

    }

    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(collectionView: UICollectionView, shouldShowMenuForItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, canPerformAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, performAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) {
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if(segue.identifier == "goToPhotoDetailVC") {
            var datas = segue.destinationViewController as photoDetailVC

            datas.dataPassedURL = urlArray[urlArrayIndex]
        }
    }


}
