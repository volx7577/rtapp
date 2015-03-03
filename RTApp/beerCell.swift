//
//  beerCell.swift
//  RTApp
//
//  Created by Ben Barclay on 3/3/15.
//  Copyright (c) 2015 Ben Barclay. All rights reserved.
//

import UIKit

class beerCell: UITableViewCell {

    @IBOutlet weak var votesLabel: UILabel!
    @IBOutlet weak var votesButton: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()


    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
