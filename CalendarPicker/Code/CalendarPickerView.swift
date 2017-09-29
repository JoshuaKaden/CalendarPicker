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
    
    fileprivate let calendarGridView = CalendarGridView()
    fileprivate let calendarGridViewNext = CalendarGridView()
    fileprivate let calendarGridViewPrevious = CalendarGridView()

    fileprivate var pageWidth: CGFloat { return calendarGridView.width }

    private let scrollView = UIScrollView()
    
    // MARK: - Public Properties
    
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
