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
    let row: Int
    
    var isSpecial: Bool {
        didSet {
            updateSpecialCircle()
        }
    }
    
    var isTarget: Bool {
        didSet {
            updateTitleColor()
            updateTargetCircle()
        }
    }
    
    private let dayLabel = UILabel()
    private let specialCircle = CircleView()
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
        
        dayLabel.text = String(describing: date.dayOfMonth)
        dayLabel.textAlignment = .center
        addSubview(dayLabel)
        
        specialCircle.backgroundColor = .clear
        specialCircle.fillColor = UIColor(colorLiteralRed: 204/255, green: 204/255, blue: 204/255, alpha: 1)
        targetCircle.backgroundColor = .clear
        
        updateTitleColor()
        updateSpecialCircle()
        updateTargetCircle()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        bringSubview(toFront: specialCircle)
        bringSubview(toFront: dayLabel)
        
        dayLabel.sizeToFit()
        dayLabel.centerInSuperview()
        
        targetCircle.frame = bounds
        
        specialCircle.size = CGSize(width: 5, height: 5)
        specialCircle.y = dayLabel.maxY + 3
        specialCircle.centerHorizontallyInSuperview()
    }
    
    // MARK: - Private
    
    private func updateSpecialCircle() {
        if isSpecial {
            addSubview(specialCircle)
        } else {
            specialCircle.removeFromSuperview()
        }
    }
    
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
        dayLabel.textColor = .black
        if date.isToday {
            dayLabel.textColor = .red
        }

        if isTarget {
            dayLabel.textColor = .white
        }
    }
}
