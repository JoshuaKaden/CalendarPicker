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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .gray
        
        calendarPickerViewController.dateChangedAction = {
            date in
            print(date)
        }
        adoptChildViewController(calendarPickerViewController)
    }
    
    deinit {
        calendarPickerViewController.leaveParentViewController()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        calendarPickerView.width = view.width
    }
}
