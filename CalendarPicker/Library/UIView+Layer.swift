//
//  UIView+Layer.swift
//  ThreeOneOne
//
//  Created by Kaden, Joshua on 11/4/15.
//  Copyright © 2015 NYC DoITT. All rights reserved.
//

import UIKit

extension UIView {
    
    var borderColor: UIColor? {
        get {
            guard let color = self.layer.borderColor else { return nil }
            return UIColor(cgColor: color)
        }
        set { self.layer.borderColor = newValue?.cgColor }
    }
    
    var borderWidth: CGFloat {
        get { return self.layer.borderWidth }
        set { self.layer.borderWidth = newValue }
    }
    
    var cornerRadius: CGFloat {
        get { return self.layer.cornerRadius }
        set { self.layer.cornerRadius = newValue }
    }
    
}
