//
//  ViewController.swift
//  AYTimeAgo
//
//  Created by Ayman Rawashdeh on 4/6/17.
//  Copyright © 2017 Ayman Rawashdeh. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let now = Date()
        
        AYTimeAgo.locale = Locale(identifier: "ar")
        
        for i in 1...200 {
            
            print(now.ay_timeAgo(from: now.ay_addHours(value: i * -1)))
           
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

