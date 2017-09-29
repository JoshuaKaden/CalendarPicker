//
//  CalendarPickerView.swift
//  CalendarPicker
//
//  Created by Kaden, Joshua on 9/28/17.
//  Copyright © 2017 NYC DoITT. All rights reserved.
//

import UIKit

final class CalendarPickerView: UIView {
    
    private let calendarGridView = CalendarGridView()
    var dayButtonTapAction: ((Date) -> Void)? {
        get { return calendarGridView.dayButtonTapAction }
        set { calendarGridView.dayButtonTapAction = newValue }
    }
    var targetDate: Date {
        get { return calendarGridView.targetDate }
        set { calendarGridView.targetDate = newValue }
    }
    
    // MARK: - Lifecycle
    
    override func willMove(toWindow newWindow: UIWindow?) {
        super.willMove(toWindow: newWindow)
        guard let _ = newWindow else { return }
        
        addSubview(calendarGridView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        calendarGridView.frame = bounds
    }
    
    // MARK: - Public
    
    func apply(specials: [Date]) {
        calendarGridView.apply(specials: specials)
    }
    
    func buildButtons(targetDate date: Date, specials: [Date]?) {
        calendarGridView.buildButtons(targetDate: date, specials: specials)
    }
}
