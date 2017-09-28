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
    
    // MARK: Lifecycle
    
    init(row: Int, column: Int, date: Date, isSpecial: Bool = false) {
        self.row = row
        self.column = column
        self.date = date
        self.isSpecial = isSpecial
        
        super.init(frame: CGRect.zero)
        
        title = String(describing: date.dayOfMonth)
        if date.isToday {
            titleColor = .purple
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
}
