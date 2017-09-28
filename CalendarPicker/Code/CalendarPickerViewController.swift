//
//  CalendarPickerViewController.swift
//  CalendarPicker
//
//  Created by Kaden, Joshua on 9/28/17.
//  Copyright © 2017 NYC DoITT. All rights reserved.
//

import UIKit

protocol CalendarPickerDataSource: class {
    func monthlySpecials(dayOne: Date) -> [Date]
}

final class CalendarPickerViewController: UIViewController {
    
    private var calendarPickerView: CalendarPickerView { return view as! CalendarPickerView }
    weak var dataSource: CalendarPickerDataSource?
    
    var date: Date = Date() {
        didSet {
            if date.isSameMonth(date: oldValue) { return }
            configure()
        }
    }
    
    var dateChangedAction: ((Date) -> Void)?
    
    let standardHeight = CGFloat(216)
    
    // MARK: - Lifecycle
    
    override func loadView() {
        view = CalendarPickerView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        calendarPickerView.dayButtonTapAction = {
            date in
            if let dateChangedAction = self.dateChangedAction {
                dateChangedAction(date)
            }
        }
        
        configure()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        view.height = standardHeight
    }
    
    // MARK: - Handlers
    
    func didTapCalendarDayButton(_ sender: UIButton) {
        guard let button: CalendarDayButton = sender as? CalendarDayButton else { return }
        
        if date.isSameDay(date: button.date) {
            return
        }
        
        date = button.date
        
        if let dateChangedAction = dateChangedAction {
            dateChangedAction(date)
        }
    }
    
    // MARK: - Private
    
    private func configure() {
        let specials = dataSource?.monthlySpecials(dayOne: date.startOfMonth)
        calendarPickerView.buildButtons(targetDate: date, specials: specials)
    }
}
