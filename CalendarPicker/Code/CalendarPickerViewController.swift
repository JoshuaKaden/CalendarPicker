//
//  CalendarPickerViewController.swift
//  CalendarPicker
//
//  Created by Kaden, Joshua on 9/28/17.
//  Copyright © 2017 NYC DoITT. All rights reserved.
//

import UIKit

final class CalendarPickerViewController: UIViewController {
    
    let standardHeight = CGFloat(216)
    
    override func loadView() {
        view = CalendarPickerView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        view.height = standardHeight
    }
    
}
