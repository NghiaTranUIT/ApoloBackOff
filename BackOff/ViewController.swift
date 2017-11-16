//
//  ViewController.swift
//  Backoff
//
//  Created by NghiaTran on 11/16/17.
//  Copyright © 2017 Zalora. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    private var count = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        callSyncAPI()
    }
    
    func callSyncAPI() {
        BackoffDispatcher.shared.dispatchFibonacci("WishListSync") {[unowned self] (attempt, completion) in
            
            print("---------------------------")
            let randomNumber = arc4random_uniform(100)
            print("Attemp at \(attempt), number = \(randomNumber)")
            
            if randomNumber >= 85 {
                print("Success! Terminating the back-off instance.")
                completion(true)
            } else {
                print("Failed, retrying after some time.")
                completion(false)
            }
            
            if attempt == 5 {
                // Reset 
                print("*** RESET")
                self.callSyncAPI()
            }
        }
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
