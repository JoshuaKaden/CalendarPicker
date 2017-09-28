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
    
    init(row: Int, column: Int, date: Date) {
        self.row = row
        self.column = column
        self.date = date
        super.init(frame: CGRect.zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
