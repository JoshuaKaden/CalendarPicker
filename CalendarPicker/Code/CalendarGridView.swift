//
//  CalendarGridView.swift
//  CalendarPicker
//
//  Created by Kaden, Joshua on 9/28/17.
//  Copyright © 2017 NYC DoITT. All rights reserved.
//

import UIKit

final class CalendarGridView: UIView {
    
    private var buttons: [CalendarDayButton] = [] {
        didSet {
            oldValue.forEach { $0.removeFromSuperview() }
            buttons.forEach { self.addSubview($0) }
            setNeedsLayout()
        }
    }
    
    var dayButtonTapAction: ((Date) -> Void)?
    
    // MARK: - Lifecycle
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let lastRowIndex = buttons.last?.row ?? 0
        let buttonSize = CGSize(width: width / 7, height: height / CGFloat(lastRowIndex + 1))
        
        buttons.forEach {
            button in
            button.size = buttonSize
            button.x = CGFloat(button.column) * buttonSize.width
            button.y = CGFloat(button.row) * buttonSize.height
        }
    }
    
    // MARK: - Handlers
    
    func didTapCalendarDayButton(_ sender: UIButton) {
        guard let button: CalendarDayButton = sender as? CalendarDayButton else { return }
        if let dayButtonTapAction = dayButtonTapAction {
            dayButtonTapAction(button.date)
        }
    }
    
    // MARK: - Public
    
    func buildButtons(targetDate date: Date, specials: [Date]?) {
        let startDate = date.startOfMonth
        let endDate = date.endOfMonth
        
        var buttons: [CalendarDayButton] = []
        var currentRow: Int = 0
        var currentColumn: Int = startDate.dayOfWeek - 1
        
        for buttonIndex in 0...endDate.dayOfMonth - 1 {
            let buttonDate = startDate.plus(days: buttonIndex)
            let isSpecial = specials?.contains(buttonDate) ?? false
            
            let button = CalendarDayButton(row: currentRow, column: currentColumn, date: buttonDate, isSpecial: isSpecial)
            button.addTarget(self, action: #selector(didTapCalendarDayButton(_:)), for: .touchUpInside)
            buttons.append(button)
            
            if currentColumn == 6 {
                currentRow += 1
                currentColumn = 0
            } else {
                currentColumn += 1
            }
        }
        
        self.buttons = buttons
    }
}
