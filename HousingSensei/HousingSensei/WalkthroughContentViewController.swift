//
//  WalkthroughContentViewController.swift
//  HousingSensei
//
//  Created by Mac for Rav on 12/1/19.
//  Copyright © 2019 InvictusProgramming. All rights reserved.
//

import Foundation
import UIKit

class WalkthroughContentViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet var headingLabel: UILabel! {
        didSet {
            headingLabel.numberOfLines = 0
        }
    }
    
    @IBOutlet var subHeadingLabel: UILabel! {
        didSet {
            subHeadingLabel.numberOfLines = 0
        }
    }
    
    @IBOutlet var contentImageView: UIImageView!
    
    // MARK: - Properties
    
    var index = 0
    var heading = ""
    var subHeading = ""
    var imageFile = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        headingLabel.text = heading
        subHeadingLabel.text = subHeading
        contentImageView.image = UIImage(named: imageFile)
}
}
