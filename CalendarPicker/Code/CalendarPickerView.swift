//
//  CalendarPickerView.swift
//  CalendarPicker
//
//  Created by Kaden, Joshua on 9/28/17.
//  Copyright © 2017 NYC DoITT. All rights reserved.
//

import UIKit

enum CalendarPickerMonthType { case current, next, previous }

final class CalendarPickerView: UIView {
    
    // MARK: - Public Static Constants
    
    static let dayLabelsHeight = CGFloat(20)

    // MARK: - Public Properties
    
    var dayButtonTapAction: ((Date) -> Void)? {
        get { return calendarGridView.dayButtonTapAction }
        set { calendarGridView.dayButtonTapAction = newValue }
    }
    
    var targetDate: Date {
        get { return calendarGridView.targetDate }
        set { calendarGridView.targetDate = newValue }
    }
    
    // MARK: - Private Properties
    
    fileprivate let calendarGridView = CalendarGridView()
    fileprivate let calendarGridViewNext = CalendarGridView()
    fileprivate let calendarGridViewPrevious = CalendarGridView()

    private let dayLabelsContainer = UIView()

    fileprivate var pageWidth: CGFloat { return calendarGridView.width }

    private let scrollView = UIScrollView()
    
    // MARK: - Lifecycle
    
    override func willMove(toWindow newWindow: UIWindow?) {
        super.willMove(toWindow: newWindow)
        guard let _ = newWindow else { return }
        
        let dayNames = [
            NSLocalizedString("S", comment: "Very short weekday name for Sunday"),
            NSLocalizedString("M", comment: "Very short weekday name for Monday"),
            NSLocalizedString("T", comment: "Very short weekday name for Tuesday"),
            NSLocalizedString("W", comment: "Very short weekday name for Wednesday"),
            NSLocalizedString("T", comment: "Very short weekday name for Thursday"),
            NSLocalizedString("F", comment: "Very short weekday name for Friday"),
            NSLocalizedString("S", comment: "Very short weekday name for Saturday")
        ]
        dayNames.forEach {
            name in
            let label = UILabel()
            label.text = name
            label.textAlignment = .center
            label.font = .systemFont(ofSize: 10)
            self.dayLabelsContainer.addSubview(label)
        }
        addSubview(dayLabelsContainer)
        
        scrollView.delegate = self
        scrollView.isDirectionalLockEnabled = true
        scrollView.isPagingEnabled = true
        addSubview(scrollView)

        scrollView.addSubview(calendarGridView)
        scrollView.addSubview(calendarGridViewNext)
        scrollView.addSubview(calendarGridViewPrevious)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        scrollView.size = CGSize(width: width, height: height - scrollView.y)
        scrollView.contentSize = CGSize(width: scrollView.width * 3, height: scrollView.height)
        
        let pageSize = scrollView.bounds.size
        
        dayLabelsContainer.size = CGSize(width: width, height: CalendarPickerView.dayLabelsHeight)
        for index in 0...6 {
            guard let label = dayLabelsContainer.subviews[index] as? UILabel else { return }
            label.sizeToFit()
            label.width = pageSize.width / 7
            label.x = CGFloat(index) * label.width
            label.centerVerticallyInSuperview()
        }
        
        scrollView.y = dayLabelsContainer.maxY
        
        calendarGridViewPrevious.size = pageSize
        
        calendarGridView.size = pageSize
        calendarGridView.x = calendarGridViewPrevious.maxX
        
        calendarGridViewNext.size = pageSize
        calendarGridViewNext.x = calendarGridView.maxX
    }
    
    // MARK: - Public
    
    func apply(specials: [Date], monthType: CalendarPickerMonthType) {
        switch monthType {
        case .current:
            calendarGridView.apply(specials: specials)
        case .next:
            calendarGridViewNext.apply(specials: specials)
        case .previous:
            calendarGridViewPrevious.apply(specials: specials)
        }
    }
    
    func buildButtons(targetDate date: Date, shouldForce: Bool = false) {
        if date.isSameDay(date: targetDate) && !shouldForce { return }
        targetDate = date
        reloadData()
    }
    
    // MARK: - Private
    
    fileprivate func didScroll(page: Int) {
        if page == 2 { return }
        if page < 1 || page > 3 { return }
        
        let newDate: Date
        if page == 1 {
//            Analytics.tagEvent("NYC Calendar Swipe Prev Month", attributes: [:])
            newDate = targetDate.startOfPreviousMonth
        } else {
//            Analytics.tagEvent("NYC Calendar Swipe Next Month", attributes: [:])
            newDate = targetDate.endOfMonth.plus(days: 1)
        }
        
        targetDate = newDate
        reloadData()
        
        if let dayButtonTapAction = dayButtonTapAction {
            dayButtonTapAction(targetDate)
        }
    }
    
    private func reloadData() {
        calendarGridView.buildButtons(targetDate: targetDate)
        calendarGridViewPrevious.buildButtons(targetDate: targetDate.startOfPreviousMonth)
        calendarGridViewNext.buildButtons(targetDate: targetDate.endOfMonth.plus(days: 1))
        
        self.scrollView.contentOffset = CGPoint(x: self.pageWidth, y: 0)
    }
}

// MARK: - UIScrollViewDelegate

extension CalendarPickerView: UIScrollViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        calendarGridView.isEnabled = false
        calendarGridViewNext.isEnabled = false
        calendarGridViewPrevious.isEnabled = false
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        calendarGridView.isEnabled = true
        calendarGridViewNext.isEnabled = true
        calendarGridViewPrevious.isEnabled = true
        
        let offset = scrollView.contentOffset.x
        let page: Int
        switch offset {
        case 0...pageWidth - 1:
            page = 1
        case pageWidth...pageWidth * 2 - 1:
            page = 2
        default:
            page = 3
        }
        didScroll(page: page)
    }
}
