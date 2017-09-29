//
//  ExampleViewController.swift
//  CalendarPicker
//
//  Created by Kaden, Joshua on 9/28/17.
//  Copyright © 2017 NYC DoITT. All rights reserved.
//

import UIKit

final class ExampleViewController: UIViewController {
    
    private var calendarPickerView: UIView { return calendarPickerViewController.view }
    private let calendarPickerViewController = CalendarPickerViewController()
    private let detailLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .gray
        
        calendarPickerViewController.dateChangedAction = {
            date in
            self.detailLabel.text = String(describing: date.timeless)
        }
        calendarPickerViewController.dataSource = self
        adoptChildViewController(calendarPickerViewController)
        
        detailLabel.font = .boldSystemFont(ofSize: 24)
        detailLabel.textAlignment = .center
        detailLabel.textColor = .white
        view.addSubview(detailLabel)
    }
    
    deinit {
        calendarPickerViewController.leaveParentViewController()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        calendarPickerView.width = view.width
        
        detailLabel.y = calendarPickerView.maxY
        detailLabel.width = view.width
        detailLabel.height = view.height - detailLabel.y
    }
}

extension ExampleViewController: CalendarPickerDataSource {
    func monthlySpecials(dayOne: Date) -> [Date] {
        return [dayOne.plus(days: 5), dayOne.plus(days: 10), dayOne.plus(days: 15)]
    }
}
