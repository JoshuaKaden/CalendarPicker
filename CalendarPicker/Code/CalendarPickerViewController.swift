//
//  CalendarPickerViewController.swift
//  CalendarPicker
//
//  Created by Kaden, Joshua on 9/28/17.
//  Copyright © 2017 NYC DoITT. All rights reserved.
//

import UIKit

protocol CalendarPickerDataSource: class {
    func findSpecialDates(startDate: Date, endDate: Date, completion: ([Date]) -> Void)
}

final class CalendarPickerViewController: UIViewController {
    
    // MARK: - Public Properties
    
    weak var dataSource: CalendarPickerDataSource?
    
    var date: Date = Date() {
        didSet {
            if date.isSameMonth(date: oldValue) {
                calendarPickerView.targetDate = date
                return
            }
            configure()
        }
    }
    
    var dateChangedAction: ((Date) -> Void)?
    
    let standardHeight = CalendarGridView.standardHeight + CalendarPickerView.dayLabelsHeight

    // MARK - Private Properties
    
    private var calendarPickerView: CalendarPickerView { return view as! CalendarPickerView }
    
    // MARK: - Lifecycle
    
    override func loadView() {
        view = CalendarPickerView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(colorLiteralRed: 247/255, green: 247/255, blue: 247/255, alpha: 1)
        
        calendarPickerView.dayButtonTapAction = {
            [weak self]
            date in
            
            self?.date = date
            
            if let dateChangedAction = self?.dateChangedAction {
                dateChangedAction(date)
            }
            
            self?.findSpecialDates()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        configure()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        view.height = standardHeight
    }
    
    // MARK: - Private
    
    private func configure() {
        calendarPickerView.buildButtons(targetDate: date, shouldForce: true)
        findSpecialDates()
    }
    
    private func findSpecialDates() {
        dataSource?.findSpecialDates(startDate: date.startOfMonth, endDate: date.endOfMonth) {
            dates in
            calendarPickerView.apply(specials: dates, monthType: .current)
        }
        
        dataSource?.findSpecialDates(startDate: date.endOfMonth.plus(days: 1), endDate: date.endOfMonth.plus(days: 1).endOfMonth) {
            dates in
            calendarPickerView.apply(specials: dates, monthType: .next)
        }
        
        dataSource?.findSpecialDates(startDate: date.startOfPreviousMonth, endDate: date.startOfPreviousMonth.endOfMonth) {
            dates in
            calendarPickerView.apply(specials: dates, monthType: .previous)
        }
    }
}
