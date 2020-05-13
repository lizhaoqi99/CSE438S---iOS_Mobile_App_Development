//
//  functiond.swift
//  temp
//
//  Created by Steve Li on 9/29/19.
//  Copyright © 2019 Steve Li. All rights reserved.
//

import Foundation
//
//  Functions.swift
//  lab3
//
//  Created by Steve Li on 9/29/19.
//  Copyright © 2019 Steve Li. All rights reserved.
//

import Foundation
import UIKit

class Functions {
    static func midpoint(first: CGPoint, second: CGPoint) -> CGPoint {
        let mid = CGPoint(x: (second.x + first.x)/2, y: (second.y + first.y)/2)
        return mid
    }
    
    static func createQuadPath(points: [CGPoint], pathWidth: CGFloat, color: UIColor) -> UIBezierPath {
        
        color.setFill()
        color.setStroke()
        let path = UIBezierPath() //Create the path object
        path.lineCapStyle = .round // round the curve
        path.lineJoinStyle = .round
        path.lineWidth = pathWidth
        if(points.count >= 2) {
            path.move(to: points[0]) //Start the path on the first point
            for i in 1..<points.count - 1{
                let firstMidpoint = midpoint(first: path.currentPoint, second:
                    points[i]) //Get midpoint between the path's last point and the next one in the array
                let secondMidpoint = midpoint(first: points[i], second:
                    points[i+1]) //Get midpoint between the next point in the array and the one after it
                path.addCurve(to: secondMidpoint, controlPoint1: firstMidpoint,
                              controlPoint2: points[i]) //This creates a cubic Bezier curve using math!
            }
            return path
        } else {
            return path
        }
    }
}
