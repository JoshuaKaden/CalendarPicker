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
    
    var dateColor: UIColor?
    var dateWithFocusColor: UIColor?
    var focusColor: UIColor?
    var focusTodayColor: UIColor?
    var specialColor: UIColor?
    var todayColor: UIColor?
    var todayWithFocusColor: UIColor?
    
    var isSpecial: Bool {
        didSet {
            DispatchQueue.main.async {
                self.updateSpecialCircle()
            }
        }
    }
    
    var isTarget: Bool {
        didSet {
            DispatchQueue.main.async {
                self.updateTitleColor()
                self.updateTargetCircle()
            }
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
        dayLabel.textColor = dateColor
        addSubview(dayLabel)
        
        specialCircle.backgroundColor = .clear
        specialCircle.fillColor = specialColor ?? UIColor(colorLiteralRed: 204/255, green: 204/255, blue: 204/255, alpha: 1)
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
            if specialCircle.superview != self {
                addSubview(specialCircle)
            }
        } else {
            specialCircle.removeFromSuperview()
        }
    }
    
    private func updateTargetCircle() {
        if isTarget {
            if targetCircle.superview != self {
                addSubview(targetCircle)
            }
            
            if date.isToday {
                targetCircle.fillColor = focusTodayColor ?? .red
            } else {
                targetCircle.fillColor = focusColor ?? .black
            }
            
        } else {
            if self.targetCircle.superview == nil { return }
            UIView.animate(withDuration: 0.33, animations: {
                self.targetCircle.alpha = 0
            }, completion: {
                done in
                self.targetCircle.removeFromSuperview()
                self.targetCircle.alpha = 1
            })
        }
    }
    
    private func updateTitleColor() {
        dayLabel.textColor = dateColor
        if date.isToday {
            dayLabel.textColor = todayColor
        }

        if isTarget {
            if date.isToday {
                dayLabel.textColor = todayWithFocusColor
            } else {
                dayLabel.textColor = dateWithFocusColor
            }
        }
    }
}
