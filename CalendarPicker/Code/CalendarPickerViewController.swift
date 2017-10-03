//
//  CalendarPickerViewController.swift
//  CalendarPicker
//
//  Created by Kaden, Joshua on 9/28/17.
//  Copyright © 2017 NYC DoITT. All rights reserved.
//

import UIKit

// MARK: - CalendarPickerViewControllerDataSource Protocol

protocol CalendarPickerViewControllerDataSource: class {
    func findSpecialDates(calendarPickerViewController: CalendarPickerViewController, startDate: Date, endDate: Date, completion: @escaping ([Date]) -> Void)
}

// MARK: - CalendarPickerViewControllerDelegate Protocol

protocol CalendarPickerViewControllerDelegate: class {
    func didChangeDate(calendarPickerViewController: CalendarPickerViewController, newDate: Date, oldDate: Date)
    func didSwipeToNextMonth(calendarPickerViewController: CalendarPickerViewController)
    func didSwipeToPreviousMonth(calendarPickerViewController: CalendarPickerViewController)
}

// Creaing a protocol extension to make some methods optional.
extension CalendarPickerViewControllerDelegate {
    func didSwipeToNextMonth(calendarPickerViewController: CalendarPickerViewController) {}
    func didSwipeToPreviousMonth(calendarPickerViewController: CalendarPickerViewController) {}
}

// MARK: - CalendarPickerViewController

final class CalendarPickerViewController: UIViewController {
    
    // MARK: - Public Properties
    var backgroundColor: UIColor? = CalendarPickerViewController.defaultBackgroundColor {
        didSet {
            if !isViewLoaded { return }
            if let backgroundColor = backgroundColor {
                view.backgroundColor = backgroundColor
            } else {
                view.backgroundColor = CalendarPickerViewController.defaultBackgroundColor
            }
        }
    }
    
    weak var dataSource: CalendarPickerViewControllerDataSource?
    
    private(set) var date = Date()
    
    var dateColor: UIColor? = CalendarPickerViewController.defaultDateColor {
        didSet {
            if !isViewLoaded { return }
            if let dateColor = dateColor {
                calendarPickerView.dateColor = dateColor
            } else {
                calendarPickerView.dateColor = CalendarPickerViewController.defaultDateColor
            }
        }
    }

    var dateWithFocusColor: UIColor? = CalendarPickerViewController.defaultDateWithFocusColor {
        didSet {
            if !isViewLoaded { return }
            if let dateWithFocusColor = dateWithFocusColor {
                calendarPickerView.dateWithFocusColor = dateWithFocusColor
            } else {
                calendarPickerView.dateWithFocusColor = CalendarPickerViewController.defaultDateWithFocusColor
            }
        }
    }

    weak var delegate: CalendarPickerViewControllerDelegate?
    
    var focusColor: UIColor? = CalendarPickerViewController.defaultFocusColor {
        didSet {
            if !isViewLoaded { return }
            if let focusColor = focusColor {
                calendarPickerView.focusColor = focusColor
            } else {
                calendarPickerView.focusColor = CalendarPickerViewController.defaultFocusColor
            }
        }
    }

    var focusTodayColor: UIColor? = CalendarPickerViewController.defaultFocusTodayColor {
        didSet {
            if !isViewLoaded { return }
            if let focusTodayColor = focusTodayColor {
                calendarPickerView.focusTodayColor = focusTodayColor
            } else {
                calendarPickerView.focusTodayColor = CalendarPickerViewController.defaultFocusTodayColor
            }
        }
    }

    var isEnabled: Bool {
        get { return calendarPickerView.isEnabled }
        set { calendarPickerView.isEnabled = newValue }
    }
    
    var specialColor: UIColor? = CalendarPickerViewController.defaultSpecialColor {
        didSet {
            if !isViewLoaded { return }
            if let specialColor = specialColor {
                calendarPickerView.specialColor = specialColor
            } else {
                calendarPickerView.specialColor = CalendarPickerViewController.defaultSpecialColor
            }
        }
    }

    let standardHeight = CalendarGridView.standardHeight + CalendarPickerView.dayLabelsHeight

    var todayColor: UIColor? = CalendarPickerViewController.defaultTodayColor {
        didSet {
            if !isViewLoaded { return }
            if let todayColor = todayColor {
                calendarPickerView.todayColor = todayColor
            } else {
                calendarPickerView.todayColor = CalendarPickerViewController.defaultTodayColor
            }
        }
    }

