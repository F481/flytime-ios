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
    var timesTodayHour: [Int]!
    var timesTomorrowHour: [Int]!
    var timesDays: [Int]!
    var wind: [Double]!
    var temprature: [Double]!
    let datahandler = DataHandler()
    var weatherData: WeatherData!

    @IBOutlet weak var daySegmentedOutlet: UISegmentedControl!
    @IBOutlet weak var lineChartView: LineChartView!
    
    
    @IBAction func daySegmentedAction(_ sender: Any) {
        NSLog("selectes Segment = %1d", daySegmentedOutlet.selectedSegmentIndex)
        if daySegmentedOutlet.selectedSegmentIndex == 2 {
            timesDays.removeAll()
            wind.removeAll()
            temprature.removeAll()
            weatherData = datahandler.getWeatherData()
            for datas in weatherData.daily.data {
                if datas.time != nil{
                    print(datas.time)
                    print(datas.temperatureMax)
                    print(datas.windSpeed)
                    timesDays.append(datas.time)
                    temprature.append(datas.temperatureMax)
                    wind.append(datas.windSpeed)
                    
                }
                
            }
            setChart(dataPoints: timesDays, valuesTemp: temprature, valuesWind: wind)
            lineChartView.xAxis.setLabelCount(timesDays.count, force: true)
            lineChartView.xAxis.valueFormatter = DateValueFormatterDay()
            lineChartView.notifyDataSetChanged()
        }else if daySegmentedOutlet.selectedSegmentIndex == 1 {
            setChart(dataPoints: timesTodayHour, valuesTemp: temprature, valuesWind: wind)
            print(datahandler.weatherData.daily.data[3].summary)
            lineChartView.xAxis.setLabelCount(timesTodayHour.count, force: true)
            lineChartView.xAxis.valueFormatter = DateValueFormatterHour()
            lineChartView.notifyDataSetChanged()
        }else{
            setChart(dataPoints: timesTodayHour, valuesTemp: temprature, valuesWind: wind)
            lineChartView.xAxis.setLabelCount(timesTodayHour.count, force: true)
            lineChartView.xAxis.valueFormatter = DateValueFormatterHour()
            lineChartView.notifyDataSetChanged()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLineChartView()
        datahandler.getDataFromApi(latitude: 47.81009, longitude: 9.63863)
        // will be initialized by data from server
        timesTodayHour = [1511780400,1511784000,1511787600,1511791200]
        timesDays = [1511780400,1511823600,1511910000,1511996400]
        temprature = [3.83,4.77,4.93,4.08]
        wind = [3.47,4.09,4.76,4.73]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setChart(dataPoints: [Int], valuesTemp: [Double], valuesWind: [Double]) {
        var lineChartData: LineChartData?
        var dataEntriesTemp: [ChartDataEntry] = []
        var dataEntriesWind: [ChartDataEntry] = []
        
        for i in 0..<dataPoints.count {
            let dataEntryTemp = ChartDataEntry(x: Double(dataPoints[i]), y: valuesTemp[i])
            dataEntriesTemp.append(dataEntryTemp)
            let dataEntryWind = ChartDataEntry(x: Double(dataPoints[i]), y: valuesWind[i])
            dataEntriesWind.append(dataEntryWind)
        }
        let lineChartDataSetTemp = LineChartDataSet(values: dataEntriesTemp, label: "C°")
        lineChartDataSetTemp.setColor(.green)
        let lineChartDataSetWind = LineChartDataSet(values: dataEntriesWind, label: "m/s")
        lineChartDataSetWind.setColor(.blue)
        lineChartData = LineChartData(dataSets: [lineChartDataSetTemp, lineChartDataSetWind])
        lineChartView.data = lineChartData
        lineChartView.chartDescription?.text = "Wetter"
    }
    func setLineChartView() {
        lineChartView.pinchZoomEnabled = false
        lineChartView.doubleTapToZoomEnabled = false
        lineChartView.setScaleEnabled(false)
        lineChartView.xAxis.labelPosition = .bottom
        lineChartView.rightAxis.enabled = false
        lineChartView.backgroundColor = UIColor(red: 189/255, green: 195/255, blue: 199/255, alpha: 1)
        lineChartView.noDataText = "You need to provide data for the chart."
    }
    
}

