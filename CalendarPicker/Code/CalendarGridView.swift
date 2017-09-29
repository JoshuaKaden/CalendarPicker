//
//  CalendarGridView.swift
//  CalendarPicker
//
//  Created by Kaden, Joshua on 9/28/17.
//  Copyright © 2017 NYC DoITT. All rights reserved.
//

import UIKit

final class CalendarGridView: UIView {
    
    static let buttonHeight = CGFloat(44)
    static let standardHeight = buttonHeight * CGFloat(6)
    
    private let blockerView = UIView()
    
    private var buttons: [CalendarDayButton] = [] {
        didSet {
            oldValue.forEach { $0.removeFromSuperview() }
            buttons.forEach { self.addSubview($0) }
            setNeedsLayout()
        }
    }
    
    var dayButtonTapAction: ((Date) -> Void)?
    
    var isEnabled: Bool = true {
        didSet {
            if isEnabled {
                blockerView.removeFromSuperview()
            } else {
                addSubview(blockerView)
            }
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
    
    func buildButtons(targetDate date: Date, specials: [Date]? = nil) {
        let startDate = date.startOfMonth
        let endDate = date.endOfMonth
        
        var buttons: [CalendarDayButton] = []
        var currentRow: Int = 0
        var currentColumn: Int = startDate.dayOfWeek - 1
        
        for buttonIndex in 0...endDate.dayOfMonth - 1 {
            let buttonDate = startDate.plus(days: buttonIndex)
            let isSpecial = specials?.contains(buttonDate) ?? false
            let isTarget = buttonDate.isSameDay(date: date)
            
            let button = CalendarDayButton(row: currentRow, column: currentColumn, date: buttonDate, isSpecial: isSpecial, isTarget: isTarget)
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
