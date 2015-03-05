//
//  photoCell.swift
//  RTApp
//
//  Created by Ben Barclay on 3/4/15.
//  Copyright (c) 2015 Ben Barclay. All rights reserved.
//

import UIKit

class photoCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!

    override func awakeFromNib() {
        imageView.center = CGPointMake(50, 50)
    }

}
