//
//  ViewController.swift
//  Backoff
//
//  Created by NghiaTran on 11/16/17.
//  Copyright © 2017 Zalora. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        BackoffDispatcher.shared.dispatchExponential { (attempt, completion) in
            
            print("---------------------------")
            let randomNumber = arc4random_uniform(100)
            print("Attemp at \(attempt), number = \(randomNumber)")
            
            if randomNumber == 97 {
                print("Success! Terminating the back-off instance.")
                completion(true)
            } else {
                print("Failed, retrying after some time.")
                completion(false)
            }
    
        }
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
