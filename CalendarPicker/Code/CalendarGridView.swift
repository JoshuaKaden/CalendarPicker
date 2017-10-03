//
//  CalendarGridView.swift
//  CalendarPicker
//
//  Created by Kaden, Joshua on 9/28/17.
//  Copyright © 2017 NYC DoITT. All rights reserved.
//

import UIKit

final class CalendarGridView: UIView {
    
    // MARK: - Public Static Constants
    
    static let standardHeight = (buttonHeight * CGFloat(6))
    
    // MARK: - Private Static Constants
    
    private static let buttonHeight = CGFloat(40)

    // MARK: - Public Properties
    
    var dateColor: UIColor? {
        didSet {
            buttons.forEach { $0.dateColor = self.dateColor }
        }
    }
    
    var dateWithFocusColor: UIColor? {
        didSet {
            buttons.forEach { $0.dateWithFocusColor = self.dateWithFocusColor }
        }
    }
    
    var dayButtonTapAction: ((Date) -> Void)?
    
    var focusColor: UIColor? {
        didSet {
            buttons.forEach { $0.focusColor = self.focusColor }
        }
    }

    var focusTodayColor: UIColor? {
        didSet {
            buttons.forEach { $0.focusTodayColor = self.focusTodayColor }
        }
    }

    var isEnabled: Bool = true {
        didSet {
            if isEnabled {
                blockerView.removeFromSuperview()
            } else {
                addSubview(blockerView)
            }
        }
    }
    
    var specialColor: UIColor? {
        didSet {
            buttons.forEach { $0.specialColor = self.specialColor }
        }
    }

    var targetDate: Date = Date() {
        didSet {
            if targetDate.isSameDay(date: oldValue) { return }
            buttons.forEach { $0.isTarget = false }
            guard let button = buttons.first(where: { $0.date.isSameDay(date: targetDate) }) else { return }
            button.isTarget = true
        }
    }
    
    var todayColor: UIColor? {
        didSet {
            buttons.forEach { $0.todayColor = self.todayColor }
        }
    }

    var todayWithFocusColor: UIColor? {
        didSet {
            buttons.forEach { $0.todayWithFocusColor = self.todayWithFocusColor }
        }
    }

    // MARK: - Private Properties
    
    private let blockerView = UIView()
    
    private var buttons: [CalendarDayButton] = [] {
        didSet {
            oldValue.forEach { $0.removeFromSuperview() }
            buttons.forEach { self.addSubview($0) }
            setNeedsLayout()
        }
    }
    
    // MARK: - Lifecycle
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let buttonSize = CGSize(width: width / 7, height: CalendarGridView.buttonHeight)
                
        buttons.forEach {
            button in
            button.size = buttonSize
            button.x = CGFloat(button.column) * buttonSize.width
            button.y = CGFloat(button.row) * buttonSize.height
        }
        
        blockerView.frame = bounds
    }
    
    // MARK: - Handlers
    
    func didTapCalendarDayButton(_ sender: UIButton) {
        guard let button: CalendarDayButton = sender as? CalendarDayButton else { return }
        targetDate = button.date
        if let dayButtonTapAction = dayButtonTapAction {
            dayButtonTapAction(button.date)
        }
    }
    
    // MARK: - Public
    
    func apply(specials: [Date]) {
        buttons.forEach { $0.isSpecial = specials.contains($0.date) }
    }
    
    func buildButtons(targetDate date: Date, shouldHighlightTargetDate: Bool) {
        targetDate = date
       
        if let targetButton = self.buttons.first(where: { $0.date.isSameDay(date: targetDate) }) {
            targetButton.isTarget = shouldHighlightTargetDate
            setNeedsLayout()
            return
        }
        
        let startDate = date.startOfMonth
        let endDate = date.endOfMonth
        
        var buttons: [CalendarDayButton] = []
        var currentRow: Int = 0
        var currentColumn: Int = startDate.dayOfWeek - 1
        
        for buttonIndex in 0...endDate.dayOfMonth - 1 {
            let buttonDate = startDate.plus(days: buttonIndex)
            
            let isTarget: Bool
            if shouldHighlightTargetDate {
                isTarget = buttonDate.isSameDay(date: date)
            } else {
                isTarget = false
            }
            
            let button = CalendarDayButton(row: currentRow, column: currentColumn, date: buttonDate, isSpecial: false, isTarget: isTarget)
            button.addTarget(self, action: #selector(didTapCalendarDayButton(_:)), for: .touchUpInside)
            button.dateColor = dateColor
            button.dateWithFocusColor = dateWithFocusColor
            button.focusColor = focusColor
            button.focusTodayColor = focusTodayColor
            button.specialColor = specialColor
            button.todayColor = todayColor
            button.todayWithFocusColor = todayWithFocusColor
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
