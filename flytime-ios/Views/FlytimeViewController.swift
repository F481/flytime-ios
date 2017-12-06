//
//  FlytimeViewController.swift
//  flytime-ios
//
//  Created by KOENIG on 23.11.17.
//  Copyright © 2017 KOENIG. All rights reserved.
//

import UIKit
import Charts
import CoreLocation

class FlytimeViewController: UIViewController {
    var times: [Int] = [0]
    var wind: [Double] = [0.0]
    var whileFlag: Bool = true
    var temprature: [Double] = [0.0]
    var precip: [Double] = [0.0]
    let datahandler = DataHandler()
    var weatherData: WeatherData!
    let actInd: UIActivityIndicatorView = UIActivityIndicatorView()
    @IBOutlet weak var daySegmentedOutlet: UISegmentedControl!
    @IBOutlet weak var chartView: CombinedChartView!
    @IBOutlet weak var textfield: UITextView!
    
    @IBAction func daySegmentedAction(_ sender: Any) {
        NSLog("selectes Segment = %1d", daySegmentedOutlet.selectedSegmentIndex)
        if daySegmentedOutlet.selectedSegmentIndex == 2 {
            addWeatherWeek()
            setBestFlyTime(dataPoints: times)
        }else if daySegmentedOutlet.selectedSegmentIndex == 1 {
            addWeatherTomorrow()
        }else{
            addWeatherToday()
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        while whileFlag {
            weatherData = datahandler.getWeatherData()
            if weatherData != nil{
                actInd.stopAnimating()
                addWeatherToday()
                actInd.isHidden = true
                whileFlag = false
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        showActivityIndicatory(uiView: chartView)
        setChartView()
        datahandler.getDataFromApi(latitude: 47.81009, longitude: 9.63863)
        let rightAxis = chartView.rightAxis
        rightAxis.labelTextColor = .blue
        rightAxis.axisMinimum = 0.0
        rightAxis.axisMaximum = 100.0
        rightAxis.gridColor = .blue
        let marker = BalloonMarker(color: .gray,
                                   font: .systemFont(ofSize: 12),
                                   textColor: .white,
                                   insets: UIEdgeInsets(top: 8, left: 8, bottom: 20, right: 8))
        marker.chartView = chartView
        marker.minimumSize = CGSize(width: 80, height: 40)
        chartView.marker = marker

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func setChartView() {
        chartView.pinchZoomEnabled = false
        chartView.doubleTapToZoomEnabled = false
        chartView.setScaleEnabled(false)
        chartView.xAxis.labelPosition = .bottom
        chartView.backgroundColor = UIColor(red: 189/255, green: 195/255, blue: 199/255, alpha: 1)
        chartView.chartDescription?.enabled = true
        chartView.chartDescription?.font = .systemFont(ofSize: 10)
        chartView.chartDescription?.text = "Powered by Darksky.net"
        chartView.chartDescription?.position = CGPoint(x: 138, y: 3)
        chartView.extraTopOffset = 20
    }
    
    func setLineCharts(dataPoints: [Int], valuesTemp: [Double], valuesWind: [Double], valuesPrecip: [Double], labelPrecip: String) {
        var lineChartData: LineChartData?
        var dataEntriesTemp: [ChartDataEntry] = []
        var dataEntriesWind: [ChartDataEntry] = []
        var dataEntriesPrecip: [ChartDataEntry] = []
        
        for i in 0..<dataPoints.count {
            let dataEntryTemp = ChartDataEntry(x: Double(dataPoints[i]), y: valuesTemp[i])
            dataEntriesTemp.append(dataEntryTemp)
            let dataEntryWind = ChartDataEntry(x: Double(dataPoints[i]), y: valuesWind[i])
            dataEntriesWind.append(dataEntryWind)
            let dataEntryPrecip = ChartDataEntry(x: Double(dataPoints[i]), y: valuesPrecip[i]*100)
            dataEntriesPrecip.append(dataEntryPrecip)
        }
        let lineChartDataSetTemp = LineChartDataSet(values: dataEntriesTemp, label: "Temperatur [C°]")
        lineChartDataSetTemp.axisDependency = .left
        setPropsLineChartDataSet(lineChartDataSet: lineChartDataSetTemp, color: .red)
        let lineChartDataSetWind = LineChartDataSet(values: dataEntriesWind, label: "Windgeschw. [m/s]")
        lineChartDataSetWind.axisDependency = .left
        setPropsLineChartDataSet(lineChartDataSet: lineChartDataSetWind, color: .green)
        let lineChartDataSetPrecip = LineChartDataSet(values: dataEntriesPrecip, label: labelPrecip)
        lineChartDataSetPrecip.axisDependency = .right
        setPropsLineChartDataSet(lineChartDataSet: lineChartDataSetPrecip, color: .blue)
        lineChartData = LineChartData(dataSets: [lineChartDataSetTemp, lineChartDataSetWind, lineChartDataSetPrecip])
        chartView.data = lineChartData
        chartView.xAxis.setLabelCount(times.count, force: true)
    }
    func setPropsLineChartDataSet (lineChartDataSet: LineChartDataSet, color: UIColor){
        lineChartDataSet.setColor(color)
        lineChartDataSet.lineWidth = 2.5
        lineChartDataSet.circleRadius = 3.5
        lineChartDataSet.drawCircleHoleEnabled = false
        lineChartDataSet.circleColors = [color]
        lineChartDataSet.mode = .cubicBezier
    }
    func setPrecipLabel(day: Int) -> String {
        var precipLabel: String = "kein Niederschlag"
        
        if weatherData.daily.data[day].precipType != nil {
            if weatherData.daily.data[day].precipType == "snow" {
                precipLabel = "Schnee"
            } else if weatherData.daily.data[day].precipType == "rain" {
                precipLabel = "Regen"
            }else {
                precipLabel = "Hagel"
            }
            precipLabel.append("wahrsch. [%]")
        } else if weatherData.daily.data[day].precipType == nil && weatherData.daily.data[day+1].precipType != nil  {
            if weatherData.daily.data[day+1].precipType == "snow" {
                precipLabel = "Schnee"
            } else if weatherData.daily.data[day+1].precipType == "rain" {
                precipLabel = "Regen"
            }else {
                precipLabel = "Hagel"
            }
            precipLabel.append("wahrsch. [%]")
        }
        return precipLabel
    }
    
    func clearWeatherData() {
        times.removeAll()
        wind.removeAll()
        temprature.removeAll()
        precip.removeAll()
    }
    func fillWeatherDataTodayHours() {
        for hours in weatherData.hourly.data {
            if hours.time >= datahandler.sunriseTimeToday && hours.time <= datahandler.sunsetTimeToday{
                times.append(hours.time)
                temprature.append(hours.temperature)
                wind.append(hours.windSpeed)
                precip.append(hours.precipProbability)
            }
        }
    }
    func fillWeatherDataTomorrowHours() {
        for hours in weatherData.hourly.data {
            if hours.time >= datahandler.sunriseTimeTomorrow && hours.time <= datahandler.sunsetTimeTomorrow{
                times.append(hours.time)
                temprature.append(hours.temperature)
                wind.append(hours.windSpeed)
                precip.append(hours.precipProbability)
            }
        }
    }
    func fillWeatherDataDays() {
        for days in weatherData.daily.data {
            if days.time != nil{
                times.append(days.time)
                temprature.append(days.temperatureMax)
                wind.append(days.windSpeed)
                precip.append(days.precipProbability)
            }
        }
    }

    func addWeatherToday() {
        clearWeatherData()
        fillWeatherDataTodayHours()
        if times.count <= 0 {
            clearWeatherData()
            fillWeatherDataTomorrowHours()
            textfield.text = "Wetter von Morgen!! \n"
            textfield.text.append(weatherData.daily.data[1].summary)
            setLineCharts(dataPoints: times, valuesTemp: temprature, valuesWind: wind, valuesPrecip: precip, labelPrecip: setPrecipLabel(day: 1))
        }else{
            textfield.text = weatherData.daily.data[0].summary
            setLineCharts(dataPoints: times, valuesTemp: temprature, valuesWind: wind, valuesPrecip: precip, labelPrecip: setPrecipLabel(day: 0))
        }
        
        chartView.xAxis.valueFormatter = DateValueFormatterHour()
        chartView.notifyDataSetChanged()
    }
    func addWeatherTomorrow() {
        clearWeatherData()
        fillWeatherDataTomorrowHours()
        setLineCharts(dataPoints: times, valuesTemp: temprature, valuesWind: wind, valuesPrecip: precip, labelPrecip: setPrecipLabel(day: 1))
        chartView.xAxis.valueFormatter = DateValueFormatterHour()
        textfield.text = weatherData.daily.data[1].summary
        chartView.notifyDataSetChanged()
    }
    func addWeatherWeek() {
        clearWeatherData()
        fillWeatherDataDays()
        setLineCharts(dataPoints: times, valuesTemp: temprature, valuesWind: wind, valuesPrecip: precip, labelPrecip: setPrecipLabel(day: 3))
        chartView.xAxis.valueFormatter = DateValueFormatterDay()
        textfield.text = weatherData.daily.summary
        chartView.notifyDataSetChanged()
    }
    func setBestFlyTime (dataPoints: [Int]) {
        
    }
    
    func showActivityIndicatory(uiView: UIView) {
        chartView.noDataText = "Fetching Data..."
        actInd.frame = CGRect(x: 0.0, y: 0.0, width: 50.0, height: 50.0)
        actInd.center.x = uiView.center.x
        actInd.center.y = uiView.center.y-60.0
        actInd.hidesWhenStopped = true
        actInd.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.whiteLarge
        uiView.addSubview(actInd)
        actInd.startAnimating()
    }
}

