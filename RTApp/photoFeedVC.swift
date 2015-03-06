//
//  photoFeedVC.swift
//  RTApp
//
//  Created by Ben Barclay on 3/4/15.
//  Copyright (c) 2015 Ben Barclay. All rights reserved.
//

import UIKit

let reuseIdentifier = "Cell"

class photoFeedVC: UICollectionViewController,UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {

    @IBOutlet var photoCollection: UICollectionView!

    var resultsArray = [PFFile]()
    private let reuseIdentifier = "photoCell"

    override func viewDidLoad() {
        super.viewDidLoad()

        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 20, left: 10, bottom: 10, right: 10)
        layout.itemSize = CGSize(width: 50, height: 50)
        self.collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        self.collectionView!.dataSource = self
        self.collectionView!.delegate = self
        self.collectionView!.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        self.collectionView!.backgroundColor = UIColor.whiteColor()
        self.view.addSubview(collectionView!)


    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewDidAppear(animated: Bool){
        resultsArray.removeAll(keepCapacity: false)

        var query = PFQuery(className: "Photo")
        var objects = query.findObjects()

        for object in objects{

            self.resultsArray.append(object["photo"] as PFFile)
        }

        println(resultsArray.count)
        self.collectionView?.reloadData()
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

        resultsArray[indexPath.row].getDataInBackgroundWithBlock({
            (imageData: NSData!, error:NSError!) -> Void in

            if error == nil{
                let image = UIImage(data: imageData)
                cell.imageView.image = image
            }
        })

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

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(collectionView: UICollectionView, shouldShowMenuForItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, canPerformAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, performAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) {
    
    }
    */

}
