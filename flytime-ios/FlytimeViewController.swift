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
    var days: [String]!
    var units: [Double]!
    let months = ["Jan", "Feb", "Mar",
                  "Apr", "May", "Jun",
                  "Jul", "Aug", "Sep",
                  "Oct", "Nov", "Dec"]
    var times: [Int]!
    @IBOutlet weak var daySegmentedOutlet: UISegmentedControl!
    @IBOutlet weak var lineChartView: LineChartView!
    
    
    @IBAction func daySegmentedAction(_ sender: Any) {
        NSLog("%1d", daySegmentedOutlet.selectedSegmentIndex)
        if daySegmentedOutlet.selectedSegmentIndex == 2 {
            units = [5.0,10.0,15.0,20.0,10.0,7.0,3.0]
            days = ["MO","DI","MI","DO","FR","SA","SO"]
            lineChartView.xAxis.setLabelCount(7, force: true)
            setChart(dataPoints: days, values: units)
            lineChartView.xAxis.valueFormatter = XAxisValueFormatter(values: days)
        }else if daySegmentedOutlet.selectedSegmentIndex == 1 {
            units = []
            days = ["MO","DI","MI","DO","FR","SA","SO"]
            for i in 1..<days.count+1{
                NSLog("dayas count = %d",i)
                units.append(Double(i))
            }
            setChartTime(dataPoints: times, values: units)
            lineChartView.xAxis.setLabelCount(3, force: true)
            lineChartView.xAxis.valueFormatter = DateValueFormatter()
            lineChartView.notifyDataSetChanged()
            
        }else{
            units = []
            for i in 1..<months.count+1{
                NSLog("months count = %d",i)
                units.append(Double(i))
            }
            lineChartView.xAxis.setLabelCount(11, force: true)
            lineChartView.xAxis.valueFormatter = IntAxisValueFormatter()
            setChart(dataPoints: months, values: units)
                lineChartView.notifyDataSetChanged()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lineChartView.pinchZoomEnabled = false
        lineChartView.doubleTapToZoomEnabled = false
        lineChartView.setScaleEnabled(false)
        lineChartView.xAxis.labelPosition = .bottom
        lineChartView.rightAxis.enabled = false
        times = [1511780536, 1511787736]

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func setChart(dataPoints: [String], values: [Double]) {
        lineChartView.backgroundColor = UIColor(red: 189/255, green: 195/255, blue: 199/255, alpha: 1)
        lineChartView.noDataText = "You need to provide data for the chart."
        var dataEntries: [ChartDataEntry] = []
        var dataEntries2: [ChartDataEntry] = []
        for i in 1..<dataPoints.count {
            NSLog("%d, %d", dataPoints.count,i)
            let dataEntry = ChartDataEntry(x: Double(i), y: values[i])
            dataEntries.append(dataEntry)
           // dataEntries.append(dataEntry)
        }
        let dataEntry2 = ChartDataEntry(x: 3.0, y: 4.0)
        let dataEntry3 = ChartDataEntry(x: 3.5, y: 7.0)
        dataEntries2.append(dataEntry2)
        dataEntries2.append(dataEntry3)
        let lineChartDataSet2 = LineChartDataSet(values: dataEntries2, label: "km/h")
        lineChartDataSet2.setColor(.green)
        let lineChartDataSet = LineChartDataSet(values: dataEntries, label: "C°")
        lineChartDataSet.setColor(.blue)
        let lineChartData = LineChartData(dataSets: [lineChartDataSet, lineChartDataSet2])
        lineChartView.data = lineChartData
        lineChartView.chartDescription?.text = "Wetter"
    }

    func setChartTime(dataPoints: [Int], values: [Double]) {
        var dataEntries: [ChartDataEntry] = []
    
        for i in 0..<dataPoints.count {
            let dataEntry = ChartDataEntry(x: Double(dataPoints[i]), y: values[i] )
            dataEntries.append(dataEntry)
        }
        let lineChartDataSet = LineChartDataSet(values: dataEntries, label: "C°")
        let lineChartData = LineChartData(dataSet: lineChartDataSet)
        lineChartView.data = lineChartData
    
    }

}

