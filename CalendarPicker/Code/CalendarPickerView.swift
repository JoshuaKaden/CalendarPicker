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
    
    static let dayLabelsHeight = CGFloat(24)

    // MARK: - Public Properties
    
    var dateColor: UIColor? {
        didSet {
            calendarGridView.dateColor = dateColor
            calendarGridViewNext.dateColor = dateColor
            calendarGridViewPrevious.dateColor = dateColor
        }
    }

    var dateWithFocusColor: UIColor? {
        didSet {
            calendarGridView.dateWithFocusColor = dateWithFocusColor
            calendarGridViewNext.dateWithFocusColor = dateWithFocusColor
            calendarGridViewPrevious.dateWithFocusColor = dateWithFocusColor
        }
    }
    
    var dayButtonTapAction: ((Date) -> Void)? {
        get { return calendarGridView.dayButtonTapAction }
        set { calendarGridView.dayButtonTapAction = newValue }
    }
    
    var focusColor: UIColor? {
        didSet {
            calendarGridView.focusColor = focusColor
            calendarGridViewNext.focusColor = focusColor
            calendarGridViewPrevious.focusColor = focusColor
        }
    }

    var focusTodayColor: UIColor? {
        didSet {
            calendarGridView.focusTodayColor = focusTodayColor
            calendarGridViewNext.focusTodayColor = focusTodayColor
            calendarGridViewPrevious.focusTodayColor = focusTodayColor
        }
    }

    var isEnabled: Bool = true {
        didSet {
            calendarGridView.isEnabled = isEnabled
            calendarGridViewNext.isEnabled = isEnabled
            calendarGridViewPrevious.isEnabled = isEnabled
        }
    }
    
    var monthSwipeAction: ((CalendarPickerMonthType) -> Void)?
    
    var scrollViewContentOffsetX: CGFloat {
        get { return scrollView.contentOffset.x }
        set { scrollView.contentOffset = CGPoint(x: newValue, y: scrollView.contentOffset.y) }
    }
    
    var specialColor: UIColor? {
        didSet {
            calendarGridView.specialColor = specialColor
            calendarGridViewNext.specialColor = specialColor
            calendarGridViewPrevious.specialColor = specialColor
        }
    }

    var targetDate: Date {
        get { return calendarGridView.targetDate }
        set { calendarGridView.targetDate = newValue }
    }
    
    var todayColor: UIColor? {
        didSet {
            calendarGridView.todayColor = todayColor
            calendarGridViewNext.todayColor = todayColor
            calendarGridViewPrevious.todayColor = todayColor
        }
    }

    var todayWithFocusColor: UIColor? {
        didSet {
            calendarGridView.todayWithFocusColor = todayWithFocusColor
            calendarGridViewNext.todayWithFocusColor = todayWithFocusColor
            calendarGridViewPrevious.todayWithFocusColor = todayWithFocusColor
        }
    }

    // MARK: - Private Properties
    
    fileprivate var calendarGridView: CalendarGridView { return calendarGridViews[1] }
    fileprivate var calendarGridViewNext: CalendarGridView { return calendarGridViews[2] }
    fileprivate var calendarGridViewPrevious: CalendarGridView { return calendarGridViews[0] }
    private var calendarGridViews: [CalendarGridView] = [CalendarGridView(), CalendarGridView(), CalendarGridView()]

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
        calendarGridViewPrevious.x = 0
        
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
    
    func scrollToCurrentMonth() {
        if scrollView.contentOffset.x == width { return }
        scrollView.size = CGSize(width: width * 3, height: height - CalendarPickerView.dayLabelsHeight)
        scrollView.contentSize = CGSize(width: width * 3, height: height - CalendarPickerView.dayLabelsHeight)
        scrollView.contentOffset = CGPoint(x: width, y: 0)
    }
    
    // MARK: - Private
    
    fileprivate func didScroll(page: Int) {
        if page == 2 { return }
        if page < 1 || page > 3 { return }
        
        let oldTargetDate = targetDate
        
        let newDate: Date
        let monthType: CalendarPickerMonthType
        if page == 1 {
            monthType = .previous
            newDate = oldTargetDate.startOfPreviousMonth
        } else {
            monthType = .next
            newDate = oldTargetDate.endOfMonth.plus(days: 1)
        }
        
        swapGridViews(monthType: monthType)
        targetDate = newDate
        reloadData()
        
        if let monthSwipeAction = self.monthSwipeAction {
            monthSwipeAction(monthType)
        }
        
        if let dayButtonTapAction = self.dayButtonTapAction {
            dayButtonTapAction(targetDate)
        }
    }
    
    private func reloadData() {
        scrollToCurrentMonth()
        calendarGridView.buildButtons(targetDate: targetDate, shouldHighlightTargetDate: true)
        DispatchQueue.main.async {
            self.calendarGridViewPrevious.buildButtons(targetDate: self.targetDate.startOfPreviousMonth, shouldHighlightTargetDate: false)
            self.calendarGridViewNext.buildButtons(targetDate: self.targetDate.endOfMonth.plus(days: 1), shouldHighlightTargetDate: false)
        }
    }
    
    private func swapGridViews(monthType: CalendarPickerMonthType) {
        if monthType == .current { return }
        
        let gridView = calendarGridView
        let gridViewNext = calendarGridViewNext
        let gridViewPrevious = calendarGridViewPrevious
        
        calendarGridView.removeFromSuperview()
        calendarGridViewNext.removeFromSuperview()
        calendarGridViewPrevious.removeFromSuperview()
        
        calendarGridViews.removeAll()
        
        let newGridView = CalendarGridView()
        newGridView.dateColor = dateColor
        newGridView.dateWithFocusColor = dateWithFocusColor
        newGridView.focusColor = focusColor
        newGridView.focusTodayColor = focusTodayColor
        newGridView.specialColor = specialColor
        newGridView.todayColor = todayColor
        newGridView.todayWithFocusColor = todayWithFocusColor
        
        if monthType == .previous {
            calendarGridViews = [newGridView, gridViewPrevious, gridView]
        } else {
            calendarGridViews = [gridView, gridViewNext, newGridView]
        }
        
        scrollView.addSubview(calendarGridView)
        scrollView.addSubview(calendarGridViewNext)
        scrollView.addSubview(calendarGridViewPrevious)
        
        calendarGridView.frame = gridView.frame
        calendarGridViewNext.frame = gridViewNext.frame
        calendarGridViewPrevious.frame = gridViewPrevious.frame
        
        calendarGridView.dayButtonTapAction = gridView.dayButtonTapAction
    }
}

// MARK: - UIScrollViewDelegate

extension CalendarPickerView: UIScrollViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        isEnabled = false
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        isEnabled = true
        
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
