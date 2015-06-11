//
//  coffeeVC.swift
//  RTApp
//
//  Created by Ben Barclay on 3/9/15.
//  Copyright (c) 2015 Ben Barclay. All rights reserved.
//

import UIKit

class coffeeVC: UIViewController {

    @IBOutlet weak var coffeeTable: UITableView!
    @IBOutlet weak var coffeeCell: UITableViewCell!

    override func viewDidLoad() {
        super.viewDidLoad()

       // coffeeTable.frame = CGRectMake(<#x: CGFloat#>, <#y: CGFloat#>, <#width: CGFloat#>, <#height: CGFloat#>)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
