//
//  photoCell.swift
//  RTApp
//
//  Created by Ben Barclay on 3/6/15.
//  Copyright (c) 2015 Ben Barclay. All rights reserved.
//

import UIKit

class photoCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()

        imageView.image = UIImage(named: "3.png")
    }

}
