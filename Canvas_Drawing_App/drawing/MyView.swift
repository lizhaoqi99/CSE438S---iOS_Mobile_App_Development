//
//  MyView.swift
//  lab3
//
//  Created by Steve Li on 9/29/19.
//  Copyright © 2019 Steve Li. All rights reserved.
//

import UIKit

class MyView: UIView {
    
    var curveCollection: [Curve] = [] {
        didSet {
            setNeedsDisplay()
        }
    } // use a 2-d CGPoint array to make sure there won't be a straight line connecting the point on the last curve drawn to the first point on the new curve
    
    var lastCurveCollection: [Curve] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.clear
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    
    override func draw(_ rect: CGRect) {
        for curves in curveCollection {
            let path = Functions.createQuadPath(points: curves.points, pathWidth: curves.curveWidth, color: curves.color)
            if curves.isFill {
                path.fill()
            }
            path.stroke()
        }
    }
    
    
}
