//
//  CircularButton.swift
//  Lab4
//
//  Created by Steve Li on 10/20/19.
//  Copyright © 2019 Steve Li. All rights reserved.
// Reference from https://stackoverflow.com/questions/49047818/making-buttons-circular-in-swift4

import Foundation
import UIKit

@IBDesignable class CirclularButton : UIButton{
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        sharedInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        sharedInit()
    }
    
    override func prepareForInterfaceBuilder() {
        sharedInit()
    }
    
    func sharedInit() {
        refreshCorners(value: cornerRadius)
    }
    
    func refreshCorners(value: CGFloat) {
        layer.cornerRadius = value
    }
    
    @IBInspectable var cornerRadius: CGFloat = 15 {
        didSet {
            refreshCorners(value: cornerRadius)
        }
    }
}
