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
    
    weak var dataSource: CalendarPickerDataSource?
    
    var date: Date = Date() {
        didSet {
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
        configure()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        view.height = standardHeight
    }
    
    // MARK: - Private
    
    private func configure() {
        let startDate = date.startOfMonth
        let endDate = date.endOfMonth
        
        var buttons: [CalendarDayButton] = []
        var currentRow: Int = 0
        var currentColumn: Int = startDate.dayOfWeek - 1
        
        for buttonIndex in 0...endDate.dayOfMonth - 1 {
            let buttonDate = startDate.plus(days: buttonIndex)
            let button = CalendarDayButton(row: currentRow, column: currentColumn, date: buttonDate)
            buttons.append(button)
            
            if currentColumn == 6 {
                currentRow += 1
                currentColumn = 0
            } else {
                currentColumn += 1
            }
        }
        
        buttons.forEach { print("\($0.row), \($0.column) \($0.date)") }
    }
}
