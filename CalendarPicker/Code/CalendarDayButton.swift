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
            if isTarget {
                backgroundColor = .black
            } else {
                backgroundColor = .clear
            }
        }
    }
    
    // MARK: Lifecycle
    
    init(row: Int, column: Int, date: Date, isSpecial: Bool = false, isTarget: Bool = false) {
        self.row = row
        self.column = column
        self.date = date
        self.isSpecial = isSpecial
        self.isTarget = isTarget
        
        super.init(frame: CGRect.zero)
    }
    
    override func willMove(toWindow newWindow: UIWindow?) {
        super.willMove(toWindow: newWindow)
        guard let _ = newWindow else { return }
        
        title = String(describing: date.dayOfMonth)
        
        if date.isToday {
            titleColor = .purple
        }
        
        if isTarget {
            backgroundColor = .black
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
}
