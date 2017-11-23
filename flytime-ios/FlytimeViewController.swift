//
//  FlytimeViewController.swift
//  flytime-ios
//
//  Created by KOENIG on 23.11.17.
//  Copyright © 2017 KOENIG. All rights reserved.
//

import UIKit
import Charts
class FlytimeViewController: UIViewController {
    @IBOutlet weak var daySegmentedOutlet: UISegmentedControl!
    @IBOutlet weak var lineChartView: LineChartView!
    
    @IBAction func daySegmentedAction(_ sender: Any) {
        NSLog("%1d", daySegmentedOutlet.selectedSegmentIndex)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lineChartView.isHidden = false
        lineChartView.noDataText = "Need Data maybe your internet sucks!!"

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
