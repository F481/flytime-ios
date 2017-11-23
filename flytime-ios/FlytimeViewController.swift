//
//  FlytimeViewController.swift
//  flytime-ios
//
//  Created by KOENIG on 23.11.17.
//  Copyright © 2017 KOENIG. All rights reserved.
//

import UIKit

class FlytimeViewController: UIViewController {
    @IBOutlet weak var daySegmentedOutlet: UISegmentedControl!
    @IBOutlet weak var DiagramViewOutlet: UIView!
    
    @IBAction func daySegmentedAction(_ sender: Any) {
        NSLog("%1d", daySegmentedOutlet.selectedSegmentIndex)
        if daySegmentedOutlet.selectedSegmentIndex == 1 {
            DiagramViewOutlet.isHidden = false
        }else{
            DiagramViewOutlet.isHidden = true
        }    
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        DiagramViewOutlet.isHidden = true
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */


}