    var todayWithFocusColor: UIColor? = CalendarPickerViewController.defaultTodayWithFocusColor {
        didSet {
            if !isViewLoaded { return }
            if let todayWithFocusColor = todayWithFocusColor {
                calendarPickerView.todayWithFocusColor = todayWithFocusColor
            } else {
                calendarPickerView.todayWithFocusColor = CalendarPickerViewController.defaultTodayWithFocusColor
            }
        }
    }

    // MARK: - Private Properties
    
    private var calendarPickerView: CalendarPickerView { return view as! CalendarPickerView }
    private static let defaultBackgroundColor = UIColor(colorLiteralRed: 247/255, green: 247/255, blue: 247/255, alpha: 1)
    private static let defaultDateColor = UIColor.black
    private static let defaultDateWithFocusColor = UIColor.white
    private static let defaultFocusColor = UIColor.black
    private static let defaultFocusTodayColor = UIColor.red
    private static let defaultSpecialColor = UIColor(colorLiteralRed: 204/255, green: 204/255, blue: 204/255, alpha: 1)
    private static let defaultTodayColor = UIColor.red
    private static let defaultTodayWithFocusColor = UIColor.white
    
    // MARK: - Lifecycle
    
    override func loadView() {
        view = CalendarPickerView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = backgroundColor
        
        calendarPickerView.dateColor = dateColor
        calendarPickerView.dateWithFocusColor = dateWithFocusColor
        calendarPickerView.focusColor = focusColor
        calendarPickerView.focusTodayColor = focusTodayColor
        calendarPickerView.specialColor = specialColor
        calendarPickerView.todayColor = todayColor
        calendarPickerView.todayWithFocusColor = todayWithFocusColor
        
        calendarPickerView.dayButtonTapAction = {
            [weak self]
            date in
            
            guard let strongSelf = self, !date.isSameDay(date: strongSelf.date) else { return }
            
            let oldDate = strongSelf.date
            strongSelf.date = date
            strongSelf.delegate?.didChangeDate(calendarPickerViewController: strongSelf, newDate: date, oldDate: oldDate)
            strongSelf.findSpecialDates()
        }
        
        calendarPickerView.monthSwipeAction = {
            [weak self]
            monthType in
            
            guard let strongSelf = self else { return }
            switch monthType {
            case .current:
                // no op
                break
            case .next:
                strongSelf.delegate?.didSwipeToNextMonth(calendarPickerViewController: strongSelf)
            case .previous:
                strongSelf.delegate?.didSwipeToPreviousMonth(calendarPickerViewController: strongSelf)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configure()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        view.height = standardHeight
    }
    
    // MARK: - Public
    
    func setDate(_ newDate: Date, animated: Bool, completion: (() -> Void)? = nil) {
        let monthType: CalendarPickerMonthType
        let oldDate = date
        if newDate.isSameMonth(date: oldDate) {
            monthType = .current
        } else {
            if Calendar.current.component(.month, from: newDate) > Calendar.current.component(.month, from: oldDate) {
                monthType = .next
            } else {
                monthType = .previous
            }
        }
        
        if monthType == .current || !animated {
            date = newDate
            calendarPickerView.buildButtons(targetDate: newDate, shouldForce: false)
            return
        }
        
        UIView.animate(withDuration: 0.33, animations: {
            
            if monthType == .previous {
                self.calendarPickerView.scrollViewContentOffsetX = 0
            } else {
                self.calendarPickerView.scrollViewContentOffsetX += self.calendarPickerView.scrollViewContentOffsetX
            }
            
        }, completion: {
            done in
            self.date = newDate
            self.calendarPickerView.buildButtons(targetDate: newDate, shouldForce: false)
            if let completion = completion {
                completion()
            }
        })
    }
    
    // MARK: - Private
    
    private func configure() {
        view.width = UIScreen.main.bounds.size.width
        view.height = standardHeight
        calendarPickerView.buildButtons(targetDate: date, shouldForce: true)
        findSpecialDates()
    }
    
    private func findSpecialDates() {
        dataSource?.findSpecialDates(calendarPickerViewController: self, startDate: date.startOfMonth, endDate: date.endOfMonth) {
            dates in
            self.calendarPickerView.apply(specials: dates, monthType: .current)
        }
        
        dataSource?.findSpecialDates(calendarPickerViewController: self, startDate: date.endOfMonth.plus(days: 1), endDate: date.endOfMonth.plus(days: 1).endOfMonth) {
            dates in
            self.calendarPickerView.apply(specials: dates, monthType: .next)
        }
        
        dataSource?.findSpecialDates(calendarPickerViewController: self, startDate: date.startOfPreviousMonth, endDate: date.startOfPreviousMonth.endOfMonth) {
            dates in
            self.calendarPickerView.apply(specials: dates, monthType: .previous)
        }
    }
}
