//
//  CircleView.swift
//  ThreeOneOne
//
//  Created by Kaden, Joshua on 5/18/16.
//  Copyright © 2016 NYC DoITT. All rights reserved.
//

import UIKit

final class CircleView: UIView {

    @IBInspectable var fillColor: UIColor = UIColor.gray
    
    override func draw(_ rect: CGRect) {
        let origin: CGPoint
        let side: CGFloat
        if bounds.width < bounds.height {
            let offset = (bounds.height - bounds.width) / CGFloat(2)
            origin = CGPoint(x: CGFloat(0), y: offset)
            side = bounds.width
        } else {
            let offset = (bounds.width - bounds.height) / CGFloat(2)
            origin = CGPoint(x: offset, y: CGFloat(0))
            side = bounds.height
        }
        
        let circleFrame = CGRect(origin: origin, size: CGSize(width: side, height: side))
        let path = UIBezierPath(ovalIn: circleFrame)
        fillColor.setFill()
        path.fill()
    }
    
}
