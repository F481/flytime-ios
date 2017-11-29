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
    var times = [0]
    var wind = [0.0]
    var temprature = [0.0]
    let datahandler = DataHandler()
    var weatherData: WeatherData!
    @IBOutlet weak var daySegmentedOutlet: UISegmentedControl!
    @IBOutlet weak var lineChartView: LineChartView!
    
    
    @IBAction func daySegmentedAction(_ sender: Any) {
        NSLog("selectes Segment = %1d", daySegmentedOutlet.selectedSegmentIndex)
        if daySegmentedOutlet.selectedSegmentIndex == 2 {
            clearWeatherData()
            fillWeatherDataDays()
            setChart(dataPoints: times, valuesTemp: temprature, valuesWind: wind)
            lineChartView.xAxis.valueFormatter = DateValueFormatterDay()
            lineChartView.notifyDataSetChanged()
        }else if daySegmentedOutlet.selectedSegmentIndex == 1 {
            clearWeatherData()
            fillWeatherDataTomorrowHours()
            setChart(dataPoints: times, valuesTemp: temprature, valuesWind: wind)
            lineChartView.xAxis.valueFormatter = DateValueFormatterHour()
            lineChartView.notifyDataSetChanged()
        }else{
            clearWeatherData()
            fillWeatherDataTodayHours()
            setChart(dataPoints: times, valuesTemp: temprature, valuesWind: wind)
            lineChartView.xAxis.valueFormatter = DateValueFormatterHour()
            lineChartView.notifyDataSetChanged()
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        weatherData = datahandler.getWeatherData()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setLineChartView()
        datahandler.getDataFromApi(latitude: 47.81009, longitude: 9.63863)
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
        lineChartView.xAxis.setLabelCount(times.count, force: true)
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
    func clearWeatherData() {
        times.removeAll()
        wind.removeAll()
        temprature.removeAll()
    }
    func fillWeatherDataTodayHours() {
        for hours in weatherData.hourly.data {
            if hours.time >= datahandler.sunriseTimeToday && hours.time <= datahandler.sunsetTimeToday{
                times.append(hours.time)
                temprature.append(hours.temperature)
                wind.append(hours.windSpeed)
            }
        }
    }
    func fillWeatherDataTomorrowHours() {
        for hours in weatherData.hourly.data {
            if hours.time >= datahandler.sunriseTimeTomorrow && hours.time <= datahandler.sunsetTimeTomorrow{
                times.append(hours.time)
                temprature.append(hours.temperature)
                wind.append(hours.windSpeed)
            }
        }
    }
    func fillWeatherDataDays() {
        for days in weatherData.daily.data {
            if days.time != nil{
                times.append(days.time)
                temprature.append(days.temperatureMax)
                wind.append(days.windSpeed)
            }
        }
    }
}

