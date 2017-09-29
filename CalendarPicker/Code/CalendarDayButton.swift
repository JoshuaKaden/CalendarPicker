//
//  CalendarDayButton.swift
//  CalendarPicker
//
//  Created by Kaden, Joshua on 9/28/17.
//  Copyright © 2017 NYC DoITT. All rights reserved.
//

import UIKit

final class CalendarDayButton: UIButton {
    let column: Int
    let date: Date
    let isSpecial: Bool
    let row: Int
    
    var isTarget: Bool {
        didSet {
            updateTitleColor()
            updateTargetCircle()
        }
    }
    
    private let targetCircle = CircleView()
    
    // MARK: - Lifecycle
    
    init(row: Int, column: Int, date: Date, isSpecial: Bool = false, isTarget: Bool = false) {
        self.row = row
        self.column = column
        self.date = date
        self.isSpecial = isSpecial
        self.isTarget = isTarget
        
        super.init(frame: CGRect.zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func willMove(toWindow newWindow: UIWindow?) {
        super.willMove(toWindow: newWindow)
        guard let _ = newWindow else { return }
        
        title = String(describing: date.dayOfMonth)
        updateTitleColor()
        
        targetCircle.backgroundColor = .clear
        updateTargetCircle()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        bringSubview(toFront: titleLabel!)
        
        targetCircle.frame = bounds
    }
    
    // MARK: - Private
    
    private func updateTargetCircle() {
        if isTarget {
            addSubview(targetCircle)
            
            if date.isToday {
                targetCircle.fillColor = .red
            } else {
                targetCircle.fillColor = .black
            }
            
        } else {
            targetCircle.removeFromSuperview()
        }
    }
    
    private func updateTitleColor() {
        titleColor = .black
        if date.isToday {
            titleColor = .red
        }

        if isTarget {
            titleColor = .white
        }
    }
}
