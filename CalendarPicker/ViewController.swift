//
//  ViewController.swift
//  CalendarPicker
//
//  Created by Kaden, Joshua on 9/28/17.
//  Copyright © 2017 NYC DoITT. All rights reserved.
//

import UIKit

final class ViewController: UIViewController {

    private let startButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        startButton.title = NSLocalizedString("Start", comment: "")
        startButton.titleColor = UIColor.blue
        view.addSubview(startButton)
        
        startButton.addTarget(self, action: #selector(didTapStart(_:)), for: .touchUpInside)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        startButton.sizeToFit()
        startButton.centerInSuperview()
    }
    
    func didTapStart(_ sender: UIButton) {
        let vc = ExampleViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
}
